import os
import json
import time
from datetime import datetime
from typing import Tuple, Dict, Any, List

from openai import OpenAI

# ========= 설정 =========
MODEL = "gpt-5"
INPUT_EXT = ".txt"   
OUTPUT_EXT = ".ll"  
NUM_ROUNDS = 3         # 반복 횟수(요청: 5회)
# =======================

client = OpenAI(api_key=API_KEY)

SYSTEM_PROMPT = """
Your role:
You are a “Binary Function Disassembly → LLVM 14 IR (C-ABI)” lifter. You take the IDA-style disassembly of exactly one function as input and output exactly one LLVM 14 IR module for that function—nothing else. (No explanations/markdown/code fences; IR comments are allowed.)

Target / syntax:
- LLVM version: 14
- target triple: x86_64-unknown-linux-gnu
- Opaque pointers are forbidden: never use the `ptr` token; always use typed pointers (i8*, i32*, …).
- Omit datalayout (if you include it, the exact same string must be used in all outputs).
- The output must assemble with llvm-as (14) without errors.

Invocation context:
- Each call provides the disassembly text of exactly one function.
- Assume no whole-program context (no global/ABI knowledge beyond what’s in the disassembly).
- You output only the IR module for that one function.

Function signature reconstruction (C-ABI mode):
- Define exactly one function per input.
- Function name: prefer the IDA symbol (e.g., main, sub_401000, _Z7fooPi).
  - If not a valid LLVM identifier: replace invalid chars with `_`; if it starts with a digit, prefix `f_`; collapse repeated `_` to one.
  - On collision, append `__<ADDR_HEX>`. If no name, use `fn_<ADDR_HEX>`.
  - Always record original symbol/address in a header comment:
    ; Symbol: main  ; Address: 0x401000
- If the function is `main`: use `define dso_local i32 @main(i32 %argc, i8** %argv)`.
- Otherwise, reconstruct a **C-ABI style** signature from usage patterns in the disassembly:
  - Buffer+length patterns → choose reasonable types (e.g., `i8*`/`i32*` with `i64` length).
  - For clear semantics (e.g., sorting/copy), use conventional signatures (e.g., `void @heap_sort(i32* %a, i64 %n)`).
  - If uncertain, choose conservative `i8*` for raw buffers and integer parameters, and state assumptions in `; Preconditions`.
- External calls must be declared with their **real ABI** (e.g., `declare i32 @printf(i8*, ...)`, `declare i32 @putchar(i32)`).
  - Do not emit unused extern declarations.

Intent-first policy & conservative repair:
- Infer the function’s intent from name/patterns/constants/loops/recursion/memory/branches.
- Record it in the header:
  ; Intent: <guess> (confidence=<0.00–1.00>). Evidence: <1–2 key cues>
- If confidence ≥ 0.8: allow **conservative repair** to match the standard semantics (fix minor bounds/offset bugs) while preserving the observable interface and memory layout.
- If confidence < 0.8: do a **conservative lift** (faithful to observed semantics; do not “repair”).

Memory / types / operations:
- x86-64 little-endian. Integer literals in decimal.
- Use `getelementptr` and `bitcast` only as needed; avoid unnecessary `alloca` (write SSA-friendly IR).
- 8/16/32-bit loads that feed wider ops must use `zext`/`sext` as appropriate.
- Respect the x86 rule that 32-bit GPR writes zero-extend to 64-bit when modeling semantics.
- Use `icmp` + `br i1` + `phi` for control flow; every basic block must end with a terminator.

Exceptions / fallback:
- Do not invent floating-point, vector types, metadata, or debug info if not present in the disassembly.
- If a behavior cannot be reconstructed and is semantically critical, declare `declare void @llvm.trap()` and emit `call @llvm.trap()` followed by `unreachable`, and note the gap in a comment.

Output scaffold (follow this template; fill in the content):
; ModuleID = '<FUNC_NAME>'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: <IDA_NAME or 'unknown'>  ; Address: 0x<ADDR_HEX>
; Intent: <guess> (confidence=<0.00–1.00>). Evidence: <cue1–2>
; Preconditions: <if any>
; Postconditions: <if any>

; Only the needed extern declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare other externs only if they are actually called)

define dso_local <RET_TY> @<FUNC_NAME>(<C_ABI_PARAMS...>) local_unnamed_addr {
entry:
  ; body (SSA-friendly; no unnecessary alloca)
  ret <RET_TY> <RET_VAL or void>
}

Final self-check (before emitting):
- Output is exactly one IR module; no markdown/explanations/code fences (comments are OK).
- The `ptr` token does not appear anywhere (typed pointers only).
- Only externs that are actually referenced are declared.
- Every basic block ends with a terminator.
- The IR assembles cleanly with llvm-as (14).
"""  


def now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")


def extract_output_text(response) -> str:
    """
    openai>=1.0 Responses API의 편의 프로퍼티 사용.
    혹시 라이브러리/포맷 차이가 있어도 최대한 텍스트를 추출.
    """
    # 가장 먼저 권장 속성 사용
    try:
        return response.output_text
    except Exception:
        pass

    # fallback 경로들
    try:
        parts = []
        for item in getattr(response, "output", []) or []:
            for c in getattr(item, "content", []) or []:
                txt = getattr(c, "text", None)
                if txt:
                    parts.append(txt)
        return "\n".join(parts).strip()
    except Exception:
        return ""


def call_gpt_with_retry(user_content: str, system_prompt: str, max_retries: int = 4) -> Tuple[bool, str, Dict[str, Any]]:
    """
    GPT 호출 + 타이밍 측정 + 재시도.
    반환: (success, output_text, metrics_dict)
    """
    attempt = 0
    while attempt <= max_retries:
        start_ts = time.perf_counter()
        start_iso = now_iso()
        try:
            resp = client.responses.create(
                model=MODEL,
                input=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_content},
                ],
            )

            output_text = extract_output_text(resp)
            end_ts = time.perf_counter()
            end_iso = now_iso()

            usage = getattr(resp, "usage", None)
            metrics = {
                "request_id": getattr(resp, "id", None),
                "model": MODEL,
                "start_time": start_iso,
                "end_time": end_iso,
                "elapsed_sec": round(end_ts - start_ts, 6),
                "usage": {
                    "input_tokens": getattr(usage, "input_tokens", None) if usage else None,
                    "output_tokens": getattr(usage, "output_tokens", None) if usage else None,
                    "total_tokens": getattr(usage, "total_tokens", None) if usage else None,
                },
                "attempt": attempt + 1,
                "retries": attempt,
                "error": None,
            }
            return True, output_text, metrics

        except Exception as e:
            end_ts = time.perf_counter()
            end_iso = now_iso()
            err_msg = str(e)
            metrics = {
                "request_id": None,
                "model": MODEL,
                "start_time": start_iso,
                "end_time": end_iso,
                "elapsed_sec": round(end_ts - start_ts, 6),
                "usage": None,
                "attempt": attempt + 1,
                "retries": attempt,
                "error": err_msg,
            }

            if attempt < max_retries:
                sleep_s = min(30.0, (2.0 * (1.5 ** attempt)))  # 지수 백오프
                print(f"⚠️ GPT 호출 실패(시도 {attempt+1}/{max_retries+1}): {err_msg}\n   {sleep_s:.1f}s 후 재시도")
                time.sleep(sleep_s)
                attempt += 1
            else:
                return False, "", metrics


def run_one_round(folder_path: str, round_out_dir: str, error_suffix: str = "") -> List[Dict[str, Any]]:
    """
    한 라운드 수행: folder_path 내의 .txt 파일들을 처리하여 .ll을 round_out_dir에 저장.
    각 파일 호출의 타이밍/결과를 리스트로 반환.
    """
    os.makedirs(round_out_dir, exist_ok=True)
    logs: List[Dict[str, Any]] = []

    files = [fn for fn in os.listdir(folder_path) if fn.endswith(INPUT_EXT)]
    files.sort()  # 처리 순서 고정

    for filename in files:
        file_path = os.path.join(folder_path, filename)
        with open(file_path, "r", encoding="utf-8") as f:
            file_content = f.read()

        print(f"Processing {filename} ...")

        user_content = file_content + (("\n" + error_suffix) if error_suffix.strip() else "")

        success, output_text, metrics = call_gpt_with_retry(user_content, SYSTEM_PROMPT)

        base_name = os.path.splitext(filename)[0]
        out_name = f"{base_name}{OUTPUT_EXT}"
        out_path = os.path.join(round_out_dir, out_name)

        log_entry = {
            "filename": filename,                 # 입력 파일명(.txt)
            "output_filename": out_name,          # 출력 파일명(.ll)
            "output_path": out_path if success else None,
            "success": success,
            **metrics,
        }

        if success:
            try:
                with open(out_path, "w", encoding="utf-8") as out_f:
                    out_f.write(output_text)
                print(f"✅ {out_path} 저장 완료")
            except Exception as e:
                log_entry["success"] = False
                log_entry["error"] = f"파일 저장 실패: {e}"
                print(f"❌ 파일 저장 실패: {e}")
        else:
            print(f"❌ 처리 실패: {metrics.get('error')}")

        logs.append(log_entry)

    # 라운드별 로그 저장
    log_json_path = os.path.join(round_out_dir, "log.json")
    with open(log_json_path, "w", encoding="utf-8") as jf:
        json.dump(logs, jf, ensure_ascii=False, indent=2)

    print(f"📄 라운드 로그 저장: {log_json_path}")
    return logs


def run_multi_rounds(folder_path: str, output_root: str, num_rounds: int = NUM_ROUNDS, error_suffix: str = ""):
    """
    num_rounds 회 반복 실행.
    각 라운드 결과는 output_root/<라운드번호>/ 에 저장되고,
    각 라운드 폴더마다 log.json이 생성됨.
    """
    os.makedirs(output_root, exist_ok=True)
    print(f"입력 폴더: {folder_path}")
    print(f"출력 루트 폴더: {output_root}")
    print(f"{num_rounds}회 반복 실행 시작\n")

    for r in range(3, num_rounds + 1):
        round_dir = os.path.join(output_root, str(r))
        print(f"\n====== Round {r} 시작 ({round_dir}) ======")
        run_one_round(folder_path, round_dir, error_suffix=error_suffix)

    print("\n✅ 모든 라운드 완료")


if __name__ == "__main__":
    # 경로는 직접 수정해서 사용
    folder = "../../ida_disassemble/O0"
    output_root = "../../llm_to_IR/chatGPT_api2/O0/repeat_5"
    error = ""  # 필요 시 이전 라운드 오류 메시지를 덧붙이고 싶으면 채워 넣기

    run_multi_rounds(folder_path=folder, output_root=output_root, num_rounds=5, error_suffix=error)
