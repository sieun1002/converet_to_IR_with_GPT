import os
from openai import OpenAI
import traceback

client = OpenAI(api_key="")

# SYSTEM_PROMPT를 변수로 정의
SYSTEM_PROMPT = """I want to convert Linux binary code to IR.
Using IDA, I will give you the disassembly.
Output a .ll in LLVM 14 version.
"""

def run_gpt_on_txt_files(folder_path, output_folder="/home/nata20034/workspace/llm_to_IR/chatGPT_api_query_promt/query_i/iiii"):
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
            print(f"❌ 처리 실패: {e}")
            # traceback.print_exc()  
            continue

    print(f"\n모든 결과가 {output_folder} 폴더에 개별 .ll 파일로 저장되었습니다.")

if __name__ == "__main__":
    folder = "/home/nata20034/workspace/ida_disassemble/query_i/iii"
    error= """"""
    run_gpt_on_txt_files(folder)
