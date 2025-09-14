import subprocess
import os
from typing import List, Tuple, Dict, Any

def _run(cmd: List[str], timeout_sec: int) -> Tuple[bool, int, str, str]:
    try:
        p = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout_sec,
            check=False,
        )
        return (p.returncode == 0, p.returncode, p.stdout, p.stderr)
    except Exception as e:
        return (False, -1, "", str(e))

def link_build_and_compare(
    parts: List[str],
    out_dir: str,
    base: str,
    clang: str,
    extra_link_args: List[str],
    ref_exe: str,
    run_args: List[str],
    timeout_sec: int,
) -> Tuple[bool, int, str]:
    """
    여러 .ll 파일을 clang으로 직접 빌드 후 정답 실행파일과 비교
    반환: (ok, errcode, errmsg)
    """
    os.makedirs(out_dir, exist_ok=True)

    cand_exe = os.path.join(out_dir, base)   # 실행파일 이름 (확장자 없음)

    # 1) 빌드
    cmd_build = [clang, "-O0"] + parts + ["-o", cand_exe] + extra_link_args
    print("[$]", " ".join(cmd_build))
    ok, rc, _, err = _run(cmd_build, timeout_sec)
    if not ok:
        print(f"[build:fail] rc={rc}\n{err.strip()}")
        return False, -20, err.strip()

    # 2) 정답 실행파일 존재 확인
    if not os.path.exists(ref_exe):
        msg = f"[ref missing] {ref_exe}"
        print(msg)
        return False, -21, msg

    try:
        cand_out = subprocess.run(
            [cand_exe] + run_args, capture_output=True, text=True,
            timeout=timeout_sec, check=False
        )
        ref_out = subprocess.run(
            [ref_exe] + run_args, capture_output=True, text=True,
            timeout=timeout_sec, check=False
        )
    except Exception as e:
        msg = f"[run error] {e}"
        print(msg)
        return False, -22, msg

    if cand_out.returncode != 0:
        msg = f"[cand exe fail] rc={cand_out.returncode}\n{cand_out.stderr.strip()}"
        print(msg)
        return False, -23, msg

    if cand_out.stdout.strip() == ref_out.stdout.strip():
        return True, 0, ""
    else:
        msg = "[mismatch]\n--- cand ---\n" + cand_out.stdout + "\n--- ref ---\n" + ref_out.stdout
        print(msg)
        return False, -24, msg
