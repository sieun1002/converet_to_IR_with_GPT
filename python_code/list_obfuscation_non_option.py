import os
import json
from pathlib import Path
from openai import OpenAI


# =========================
# USER CONFIG (여기만 수정)
# =========================
CFG = {
    # 여기 폴더의 *.txt 는 "JSON 텍스트"가 들어있는 파일들
    "INPUT_DIR": "/root/workspace/converet_to_IR_with_GPT/function_list/ida/window/O0/Obfuscation/bubblesort",

    # system prompt 파일 경로
    "SYSTEM_PROMPT_FILE": "/root/workspace/converet_to_IR_with_GPT/python_code/systemprompt/function_list_obfuscation_non_option.txt",

    # 출력 JSON
    "OUTPUT_JSON": "../function_list/gpt/window_O0_obfuscation_bubblesort_no_option.json",

    # 모델
    "MODEL": "gpt-5",

    # 옵션 없는 템플릿 (FUNCTION_LIST_JSON만)
    "TEMPLATE": """FUNCTION_LIST_JSON:
{function_list_json}
""",

    # 디버깅용: 템플릿 적용된 user input 저장 여부
    "SAVE_TEMPLATED_USER_INPUT": True,

    # txt가 진짜 JSON인지 최소 검증할지
    "VALIDATE_JSON": True,

    # 에러 나도 다음 파일 계속 진행할지
    "CONTINUE_ON_ERROR": True,
}
# =========================


client = OpenAI(api_key=os.getenv("OPENAI_API_KEY", ""))


def load_text_file(path: str) -> str:
    p = Path(path)
    if not p.is_file():
        raise FileNotFoundError(f"File not found: {p}")
    return p.read_text(encoding="utf-8")


def build_user_content(function_list_json_text: str) -> str:
    return CFG["TEMPLATE"].format(function_list_json=function_list_json_text)


def run():
    input_dir = Path(CFG["INPUT_DIR"])
    if not input_dir.is_dir():
        raise NotADirectoryError(f"Input dir not found: {input_dir}")

    system_prompt_text = load_text_file(CFG["SYSTEM_PROMPT_FILE"])

    out_path = Path(CFG["OUTPUT_JSON"])
    out_path.parent.mkdir(parents=True, exist_ok=True)

    results = {
        "_meta": {
            "input_dir": str(input_dir),
            "system_prompt_file": CFG["SYSTEM_PROMPT_FILE"],
            "model": CFG["MODEL"],
            "mode": "no_option",
        },
        "files": {}
    }

    for txt_path in sorted(input_dir.glob("*.txt")):
        print(f"Processing {txt_path.name} ...")

        try:
            # txt 자체가 JSON 텍스트
            function_list_json_text = txt_path.read_text(encoding="utf-8", errors="replace").strip()

            if CFG["VALIDATE_JSON"]:
                # JSON 파싱이 되는지 최소 검증(내용은 그대로 텍스트로 LLM에 전달)
                json.loads(function_list_json_text)

            user_content = build_user_content(function_list_json_text)

            resp = client.chat.completions.create(
                model=CFG["MODEL"],
                messages=[
                    {"role": "system", "content": system_prompt_text},
                    {"role": "user", "content": user_content},
                ],
            )

            output_text = resp.choices[0].message.content

            item = {
                "path_file_txt": str(txt_path),
                "output": output_text,
            }
            if CFG["SAVE_TEMPLATED_USER_INPUT"]:
                item["templated_user_input"] = user_content

            results["files"][txt_path.name] = item

        except Exception as e:
            # 파일 단위 에러 기록
            results["files"][txt_path.name] = {
                "path_file_txt": str(txt_path),
                "error": repr(e),
            }
            print(f"  -> ERROR: {e}")

            if not CFG["CONTINUE_ON_ERROR"]:
                raise

    out_path.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\n✅ Saved: {out_path}")


if __name__ == "__main__":
    run()
