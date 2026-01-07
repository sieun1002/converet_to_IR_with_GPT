import os
import json
from pathlib import Path
from openai import OpenAI


CFG = {
    "INPUT_DIR": "/root/workspace/converet_to_IR_with_GPT/function_list/ida/window/O0/Obfuscation/bubblesort",
    "SYSTEM_PROMPT_FILE": "/root/workspace/converet_to_IR_with_GPT/python_code/systemprompt/function_list_obfuscation_option.txt",
    "OUTPUT_JSON": "../function_list/gpt/window_O0_obfuscation_bubblesort.json",
    "MODEL": "gpt-5",

    # 파일명에서 MP/IP/RP 추출
    "ALLOWED_PROTECTIONS": {"MP", "IP", "RP"},
    "FALLBACK_PROTECTIONS": [],  # 파일명 파싱 실패 시 대체값(원하면 ["MP","IP","RP"] 등으로)

    "TEMPLATE": """PROTECTIONS:
{protections}

FUNCTION_LIST_JSON:
{function_list_json}
""",

    "SAVE_TEMPLATED_USER_INPUT": True,
    "VALIDATE_JSON": True,
    "CONTINUE_ON_ERROR": True,
}


client = OpenAI(api_key=os.getenv("OPENAI_API_KEY", ""))

def load_text_file(path: str) -> str:
    p = Path(path)
    if not p.is_file():
        raise FileNotFoundError(f"File not found: {p}")
    return p.read_text(encoding="utf-8")


def parse_protections_from_filename(file_path: Path) -> list[str]:
    """
    예)
    - bubblesort.IP_functions.txt        -> ["IP"]
    - bubblesort.IP_RP_functions.txt     -> ["IP","RP"]
    - bubblesort.MP_IP_RP_functions.txt  -> ["MP","IP","RP"]
    """
    stem = file_path.stem  # .txt 제거된 이름
    # "bubblesort.IP_RP_functions" -> "IP_RP_functions"
    if "." in stem:
        suffix = stem.split(".", 1)[1]
    else:
        suffix = stem

    # 끝의 "_functions" 제거
    if suffix.endswith("_functions"):
        suffix = suffix[: -len("_functions")]
    elif suffix.endswith("functions"):
        suffix = suffix[: -len("functions")]

    tokens = [t for t in suffix.split("_") if t]
    prots = [t for t in tokens if t in CFG["ALLOWED_PROTECTIONS"]]

    if not prots:
        if CFG["FALLBACK_PROTECTIONS"]:
            return CFG["FALLBACK_PROTECTIONS"]
        raise ValueError(f"Cannot parse protections from filename: {file_path.name}")

    return prots


def build_user_content(function_list_json_text: str, protections: list[str]) -> str:
    return CFG["TEMPLATE"].format(
        protections=json.dumps(protections, ensure_ascii=False),
        function_list_json=function_list_json_text,
    )


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
        },
        "files": {}
    }

    # 확장자가 .txt가 아닐 수도 있다고 해서 유연하게 잡고 싶으면 glob("*functions*")로 바꿔도 됨
    for txt_path in sorted(input_dir.glob("*.txt")):
        print(f"Processing {txt_path.name} ...")

        try:
            protections = parse_protections_from_filename(txt_path)

            function_list_json_text = txt_path.read_text(encoding="utf-8", errors="replace").strip()
            if CFG["VALIDATE_JSON"]:
                json.loads(function_list_json_text)

            user_content = build_user_content(function_list_json_text, protections)

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
                "protections": protections,  # 파일명에서 추출한 값 저장
                "output": output_text,
            }
            if CFG["SAVE_TEMPLATED_USER_INPUT"]:
                item["templated_user_input"] = user_content

            results["files"][txt_path.name] = item

        except Exception as e:
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
