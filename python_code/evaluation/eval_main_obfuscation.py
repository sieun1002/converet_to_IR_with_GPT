# eval_main_ofuscation.py 이건 26.01.08에 난독화 적용된 bubblesort를 평가하기 위해 만든 파일이다. 
# bubblesort.IP_RP/ll 처럼 네이밍된 폴더를 하나씩 넣어주면 됨.

# eval_main.py
import os, json, csv, re, sys
from typing import Dict, List
from ir_validity import evaluate_ir_validity
from ir_link_run import link_build_and_compare   # ← ir_similarity import 제거됨

# ========= 사용자 설정 =========
CAND_ROOT      = "/root/workspace/converet_to_IR_with_GPT/llm_to_IR/window_obfuscation_bubble_not_change_system_prompt/O0/option/bubblesort.IP_RP/1/ll"
REF_LL_ROOT    = "/root/workspace/convert_to_IR_with_LLM/original/ll"
REF_BIN_ROOT   = "/root/workspace/convert_to_IR_with_LLM/original/binary/O0"

OUT_ROOT       = "/root/workspace/converet_to_IR_with_GPT/llm_to_IR/window_obfuscation_bubble_not_change_system_prompt/O0/option/bubblesort.IP/1"
ROUND_NAME     = "eval"

LLVM_AS       = "llvm-as-14"
OPT_BIN       = "opt-14"
LLC_BIN       = "llc-14"
CLANG         = "clang-14"
OPT_LEVEL     = "-O0"

EXTRA_LINK_ARGS     = []
RUN_ARGS            = []
# =======================================

# ===== NEW: CLI로 CAND_ROOT만 덮어쓰기 (선택) =====
# 사용 예:
#   python3 eval_main.py /root/.../bubblesort.IP/1/ll
if len(sys.argv) >= 2:
    CAND_ROOT = sys.argv[1]
# ===============================================

def _csv_path(root: str, name: str) -> str:
    os.makedirs(root, exist_ok=True)
    return os.path.join(root, f"{name}.csv")

def _ensure_dir(p): os.makedirs(p, exist_ok=True)

def _json_path(root: str, name: str) -> str:
    _ensure_dir(root)
    path = os.path.join(root, f"{name}.json")
    if not os.path.exists(path):
        with open(path, "w", encoding="utf-8") as f:
            json.dump({"entries": []}, f, ensure_ascii=False, indent=2)
    return path

# ===== NEW: 케이스 태그/베이스 추출 (폴더 기반) =====
def _infer_case_tag_from_path(path: str) -> str:
    """
    기대 구조:
      .../<base.option>/<trial>/ll/<file.ll>
    예:
      .../bubblesort.IP/1/ll/foo.ll  -> "bubblesort.IP/1"
    구조가 다르면 기존 방식(parent=직전폴더명)으로 fallback.
    """
    try:
        p = os.path.abspath(path)
        ll_dir = os.path.dirname(p)  # .../ll
        trial = os.path.basename(os.path.dirname(ll_dir))  # "1"
        progopt = os.path.basename(os.path.dirname(os.path.dirname(ll_dir)))  # "bubblesort.IP"
        if progopt and trial:
            return f"{progopt}/{trial}"
    except Exception:
        pass
    # fallback: 기존처럼 file의 직전 폴더명
    return os.path.basename(os.path.dirname(os.path.abspath(path)))

def _infer_base_from_cand_root(cand_root: str) -> str:
    """
    cand_root가 .../<base.option>/<trial>/ll 형태일 때 base.option에서 base만 추출.
    예: bubblesort.IP -> bubblesort
    실패 시 빈 문자열 반환.
    """
    try:
        cand_root = os.path.abspath(cand_root.rstrip("/"))
        trial_dir = os.path.dirname(cand_root)              # .../<trial>
        progopt_dir = os.path.dirname(trial_dir)            # .../<base.option>
        progopt = os.path.basename(progopt_dir)             # "bubblesort.IP"
        if "." in progopt:
            return progopt.split(".", 1)[0]
    except Exception:
        pass
    return ""
# ===============================================

def _append_minimal(json_path: str, file_path: str, ok: bool, err: int, errmsg: str = ""):
    # CHANGED: parent를 케이스 태그로 기록
    parent = _infer_case_tag_from_path(file_path)
    name   = os.path.basename(file_path)
    entry = {
        "file": name,
        "parent": parent,
        "ok": bool(ok),
        "err": int(err if err is not None else (0 if ok else -1)),
    }
    if errmsg:
        entry["errmsg"] = errmsg.strip()
    with open(json_path, "r+", encoding="utf-8") as f:
        data = json.load(f) or {}
        if "entries" not in data or not isinstance(data["entries"], list):
            data["entries"] = []
        data["entries"].append(entry)
        f.seek(0); json.dump(data, f, ensure_ascii=False, indent=2); f.truncate()

def _append_csv_row(csv_path: str, file_path: str, ok: bool, err: int,
                    extra_cols: List[str] | None = None, errmsg: str = ""):
    # CHANGED: parent를 케이스 태그로 기록
    parent = _infer_case_tag_from_path(file_path)
    name   = os.path.basename(file_path)
    row = [name, parent, bool(ok), int(err if err is not None else (0 if ok else -1))]
    if extra_cols:
        row += extra_cols
    if errmsg:
        row.append(errmsg.replace("\n", "\\n"))
    with open(csv_path, "a", newline="", encoding="utf-8") as f:
        csv.writer(f).writerow(row)

def _iter_ll_files(root: str) -> List[str]:
    allf = []
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if fn.lower().endswith(".ll") and not fn.endswith(".norm.ll"):
                allf.append(os.path.join(dirpath, fn))
    return sorted(allf)

def extract_base(bn: str) -> str:
    stem = bn[:-3]  # .ll 제거
    patterns = [
        (r"_single_main\d*$", "_single"),
        (r"_single_function\d*$", "_single"),
        (r"_modular_main\d*$", "_modular"),
        (r"_modular_function\d*$", "_modular"),
        (r"_main\d*$", ""),
        (r"_function\d*$", ""),
    ]
    for pat, repl in patterns:
        if re.search(pat, stem):
            return re.sub(pat, repl, stem)
    return stem

def _group_by_base(ll_files: List[str]) -> Dict[str, List[str]]:
    groups: Dict[str, List[str]] = {}
    for p in ll_files:
        bn = os.path.basename(p)
        base = extract_base(bn)
        groups.setdefault(base, []).append(p)
    for b, lst in groups.items():
        lst.sort()
        lst.sort(key=lambda x: (0 if re.search(r"_main\d*\.ll$", x) else 1, x))
    return groups

def main():
    # CHANGED: 입력 경로 정규화 (상대경로도 OK)
    global CAND_ROOT, OUT_ROOT
    CAND_ROOT = os.path.abspath(CAND_ROOT)
    OUT_ROOT  = os.path.abspath(OUT_ROOT)

    round_dir   = os.path.join(OUT_ROOT, ROUND_NAME)
    _ensure_dir(round_dir)
    json1 = _json_path(round_dir, "validity")
    json3 = _json_path(round_dir, "linkrun")

    valid_csv = _csv_path(round_dir, "validity")
    link_csv  = _csv_path(round_dir, "linkrun")

    # 헤더 작성
    with open(valid_csv, "w", newline="", encoding="utf-8") as f:
        csv.writer(f).writerow(["file","parent","ok","err",
                                "assemble_ok","verify_ok","codegen_ok","errmsg"])
    with open(link_csv, "w", newline="", encoding="utf-8") as f:
        csv.writer(f).writerow(["file","parent","ok","err","errmsg"])

    # ===== 1) 유효성 평가 =====
    cand_lls = _iter_ll_files(CAND_ROOT)
    print(f"[1/2] Validity: scanning {len(cand_lls)} .ll files under {os.path.abspath(CAND_ROOT)}")

    for cand in cand_lls:
        res = evaluate_ir_validity(cand, llvm_as=LLVM_AS, opt=OPT_BIN, llc=LLC_BIN, timeout_sec=60)
        ok = res["ok"]
        err = 0 if ok else (
            res["codegen_rc"] if not res["codegen_ok"]
            else res["verify_rc"] if not res["verify_ok"]
            else res["assemble_rc"]
        )
        errmsg = res.get("errmsg", "")
        _append_minimal(json1, cand, ok, err, errmsg)
        _append_csv_row(valid_csv, cand, ok, err,
                        extra_cols=[res["assemble_ok"], res["verify_ok"], res["codegen_ok"]],
                        errmsg=errmsg)
        print(f"  - {os.path.basename(cand)} → ok={ok} err={err}")

    # ===== 2) 합본 → 빌드/링크 → 실행 비교 =====
    # CHANGED: 이제는 "폴더 하나 = 프로그램 하나"로 보고,
    #          base를 폴더명(bubblesort.IP)에서 뽑아서 그 base로 한 번만 link&run 수행.
    print(f"[2/2] Link&Run: link all .ll files in this folder as one unit")

    base_from_dir = _infer_base_from_cand_root(CAND_ROOT)

    # parts 정렬: _main 우선(있을 때)
    parts = list(cand_lls)
    parts.sort()
    parts.sort(key=lambda x: (0 if re.search(r"_main\d*\.ll$", os.path.basename(x)) else 1, x))

    if base_from_dir:
        base = base_from_dir
        ref_exe = os.path.join(REF_BIN_ROOT, base)

        ok, err, errmsg = link_build_and_compare(
            parts=parts,
            out_dir=round_dir,
            base=base,
            clang=CLANG,
            extra_link_args=EXTRA_LINK_ARGS,
            ref_exe=ref_exe,
            run_args=RUN_ARGS,
            timeout_sec=120,
        )
        combined_ll = os.path.join(round_dir, f"{base}.ll")
        _append_minimal(json3, combined_ll, ok, err, errmsg)
        _append_csv_row(link_csv, combined_ll, ok, err, errmsg=errmsg)
        print(f"  - {base} → ok={ok} err={err}")
    else:
        # fallback: 폴더에서 base 추출 실패하면 예전 로직 유지
        print("[!] Could not infer base from folder name. Falling back to filename-based grouping.")
        groups = _group_by_base(cand_lls)
        for base, parts2 in groups.items():
            ok, err, errmsg = link_build_and_compare(
                parts=parts2,
                out_dir=round_dir,
                base=base,
                clang=CLANG,
                extra_link_args=EXTRA_LINK_ARGS,
                ref_exe=os.path.join(REF_BIN_ROOT, base),
                run_args=RUN_ARGS,
                timeout_sec=120,
            )
            combined_ll = os.path.join(round_dir, f"{base}.ll")
            _append_minimal(json3, combined_ll, ok, err, errmsg)
            _append_csv_row(link_csv, combined_ll, ok, err, errmsg=errmsg)
            print(f"  - {base} → ok={ok} err={err}")

    print("\n✅ EVAL DONE")
    print(f"  • json1(validity):   {os.path.join(round_dir, 'validity.json')}")
    print(f"  • json3(linkrun):    {os.path.join(round_dir, 'linkrun.json')}")

if __name__ == "__main__":
    main()
