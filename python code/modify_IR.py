import os
from openai import OpenAI
import traceback

client = OpenAI(api_key="")  

# SYSTEM_PROMPT는 별도로 채워 넣으세요(이전 대화에서 만든 시스템 프롬프트)
SYSTEM_PROMPT = """
Role:
When given a broken LLVM 14 IR module together with the error messages that occurred while attempting to recompile it into a Linux x86-64 binary, output only “one” corrected LLVM 14 IR module.

Target:
- LLVM 14 IR
- Linux x86-64 binary

Input:
- The entire broken IR (.ll)
- The original error output (stderr) from recompilation

Output:
- Output exactly one fixed LLVM 14 IR module
- No additional text such as explanations/markdown/code fences

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
"""

def _read_text(path: str) -> str:
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except UnicodeDecodeError:
        # 깨진 인코딩 방지용 폴백
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()

def run_gpt_on_files(
    ir_folder: str,
    error_folder: str = None,
    output_folder: str = "/home/nata20034/workspace/llm_to_IR/chatGPT_api2/llm3_i_plus_error/after",
):
    """
    ir_folder 안의 *.ll 파일을 입력 IR로 사용하고,
    error_folder(기본: ir_folder) 안의 같은 베이스이름의 *.txt 파일을 오류 로그로 사용합니다.
    예) foo.ll + foo.txt
    """
    os.makedirs(output_folder, exist_ok=True)
    if error_folder is None:
        error_folder = ir_folder

    for filename in sorted(os.listdir(ir_folder)):
        if not filename.endswith(".ll"):
            continue

        base_name = os.path.splitext(filename)[0]
        ll_path = os.path.join(ir_folder, filename)
        err_path = os.path.join(error_folder, base_name + ".txt")

        bad_ir = _read_text(ll_path)
        stderr_text = _read_text(err_path) if os.path.exists(err_path) else ""

        
        user_payload = f"""=== BAD_IR ===
{bad_ir}
=== STDERR ===
{stderr_text}
"""

        print(f"Processing {filename} ...")
        try:
            response = client.responses.create(
                model="gpt-5",  # gpt-5 사용
                input=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": user_payload},
                ],
            )

            output_text = response.output_text  

            out_ll = os.path.join(output_folder, f"{base_name}.ll")
            with open(out_ll, "w", encoding="utf-8") as out_f:
                out_f.write(output_text)

            print(f"✅ {out_ll} 저장 완료")
        except Exception as e:
            print(f"❌ 처리 실패: {e}")
            traceback.print_exc()
            continue

    print(f"\n모든 결과가 {output_folder} 폴더에 개별 .ll 파일로 저장되었습니다.")

if __name__ == "__main__":
    # 사용 예시
    IR_FOLDER = "/home/nata20034/workspace/llm_to_IR/chatGPT_api2/llm3_i_plus_error/before/ir"       
    ERROR_FOLDER = "/home/nata20034/workspace/llm_to_IR/chatGPT_api2/llm3_i_plus_error/before/error"    
    run_gpt_on_files(IR_FOLDER, ERROR_FOLDER)
