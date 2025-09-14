# eval_main.py
import os, json, csv, re
from typing import Dict, List
from ir_validity import evaluate_ir_validity
from ir_link_run import link_build_and_compare   # ← ir_similarity import 제거됨

# ========= 사용자 설정 =========
CAND_ROOT      = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis2/1"
REF_LL_ROOT    = "/home/nata20034/workspace/convert_to_IR_with_LLM/original/ll"
REF_BIN_ROOT   = "/home/nata20034/workspace/convert_to_IR_with_LLM/original/binary/O0"

OUT_ROOT       = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis2/1"
ROUND_NAME     = "eval"

LLVM_AS       = "llvm-as-14"
OPT_BIN       = "opt-14"
LLC_BIN       = "llc-14"
CLANG         = "clang-14"
OPT_LEVEL     = "-O0"

EXTRA_LINK_ARGS     = []
RUN_ARGS            = []
# =======================================

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

def _append_minimal(json_path: str, file_path: str, ok: bool, err: int, errmsg: str = ""):
    parent = os.path.basename(os.path.dirname(os.path.abspath(file_path)))
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
    parent = os.path.basename(os.path.dirname(os.path.abspath(file_path)))
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
    print(f"[2/2] Link&Run: grouping by base and building combined units")
    groups = _group_by_base(cand_lls)
    for base, parts in groups.items():
        ok, err, errmsg = link_build_and_compare(
            parts=parts,
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
