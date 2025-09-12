#!/usr/bin/env python3
from pathlib import Path
import subprocess

# ===== 여기를 프로젝트에 맞게 수정하세요 =====
SRC_DIR = Path("../original/src")   # C 소스들이 있는 폴더
OUT_DIR = Path("../original/ll")      # .ll 파일을 저장할 폴더
CLANG   = "clang-14"                        # 필요시 "clang"으로 변경
OPTLVL  = "0"                               # "0"~"3"
TARGET  = None                              # 예: "x86_64-unknown-linux-gnu" (없으면 None)
# =========================================

FLAGS = ["-S", "-emit-llvm", f"-O{OPTLVL}", "-g", "-fno-discard-value-names"]

for c in SRC_DIR.rglob("*.c"):
    out = (OUT_DIR / c.relative_to(SRC_DIR)).with_suffix(".ll")
    out.parent.mkdir(parents=True, exist_ok=True)
    cmd = [CLANG, *FLAGS]
    if TARGET:
        cmd.append(f"--target={TARGET}")
    cmd += [str(c), "-o", str(out)]
    subprocess.run(cmd)