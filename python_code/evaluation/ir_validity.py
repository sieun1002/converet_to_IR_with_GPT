# ir_validity.py
import subprocess, os

def _run(cmd, timeout_sec=60):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True,
                           timeout=timeout_sec, check=False)
        return True, p.returncode, p.stdout, p.stderr
    except Exception:
        return False, None, "", ""

def evaluate_ir_validity(
    ll_path: str,
    *,
    llvm_as: str = "llvm-as-14",
    opt: str = "opt-14",
    llc: str = "llc-14",
    timeout_sec: int = 60,
):
    res = {}

    # 1) assemble
    ok_as, rc_as, _, _ = _run([llvm_as, ll_path, "-o", os.devnull], timeout_sec)
    res["assemble_ok"] = (ok_as and rc_as == 0)
    res["assemble_rc"] = rc_as if rc_as is not None else -1

    # 2) verify (신/구 패스 매니저 모두 시도)
    ok_v, rc_v, _, _ = _run([opt, "-passes=verify", ll_path, "-disable-output"], timeout_sec)
    if not (ok_v and rc_v == 0):
        ok_v2, rc_v2, _, _ = _run([opt, "-enable-new-pm=0", "-verify", ll_path, "-disable-output"], timeout_sec)
        res["verify_ok"] = (ok_v2 and rc_v2 == 0)
        res["verify_rc"] = rc_v2 if rc_v2 is not None else (rc_v if rc_v is not None else -1)
    else:
        res["verify_ok"] = True
        res["verify_rc"] = 0

    # 3) codegen
    ok_llc, rc_llc, _, _ = _run([llc, ll_path, "-filetype=obj", "-o", os.devnull], timeout_sec)
    res["codegen_ok"] = (ok_llc and rc_llc == 0)
    res["codegen_rc"] = rc_llc if rc_llc is not None else -1

    # 최종
    res["ok"] = res["assemble_ok"] and res["verify_ok"] and res["codegen_ok"]
    return res
