import os
import json
import time
import subprocess
from datetime import datetime
from typing import Dict, Any, List, Tuple

# ====== 설정 ======
ROOT_DIR = "../../llm_to_IR/chatGPT_api_query_promt/O0/repeat_5/"   # 1,2,3,4,5 폴더가 있는 루트
AS = "llvm-as-14"
LINK = "llvm-link-14"
CLANG = "clang-14"
RUN_TIMEOUT_SEC = 15      # 바이너리 실행 타임아웃
TRUNCATE_IO = 20000       # stdout/stderr 저장 길이 제한 (문자)
# ==================

def now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")

def run_cmd(cmd: List[str], cwd: str, timeout: int | None = None) -> Dict[str, Any]:
    t0 = time.perf_counter()
    try:
        p = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=timeout,
            check=False,
        )
        dt = time.perf_counter() - t0
        out = (p.stdout or "")
        err = (p.stderr or "")
        if TRUNCATE_IO:
            out = out[:TRUNCATE_IO]
            err = err[:TRUNCATE_IO]
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
            "stdout": (e.stdout or "")[:TRUNCATE_IO] if hasattr(e, "stdout") else "",
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

def find_round_dirs(root: str) -> List[str]:
    if not os.path.isdir(root):
        return []
    # 숫자 폴더(1..5)만, 숫자 기준 정렬
    dirs = [d for d in os.listdir(root) if os.path.isdir(os.path.join(root, d)) and d.isdigit()]
    dirs.sort(key=lambda x: int(x))
    return [os.path.join(root, d) for d in dirs]

def pair_ll_files(ll_files: List[str]) -> Tuple[Dict[str, Dict[str, str]], List[str]]:
    """
    return:
      pairs: { base: {"base_ll": path, "main_ll": path} }  (둘 다 있는 경우만)
      orphan: 짝이 없는 .ll 파일 목록
    """
    base_map: Dict[str, Dict[str, str]] = {}
    have_main: set[str] = set()
    have_base: set[str] = set()
    for f in ll_files:
        name = os.path.basename(f)
        if not name.endswith(".ll"):
            continue
        if name.endswith("_main.ll"):
            base = name[:-len("_main.ll")]
            base_map.setdefault(base, {})
            base_map[base]["main_ll"] = f
            have_main.add(base)
        else:
            base = name[:-3]
            base_map.setdefault(base, {})
            base_map[base]["base_ll"] = f
            have_base.add(base)

    pairs: Dict[str, Dict[str, str]] = {}
    orphan: List[str] = []
    for base, parts in base_map.items():
        if "base_ll" in parts and "main_ll" in parts:
            pairs[base] = {"base_ll": parts["base_ll"], "main_ll": parts["main_ll"]}
        else:
            # 짝이 안 맞으면 orphan 처리
            if "base_ll" in parts:
                orphan.append(parts["base_ll"])
            if "main_ll" in parts:
                orphan.append(parts["main_ll"])
    return pairs, orphan

def build_and_run_one(round_dir: str, base: str, base_ll: str, main_ll: str) -> Dict[str, Any]:
    """
    한 프로그램 파이프라인:
      llvm-as-14 base.ll      -o base.bc
      llvm-as-14 base_main.ll -o base_main.bc
      llvm-link-14 base_main.bc base.bc -o base.bc
      clang-14 -O0 base.bc -o base
      ./base
    실패 시 이후 단계는 실행하지 않고 'skipped_due_to_previous_error'로 표기.
    """
    rel_base_ll = os.path.basename(base_ll)
    rel_main_ll = os.path.basename(main_ll)
    base_bc = f"{base}.bc"
    main_bc = f"{base}_main.bc"
    exe = base  # 실행 파일 이름

    result: Dict[str, Any] = {
        "program": base,
        "files": {
            "base_ll": rel_base_ll,
            "main_ll": rel_main_ll,
            "base_bc": base_bc,
            "main_bc": main_bc,
            "linked_bc": base_bc,   # 명세대로 link 출력이 base.bc를 덮어씀
            "exe": exe,
        },
        "started_at": now_iso(),
        "steps": [],
        "success": False,
        "ended_at": None,
        "run": None,
    }

    # 1) assemble base.ll
    step = run_cmd([AS, rel_base_ll, "-o", base_bc], cwd=round_dir)
    step["name"] = "llvm-as(base)"
    result["steps"].append(step)
    if not step["success"]:
        result["ended_at"] = now_iso()
        return result

    # 2) assemble main.ll
    step = run_cmd([AS, rel_main_ll, "-o", main_bc], cwd=round_dir)
    step["name"] = "llvm-as(main)"
    result["steps"].append(step)
    if not step["success"]:
        result["ended_at"] = now_iso()
        return result

    # 3) link (order: main.bc then base.bc)
    step = run_cmd([LINK, main_bc, base_bc, "-o", base_bc], cwd=round_dir)
    step["name"] = "llvm-link"
    result["steps"].append(step)
    if not step["success"]:
        result["ended_at"] = now_iso()
        return result

    # 4) clang link to exe
    step = run_cmd([CLANG, "-O0", base_bc, "-o", exe], cwd=round_dir)
    step["name"] = "clang-link"
    result["steps"].append(step)
    if not step["success"]:
        result["ended_at"] = now_iso()
        return result

    # 5) run exe
    run_step = run_cmd([f"./{exe}"], cwd=round_dir, timeout=RUN_TIMEOUT_SEC)
    run_step["name"] = "run"
    result["steps"].append(run_step)
    result["run"] = {
        "stdout": run_step.get("stdout", ""),
        "stderr": run_step.get("stderr", ""),
        "returncode": run_step.get("returncode"),
        "elapsed_sec": run_step.get("elapsed_sec"),
        "success": run_step.get("success", False),
    }

    result["success"] = all(s.get("success", False) for s in result["steps"] if s["name"] != "run") and run_step.get("success", False)
    result["ended_at"] = now_iso()
    return result

def process_round(round_dir: str) -> Dict[str, Any]:
    round_name = os.path.basename(round_dir)
    entry: Dict[str, Any] = {
        "round": round_name,
        "round_dir": round_dir,
        "started_at": now_iso(),
        "pairs_built": [],
        "orphans": [],
        "ended_at": None,
    }

    # 라운드 폴더 내 .ll 수집
    ll_files = [os.path.join(round_dir, f) for f in os.listdir(round_dir) if f.endswith(".ll")]
    pairs, orphan = pair_ll_files(ll_files)
    entry["orphans"] = [os.path.basename(x) for x in sorted(orphan)]

    # 각 pair 처리
    for base in sorted(pairs.keys()):
        p = pairs[base]
        one = build_and_run_one(round_dir, base, p["base_ll"], p["main_ll"])
        entry["pairs_built"].append(one)

    # 라운드별 로그 저장
    per_round_log = os.path.join(round_dir, "build_run_log.json")
    with open(per_round_log, "w", encoding="utf-8") as f:
        json.dump(entry, f, ensure_ascii=False, indent=2)

    entry["ended_at"] = now_iso()
    return entry

def main():
    master: Dict[str, Any] = {
        "root": os.path.abspath(ROOT_DIR),
        "started_at": now_iso(),
        "rounds": [],
        "ended_at": None,
    }

    round_dirs = find_round_dirs(ROOT_DIR)
    if not round_dirs:
        print(f"⚠️ 라운드 폴더(숫자명)가 {ROOT_DIR} 아래에 없습니다.")
    for rd in round_dirs:
        print(f"== Round {os.path.basename(rd)} ==")
        master["rounds"].append(process_round(rd))

    master["ended_at"] = now_iso()
    master_log = os.path.join(ROOT_DIR, "compile_run_report.json")
    with open(master_log, "w", encoding="utf-8") as f:
        json.dump(master, f, ensure_ascii=False, indent=2)

    print(f"\n📄 마스터 리포트 저장: {master_log}")

if __name__ == "__main__":
    main()
