#!/usr/bin/env python3
import os
import subprocess
import tempfile
from typing import Dict

OPT_BIN = "opt-14"
NORMALIZE_PASSES = "mem2reg,sroa,instcombine,simplifycfg,gvn,adce"

# ========== 정규화 함수 ==========
def normalize_ir(in_ll: str) -> str:
    """opt로 정규화한 임시 ll 파일 경로를 반환"""
    tmp_fd, tmp_path = tempfile.mkstemp(suffix=".ll")
    os.close(tmp_fd)  # 파일디스크립터 닫고 경로만 사용
    cmd = [OPT_BIN, f"-passes={NORMALIZE_PASSES}", in_ll, "-S", "-o", tmp_path]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[!] opt 실패: {in_ll}")
        print(result.stderr)
        return in_ll  # 실패 시 원본 파일 사용
    return tmp_path

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
    if ref_total > 0:
        results["inst_rel_error"] = abs(cand_total - ref_total) / ref_total
    else:
        results["inst_rel_error"] = float("inf")

    def mem_ratio(s):
        return (s["load"] + s["store"]) / s["total"] if s["total"] > 0 else 0.0

    results["mem_ratio_gap"] = abs(mem_ratio(ref_stats) - mem_ratio(cand_stats))
    results["phi_after_norm"] = cand_stats["phi"]
    results["alloca_after_norm"] = cand_stats["alloca"]
    results["call_count"] = cand_stats["call"]

    return results

# ========== 실행 예시 ==========
def main():
    ref_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM/original/ll"
    mcsema_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM_copy/mcsema_to_IR/ll"
    llm_dir = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_query/3/bc"

    files = set(os.listdir(ref_dir)) & set(os.listdir(mcsema_dir)) & set(os.listdir(llm_dir))
    files = [f for f in files if f.endswith(".ll")]

    for fname in sorted(files):
        print(f"\n=== {fname} ===")
        ref_path = os.path.join(ref_dir, fname)
        mcsema_path = os.path.join(mcsema_dir, fname)
        llm_path = os.path.join(llm_dir, fname)

        ref_norm = normalize_ir(ref_path)
        mcsema_norm = normalize_ir(mcsema_path)
        llm_norm = normalize_ir(llm_path)

        ref_stats = parse_ir_stats(ref_norm)
        mcsema_stats = parse_ir_stats(mcsema_norm)
        llm_stats = parse_ir_stats(llm_norm)

        print("  mcsema vs ref")
        for k, v in compare_ir(ref_stats, mcsema_stats).items():
            print(f"    {k}: {v}")

        print("  llm vs ref")
        for k, v in compare_ir(ref_stats, llm_stats).items():
            print(f"    {k}: {v}")

        print("  ref 자체 지표")
        print(f"    phi: {ref_stats['phi']}")
        print(f"    alloca: {ref_stats['alloca']}")
        print(f"    call: {ref_stats['call']}")

if __name__ == "__main__":
    main()
