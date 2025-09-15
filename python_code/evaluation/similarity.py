#!/usr/bin/env python3
import os
import subprocess
import json
from typing import Dict

OPT_BIN = "opt-14"
NORMALIZE_PASSES = "mem2reg,sroa,instcombine,simplifycfg,gvn,adce"

# ========== 정규화 함수 ==========
def normalize_ir(in_ll: str, out_dir: str) -> str:
    """opt로 정규화한 ll 파일을 지정된 폴더에 저장하고, 그 경로를 반환"""
    os.makedirs(out_dir, exist_ok=True)
    base = os.path.basename(in_ll)
    out_path = os.path.join(out_dir, base.replace(".ll", ".norm.ll"))

    cmd = [OPT_BIN, f"-passes={NORMALIZE_PASSES}", in_ll, "-S", "-o", out_path]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[!] opt 실패: {in_ll}")
        print(result.stderr)
        return in_ll  # 실패 시 원본 파일 경로 반환
    return out_path

# ========== IR 파서 ==========
def parse_ir_stats(ll_path: str):
    stats = {
        "total": 0,
        "load": 0,
        "store": 0,
        "phi": 0,
        "alloca": 0,
        "call": 0,
    }
    if not os.path.isfile(ll_path):
        return stats

    with open(ll_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith(";"):
                continue

            if "=" in line:
                parts = line.split("=", 1)
                if len(parts) > 1:
                    op = parts[1].strip().split()[0]
                else:
                    continue
            else:
                op = line.split()[0]

            stats["total"] += 1
            if op in stats:
                stats[op] += 1
    return stats

# ========== 비교 함수 ==========
def compare_ir(ref_stats: Dict[str, int], cand_stats: Dict[str, int]) -> Dict[str, float]:
    results = {}

    ref_total = ref_stats["total"]
    cand_total = cand_stats["total"]

    # inst_rel_error: 0~1 범위, 구조적 차이 비율
    if ref_total == 0 and cand_total == 0:
        results["inst_rel_error"] = 0.0
    elif ref_total == 0 or cand_total == 0:
        results["inst_rel_error"] = 1.0
    else:
        results["inst_rel_error"] = 1.0 - min(ref_total, cand_total) / max(ref_total, cand_total)

    def mem_ratio(s):
        return (s["load"] + s["store"]) / s["total"] if s["total"] > 0 else 0.0

    results["mem_ratio_gap"] = abs(mem_ratio(ref_stats) - mem_ratio(cand_stats))
    results["phi_after_norm"] = cand_stats["phi"]
    results["alloca_after_norm"] = cand_stats["alloca"]
    results["call_count"] = cand_stats["call"]

    return results


# ========== 실행 예시 ==========
def main():
    # 사용자가 직접 설정
    ref_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM/original/ll"
    mcsema_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0"
    llm_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/6"

    out_norm_root = "./similarity_inte/6"
    out_json_file = "./similarity_inte/6/similarity.json"   # JSON 저장 경로

    all_results = []

    # 공통 파일 목록
    files = set(os.listdir(ref_dir)) & set(os.listdir(mcsema_dir)) & set(os.listdir(llm_dir))
    files = [f for f in files if f.endswith(".ll")]

    for fname in sorted(files):
        print(f"\n=== {fname} ===")
        ref_path = os.path.join(ref_dir, fname)
        mcsema_path = os.path.join(mcsema_dir, fname)
        llm_path = os.path.join(llm_dir, fname)

        # 정규화 결과를 지정 폴더에 저장
        ref_norm = normalize_ir(ref_path, os.path.join(out_norm_root, "ref"))
        mcsema_norm = normalize_ir(mcsema_path, os.path.join(out_norm_root, "mcsema"))
        llm_norm = normalize_ir(llm_path, os.path.join(out_norm_root, "llm"))

        # 통계 계산
        ref_stats = parse_ir_stats(ref_norm)
        mcsema_stats = parse_ir_stats(mcsema_norm)
        llm_stats = parse_ir_stats(llm_norm)

        # 비교 결과
        mcsema_vs_ref = compare_ir(ref_stats, mcsema_stats)
        llm_vs_ref = compare_ir(ref_stats, llm_stats)

        # 출력
        print("  mcsema vs ref")
        for k, v in mcsema_vs_ref.items():
            print(f"    {k}: {v}")

        print("  llm vs ref")
        for k, v in llm_vs_ref.items():
            print(f"    {k}: {v}")

        print("  ref 자체 지표")
        print(f"    phi: {ref_stats['phi']}")
        print(f"    alloca: {ref_stats['alloca']}")
        print(f"    call: {ref_stats['call']}")

        # JSON에 기록할 결과 추가
        all_results.append({
            "filename": fname,
            "ref_stats": ref_stats,
            "mcsema_stats": mcsema_stats,
            "llm_stats": llm_stats,
            "mcsema_vs_ref": mcsema_vs_ref,
            "llm_vs_ref": llm_vs_ref,
        })

    # JSON 저장
    os.makedirs(os.path.dirname(out_json_file), exist_ok=True)
    with open(out_json_file, "w", encoding="utf-8") as f:
        json.dump(all_results, f, indent=2, ensure_ascii=False)

    print(f"\n✅ 전체 결과 JSON 저장 완료 → {out_json_file}")


if __name__ == "__main__":
    main()
