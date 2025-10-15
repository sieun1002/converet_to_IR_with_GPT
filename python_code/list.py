import os
import json
from openai import OpenAI

# OpenAI 클라이언트 초기화
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY", ""))

def run_gpt_on_txt_files(folder_path, system_prompt, output_json="../function_list/gpt/linux_O3.json"):
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
    folder = "..//function_list/ida/linux/O3"
    system_prompt = """"Role
Receive an IDA function list and select only the minimal set of internal functions required to emit IR. The output must be a JSON array of function names only—no extra text.

Rules
- The input is always an obfuscated binary, and function names are typically meaningless (e.g., sub_401000, loc_1234AB).
- Include only internal (.text) functions reachable from the target (entrypoints).
- Exclude functions that only wrap external API calls without additional logic.
- Exclude CRT/startup/teardown routines, PLT/import stubs, and trivial logging wrappers.
- Do not include external library calls (they will be IR declares).
- Include internally defined callbacks passed as function pointers if reachable.
= Do not invent names not present in the input.

Output format
["fnA","fnB","fnC"]"""  # 원하는 시스템 프롬프트
    run_gpt_on_txt_files(folder, system_prompt)
