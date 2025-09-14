#!/usr/bin/env python3
import os
import subprocess
from pathlib import Path

def ll_to_bc(input_dir: str, output_dir: str, tool: str = "llvm-as-14"):
    input_dir = Path(input_dir).resolve()
    output_dir = Path(output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    for root, _, files in os.walk(input_dir):
        for f in files:
            if not f.endswith(".ll"):
                continue
            ll_path = Path(root) / f
            rel_path = ll_path.relative_to(input_dir)
            out_path = output_dir / rel_path.with_suffix(".bc")
            out_path.parent.mkdir(parents=True, exist_ok=True)

            cmd = [tool, str(ll_path), "-o", str(out_path)]
            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode == 0:
                print(f"[OK] {ll_path} -> {out_path}")
            else:
                print(f"[FAIL] {ll_path}")
                print(result.stderr)

if __name__ == "__main__":
    # 입력 폴더와 출력 폴더를 직접 적어주세요
    INPUT_DIR = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_query/dijkstra/5"   # 변환할 .ll 파일들이 있는 폴더
    OUTPUT_DIR = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_query/dijkstra/5/bc"  # 변환된 .bc 파일 저장 폴더

    ll_to_bc(INPUT_DIR, OUTPUT_DIR)
