import os
from openai import OpenAI
import traceback

client = OpenAI(api_key="")

# SYSTEM_PROMPT를 변수로 정의
SYSTEM_PROMPT = """Your role:
You are a “Binary Function Disassembly → LLVM 14 IR (C-ABI)” lifter. When given the IDA-style disassembly of a single function as input, output only one LLVM 14 IR module conforming to the C calling convention. (No explanations/markdown/code fences; comments inside the IR are allowed.)

Target/Syntax:

LLVM 14

target triple: x86_64-unknown-linux-gnu

Opaque pointers are forbidden (never use the ptr token). You must use typed pointers only.

Omit the datalayout (if included, the exact same string must be kept across all outputs).

The output must be directly assemblable by llvm-as (14).

Output scaffold (follow this template exactly, but fill in the content):
; ModuleID = '<FUNC_NAME>'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: <IDA_NAME or 'unknown'> ; Address: 0x<ADDR_HEX>
; Intent: <guess> (confidence=<0.00–1.00>). Evidence: <clue1–2>
; Preconditions: <if any>
; Postconditions: <if any>

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local <RET_TY> @<FUNC_NAME>(<C_ABI_PARAMS...>) local_unnamed_addr {
entry:
; body (written in an SSA-friendly way)
ret <RET_TY> <RET_VAL or void>
}

"""

def run_gpt_on_txt_files(folder_path, output_folder="/home/nata20034/workspace/llm_to_IR/chatGPT_api_short_prompt/short_i/iiii"):
    os.makedirs(output_folder, exist_ok=True)

    for filename in os.listdir(folder_path):
        if not filename.endswith(".txt"):
            continue

        file_path = os.path.join(folder_path, filename)
        with open(file_path, "r", encoding="utf-8") as f:
            file_content = f.read()

        print(f"Processing {filename} ...")

        try:
            response = client.responses.create(
                model="gpt-5",   # gpt-5 사용
                input=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": file_content},
                    # {"role": "user", "content": file_content + error + "Convert it to IR in a way that the error does not occur."}

                ]
            )

            output_text = response.output_text

            # .ll 파일 저장
            base_name = os.path.splitext(filename)[0]
            ll_file = os.path.join(output_folder, f"{base_name}.ll")
            with open(ll_file, "w", encoding="utf-8") as out_f:
                out_f.write(output_text)

            print(f"✅ {ll_file} 저장 완료")

        except Exception as e:
            print(f"❌  처리 실패: {e}")
            # traceback.print_exc()  
            continue

    print(f"\n모든 결과가 {output_folder} 폴더에 개별 .ll 파일로 저장되었습니다.")

if __name__ == "__main__":
    folder = "/home/nata20034/workspace/ida_disassemble/short_i/iii"
    error= """"""
    run_gpt_on_txt_files(folder)
