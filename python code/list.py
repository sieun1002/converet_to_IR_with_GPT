import os
import json
import openai

openai.api_key = ""

def run_gpt_on_txt_files(folder_path, system_prompt, output_json="..//function_list/gpt/enc/enc_function.json"):
    results = {}

    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(folder_path, filename)
            
            with open(file_path, "r", encoding="utf-8") as f:
                file_content = f.read()
            
            print(f"Processing {filename} ...")

            response = openai.ChatCompletion.create(
                model="gpt-5",   
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": file_content}
                ]
            )
            
            output_text = response["choices"][0]["message"]["content"]
            results[filename] = {
                "input": file_content,
                "output": output_text
            }

    # 결과 JSON 저장
    with open(output_json, "w", encoding="utf-8") as out_f:
        json.dump(results, out_f, ensure_ascii=False, indent=2)

    print(f"\n✅ 모든 결과가 {output_json} 파일에 저장되었습니다.")

if __name__ == "__main__":
    folder = "../function_list/ida/enc"  # txt 파일이 저장된 폴더 경로
    system_prompt = '''Role
Receive an IDA function list and select only the minimal set of internal functions required to emit IR. Output must be a JSON array of function names only—no extra text.

Obfuscation context
The program was source-level obfuscated (e.g., arithmetic encoding, opaque predicates, control-flow flattening, dispatcher/helpers, decoy/dummy functions). Apply the rules below with these additions:
A) Include obfuscator-inserted helpers (e.g., init/opaque/encode/decode/dispatcher functions) only if they are actually reachable from entrypoints or already-included functions. Do not include dead decoys with zero inbound references.
B) Exclude wrappers/thunks that merely forward to excluded externals or perform logging only. If a helper transforms data that is subsequently used by reachable code (e.g., constant/string decryptors, arithmetic encoders), include it.
C) If the obfuscator split logic into many tiny helpers, include only those that have direct call edges from included functions.
D) If multiple internal names alias the same implementation and only one is referenced, include only the referenced one. Do not invent or rename functions.
E) Callbacks passed by function pointer that are internally defined and reachable must be included.

Rules

Include only internal (.text) functions reachable from the target (or entrypoints).

Exclude CRT/startup/teardown and PLT/import stubs/thunks and logging-only wrappers.
Patterns to skip: _start, _libc_start_main, gmon_start, cxa, __chkstk, _scrt, .plt, _imp, j*

Do not include external library calls (they will be IR declares).

Include callbacks passed as function pointers if internally defined and reachable.

Do not invent names not present in the input.

Output format
["fnA","fnB","fnC"]'''  # 원하는 시스템 프롬프트
    run_gpt_on_txt_files(folder, system_prompt)
