# ll_build_module.py (업데이트판)
import os
import json
import time
import tempfile
import subprocess
from pathlib import Path
from datetime import datetime
from typing import Any, Dict, List, Optional

DEFAULT_AS = "llvm-as-14"
DEFAULT_LINK = "llvm-link-14"
DEFAULT_CLANG = "clang-14"

def now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")

def run_cmd(cmd: List[str], cwd: Optional[str] = None, timeout: Optional[int] = None,
            truncate_io: int = 20000) -> Dict[str, Any]:
    t0 = time.perf_counter()
    try:
        p = subprocess.run(
            cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout, check=False
        )
        dt = time.perf_counter() - t0
        out = (p.stdout or "")
        err = (p.stderr or "")
        if truncate_io:
            out = out[:truncate_io]
            err = err[:truncate_io]
        return {
            "cmd": " ".join(cmd),
            "start_time": now_iso(),
            "elapsed_sec": round(dt, 6),
            "returncode": p.returncode,
            "stdout": out,
            "stderr": err,
            "success": (p.returncode == 0),
        }
    except subprocess.TimeoutExpired as e:
        dt = time.perf_counter() - t0
        return {
            "cmd": " ".join(cmd),
            "start_time": now_iso(),
            "elapsed_sec": round(dt, 6),
            "returncode": None,
            "stdout": (getattr(e, "stdout", "") or "")[:truncate_io],
            "stderr": f"TIMEOUT after {timeout}s",
            "success": False,
        }
    except Exception as e:
        dt = time.perf_counter() - t0
        return {
            "cmd": " ".join(cmd),
            "start_time": now_iso(),
            "elapsed_sec": round(dt, 6),
            "returncode": None,
            "stdout": "",
            "stderr": f"EXCEPTION: {e}",
            "success": False,
        }

def _ensure_ll(path: Path) -> None:
    if not path.exists():
        raise FileNotFoundError(f"LL file not found: {path}")
    if path.suffix != ".ll":
        raise ValueError(f"Not an .ll file: {path}")

def _common_exe_name(p1: Path, p2: Path) -> str:
    s1, s2 = p1.stem, p2.stem
    prefix = os.path.commonprefix([s1, s2]).strip("_- .")
    return prefix if prefix else s1

def _compact_json_from_steps_and_run(steps: List[Dict[str, Any]],
                                     run: Optional[Dict[str, Any]]) -> Dict[str, Any]:
    first_failed = next((s for s in steps if not s.get("success")), None)
    error = first_failed is not None
    where = first_failed.get("name") if first_failed else None

    if run is None:
        run_obj = None
    else:
        run_obj = {
            "stdout": run.get("stdout", ""),
            "stderr": run.get("stderr", ""),
            "returncode": run.get("returncode"),
            "elapsed_sec": run.get("elapsed_sec"),
            "success": run.get("success", False),
        }
    return {"error": error, "error_where": where, "run": run_obj}

def build_and_run_two_ll(
    ll1: str,
    ll2: str,
    out_dir: Optional[str] = None,
    as_bin: str = DEFAULT_AS,
    link_bin: str = DEFAULT_LINK,
    clang_bin: str = DEFAULT_CLANG,
    opt_level: str = "O0",
    run_timeout_sec: int = 15,
    truncate_io: int = 20000,
    exe_name: Optional[str] = None,
    link_order: str = "as_given",  # "as_given" | "reverse"
    keep_temps: bool = True,
    compact: bool = True,          # ★ 기본: 미니 JSON만 반환
) -> Dict[str, Any]:
    p1, p2 = Path(ll1).resolve(), Path(ll2).resolve()
    _ensure_ll(p1); _ensure_ll(p2)

    if out_dir is None:
        out_dir = str(p1.parent)
    else:
        Path(out_dir).mkdir(parents=True, exist_ok=True)

    tmp_ctx = None
    if not keep_temps:
        tmp_ctx = tempfile.TemporaryDirectory()
        out_dir = tmp_ctx.name

    out_dir_path = Path(out_dir)
    exe = exe_name or _common_exe_name(p1, p2)
    bc1 = out_dir_path / f"{p1.stem}.bc"
    bc2 = out_dir_path / f"{p2.stem}.bc"
    linked_bc = out_dir_path / f"{exe}.linked.bc"
    exe_path = out_dir_path / exe

    steps: List[Dict[str, Any]] = []
    run_result: Optional[Dict[str, Any]] = None

    # 1) assemble ll1 → bc1
    step = run_cmd([as_bin, str(p1), "-o", str(bc1)], cwd=str(out_dir_path))
    step["name"] = "llvm-as(ll1)"
    steps.append(step)
    if not step["success"]:
        res = _compact_json_from_steps_and_run(steps, None)
        if tmp_ctx: tmp_ctx.cleanup()
        return res

    # 2) assemble ll2 → bc2
    step = run_cmd([as_bin, str(p2), "-o", str(bc2)], cwd=str(out_dir_path))
    step["name"] = "llvm-as(ll2)"
    steps.append(step)
    if not step["success"]:
        res = _compact_json_from_steps_and_run(steps, None)
        if tmp_ctx: tmp_ctx.cleanup()
        return res

    # 3) link bc들 → linked_bc
    inputs = [str(bc1), str(bc2)] if link_order == "as_given" else [str(bc2), str(bc1)]
    step = run_cmd([DEFAULT_LINK, *inputs, "-o", str(linked_bc)], cwd=str(out_dir_path))
    step["name"] = "llvm-link"
    steps.append(step)
    if not step["success"]:
        res = _compact_json_from_steps_and_run(steps, None)
        if tmp_ctx: tmp_ctx.cleanup()
        return res

    # 4) clang → exe
    step = run_cmd([clang_bin, f"-{opt_level}", str(linked_bc), "-o", str(exe_path)], cwd=str(out_dir_path))
    step["name"] = "clang-link"
    steps.append(step)
    if not step["success"]:
        res = _compact_json_from_steps_and_run(steps, None)
        if tmp_ctx: tmp_ctx.cleanup()
        return res

    # 5) run exe
    run_step = run_cmd([f"./{exe_path.name}"], cwd=str(out_dir_path), timeout=run_timeout_sec, truncate_io=truncate_io)
    run_step["name"] = "run"
    steps.append(run_step)
    run_result = {
        "stdout": run_step.get("stdout", ""),
        "stderr": run_step.get("stderr", ""),
        "returncode": run_step.get("returncode"),
        "elapsed_sec": run_step.get("elapsed_sec"),
        "success": run_step.get("success", False),
    }

    if tmp_ctx:
        tmp_ctx.cleanup()

    # compact 모드면 3필드만 반환
    if compact:
        return _compact_json_from_steps_and_run(steps, run_result)
    # 혹시 확장 JSON이 필요하면 여기서 확장형을 리턴할 수도 있음
    return _compact_json_from_steps_and_run(steps, run_result)

# ---- CLI ----
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Build & run two .ll files → minimal JSON.")
    parser.add_argument("ll1")
    parser.add_argument("ll2")
    parser.add_argument("--out-dir", default=None)
    parser.add_argument("--as-bin", default=DEFAULT_AS)
    parser.add_argument("--link-bin", default=DEFAULT_LINK)
    parser.add_argument("--clang-bin", default=DEFAULT_CLANG)
    parser.add_argument("--opt", default="O0")
    parser.add_argument("--timeout", type=int, default=15)
    parser.add_argument("--truncate", type=int, default=20000)
    parser.add_argument("--exe-name", default=None)
    parser.add_argument("--link-order", choices=["as_given","reverse"], default="as_given")
    parser.add_argument("--keep-temps", action="store_true")
    parser.add_argument("--json-out", default=None, help="결과 JSON 저장 경로(지정 없으면 stdout)")
    args = parser.parse_args()

    res = build_and_run_two_ll(
        ll1=args.ll1, ll2=args.ll2, out_dir=args.out_dir,
        as_bin=args.as_bin, link_bin=args.link_bin, clang_bin=args.clang_bin,
        opt_level=args.opt, run_timeout_sec=args.timeout, truncate_io=args.truncate,
        exe_name=args.exe_name, link_order=args.link_order,
        keep_temps=args.keep_temps or bool(args.out_dir),
        compact=True,
    )

    if args.json_out:
        with open(args.json_out, "w", encoding="utf-8") as f:
            json.dump(res, f, ensure_ascii=False, indent=2)
    else:
        print(json.dumps(res, ensure_ascii=False, indent=2))


# 출력 형식
# {
#   "error": true,
#   "error_where": "llvm-link",
#   "run": null
# }