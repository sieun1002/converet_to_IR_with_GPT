#!/usr/bin/env python3
"""
폴더 내 .ll(.bc 선택) 파일을 순회하며 clang-14로 각각 실행 파일 빌드.
[수정할 부분] 섹션의 변수만 바꾸면 됩니다.
"""

from pathlib import Path
import subprocess
import shutil
import sys

# =====================[ 수정할 부분 ]=====================
SRC_DIR     = Path("/path/to/your/ll_files")  # 입력 폴더
OUT_DIR     = Path("/path/to/output/bin")     # 출력 폴더 (None 이면 입력 폴더 사용)
INCLUDE_BC  = False                            # .bc 파일도 빌드하려면 True
RECURSIVE   = False                            # 하위 폴더까지 모두 빌드하려면 True
CLANG       = "clang-14"                       # clang 바이너리 경로/이름
EXTRA_FLAGS = []                               # 예: ["-march=native"]
DRY_RUN     = False                            # 명령만 출력하고 실행 안 하려면 True
# ========================================================

def compile_one(src: Path, out_dir: Path) -> tuple[bool, str]:
    out_path = out_dir / src.stem
    cmd = [CLANG, "-O2", str(src), "-o", str(out_path), *EXTRA_FLAGS]

    if DRY_RUN:
        print("$ " + " ".join(cmd))
        return True, f"DRY-RUN {src.name} → {out_path}"

    proc = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode == 0:
        return True, f"✅ 성공: {src.name} → {out_path}"
    else:
        msg = proc.stderr.strip() or proc.stdout.strip()
        return False, f"❌ 실패: {src.name}\n{msg}"

def main():
    if not SRC_DIR.exists() or not SRC_DIR.is_dir():
        print(f"[에러] 입력 폴더가 없습니다: {SRC_DIR}")
        sys.exit(1)

    if shutil.which(CLANG) is None:
        print(f"[에러] '{CLANG}' 을(를) 찾을 수 없습니다. PATH를 확인하세요.")
        sys.exit(1)

    if OUT_DIR is not None:
        OUT_DIR.mkdir(parents=True, exist_ok=True)

    patterns = ["*.ll"] + (["*.bc"] if INCLUDE_BC else [])
    it = (SRC_DIR.rglob if RECURSIVE else SRC_DIR.glob)

    files = []
    for pat in patterns:
        files.extend(sorted(it(pat)))
    files = [p for p in files if p.is_file()]

    if not files:
        print("[정보] 빌드할 파일이 없습니다.")
        return

    ok = fail = 0
    for src in files:
        out_dir = OUT_DIR if OUT_DIR is not None else src.parent
        out_dir.mkdir(parents=True, exist_ok=True)
        success, msg = compile_one(src, out_dir)
        print(msg)
        ok += int(success)
        fail += int(not success)

    print("\n=== 결과 ===")
    print(f"성공: {ok}개, 실패: {fail}개, 전체: {ok+fail}개")

if __name__ == "__main__":
    main()
