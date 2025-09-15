#!/usr/bin/env python3
import os
import difflib
import json

# ========== 폴더 경로 직접 지정 ==========
REF_DIR    = "/home/nata20034/workspace/convert_to_IR_with_LLM/original/ll"
MCSEMA_DIR = "/home/nata20034/workspace/convert_to_IR_with_LLM_copy/mcsema_to_IR/ll"
LLM_DIR    = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1"

# 결과 저장 경로
OUT_DIFF_DIR = "./diff_results/1"
OUT_JSON_FILE = "./diff_results/diff.json"


# ========== 비교 함수 ==========
def compare_and_save(ref_path: str, cand_path: str, tag: str, out_dir: str):
    with open(ref_path, encoding="utf-8") as f:
        ref_lines = f.readlines()
    with open(cand_path, encoding="utf-8") as f:
        cand_lines = f.readlines()

    # --- 줄 차이 계산 ---
    diff_count = 0
    ndiff_result = list(difflib.ndiff(ref_lines, cand_lines))
    for d in ndiff_result:
        if d.startswith("+ ") or d.startswith("- "):
            diff_count += 1

    # --- 유사도 퍼센트 ---
    sm = difflib.SequenceMatcher(None, ref_lines, cand_lines)
    similarity = sm.ratio() * 100

    # --- 결과 객체 ---
    result = {
        "tag": tag,
        "ref_lines": len(ref_lines),
        "cand_lines": len(cand_lines),
        "different_lines": diff_count,
        "similarity_percent": round(similarity, 2),
        "ndiff_file": os.path.join(out_dir, f"{tag}_ndiff.txt"),
        "udiff_file": os.path.join(out_dir, f"{tag}_udiff.txt"),
    }

    # --- 결과 출력 ---
    print(f"[{tag}]")
    print(f"  ref_lines       = {result['ref_lines']}")
    print(f"  cand_lines      = {result['cand_lines']}")
    print(f"  different_lines = {result['different_lines']}")
    print(f"  similarity      = {result['similarity_percent']}%")

    # 결과 저장 디렉토리 생성
    os.makedirs(out_dir, exist_ok=True)

    # --- ndiff 저장 ---
    with open(result["ndiff_file"], "w", encoding="utf-8") as f:
        f.writelines(ndiff_result)

    # --- unified diff 저장 ---
    udiff_result = list(difflib.unified_diff(
        ref_lines, cand_lines,
        fromfile="ref.ll",
        tofile=f"{tag}.ll"
    ))
    with open(result["udiff_file"], "w", encoding="utf-8") as f:
        f.writelines(udiff_result)

    return result


# ========== 실행 ==========
if __name__ == "__main__":
    os.makedirs(OUT_DIFF_DIR, exist_ok=True)
    all_results = []

    # 세 폴더에서 공통으로 존재하는 파일만 비교
    files = set(os.listdir(REF_DIR)) & set(os.listdir(MCSEMA_DIR)) & set(os.listdir(LLM_DIR))
    files = [f for f in files if f.endswith(".ll")]

    for fname in sorted(files):
        print(f"\n=== {fname} ===")
        ref_path = os.path.join(REF_DIR, fname)
        mcsema_path = os.path.join(MCSEMA_DIR, fname)
        llm_path = os.path.join(LLM_DIR, fname)

        # ref vs mcsema
        res1 = compare_and_save(ref_path, mcsema_path, f"{fname}_mcsema_vs_ref", OUT_DIFF_DIR)
        all_results.append(res1)

        # ref vs llm
        res2 = compare_and_save(ref_path, llm_path, f"{fname}_llm_vs_ref", OUT_DIFF_DIR)
        all_results.append(res2)

    # --- JSON 저장 ---
    with open(OUT_JSON_FILE, "w", encoding="utf-8") as f:
        json.dump(all_results, f, indent=2, ensure_ascii=False)

    print(f"\n✅ 전체 비교 결과 JSON 저장 완료 → {OUT_JSON_FILE}")
