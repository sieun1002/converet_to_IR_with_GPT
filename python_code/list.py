import os
import json
from openai import OpenAI

# OpenAI 클라이언트 초기화
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY", ""))

def run_gpt_on_txt_files(folder_path, system_prompt, output_json="../function_list/gpt/window_O0_obfuscation_bubblesort.json"):
    results = {}

    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(folder_path, filename)

            with open(file_path, "r", encoding="utf-8") as f:
                file_content = f.read()

            print(f"Processing {filename} ...")

            # 최신 API 방식
            response = client.chat.completions.create(
                model="gpt-5",
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": file_content}
                ]
            )

            output_text = response.choices[0].message.content
            results[filename] = {
                "input": file_content,
                "output": output_text
            }

    # 결과 JSON 저장
    with open(output_json, "w", encoding="utf-8") as out_f:
        json.dump(results, out_f, ensure_ascii=False, indent=2)

    print(f"\n✅ 모든 결과가 {output_json} 파일에 저장되었습니다.")

if __name__ == "__main__":
    folder = "/root/workspace/converet_to_IR_with_GPT/function_list/ida/window/O0/Obfuscation/bubblesort"
    system_prompt = "root/workspace/converet_to_IR_with_GPT/python_code/systemprompt/function_list_obfuscation_non_option.txt" 
    run_gpt_on_txt_files(folder, system_prompt)
