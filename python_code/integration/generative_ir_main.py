# main_gpt_runner.py
import os
import json
from typing import Dict, Any, List
from openai import OpenAI
from generative_ir import GPTRunner, _now_iso

# ===== 사용자가 수정할 설정 =====
PRINT = ("")
SYSTEM_PROMPT_FILE = "../systemprompt/window_error_analysis.txt"      # 또는 파일 경로 (있으면 우선)
NUM_ROUNDS  = 5      # 반복 횟수
START_INDEX = 6       # 시작 폴더 번호 (예: 6 -> 6,7,8,9,10)
INPUT_FOLDER = "../../ida_disassemble/window/O0/heapsort"
OUTPUT_ROOT  = "../../llm_to_IR/window_gpt_api_error_analysis_modify_prompt2/heapsort"

API_KEY = os.getenv("OPENAI_API_KEY", "")
MODEL = "gpt-5"

INPUT_EXT  = ".txt"
OUTPUT_EXT = ".ll"
ERROR_SUFFIX = ""            # 이전 라운드 오류 등을 덧붙일 때
MAX_RETRIES = 4
VERBOSE = True               # 콘솔 로그 켤지
# ==============================

def _load_system_prompt() -> str:
    if SYSTEM_PROMPT_FILE:
        with open(SYSTEM_PROMPT_FILE, "r", encoding="utf-8") as f:
            return f.read()
    return SYSTEM_PROMPT

def _init_round_log(log_path: str, meta: Dict[str, Any]) -> None:
    """라운드 시작 시 단일 JSON 파일을 생성."""
    base = {
        "meta": meta,
        "entries": []
    }
    os.makedirs(os.path.dirname(log_path), exist_ok=True)
    with open(log_path, "w", encoding="utf-8") as f:
        json.dump(base, f, ensure_ascii=False, indent=2)

def _append_log_entry(log_path: str, entry: Dict[str, Any]) -> None:
    """entries 배열에 항목을 추가."""
    try:
        with open(log_path, "r+", encoding="utf-8") as f:
            data = json.load(f)
            if not isinstance(data, dict):
                data = {"entries": []}
            if "entries" not in data or not isinstance(data["entries"], list):
                data["entries"] = []
            data["entries"].append(entry)
            f.seek(0)
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.truncate()
    except FileNotFoundError:
        with open(log_path, "w", encoding="utf-8") as f:
            json.dump({"entries": [entry]}, f, ensure_ascii=False, indent=2)

def _run_round(
    runner: GPTRunner,
    folder_path: str,
    round_out_dir: str,
    log_path: str,
    input_ext: str,
    output_ext: str,
    error_suffix: str,
) -> None:
    files = sorted(fn for fn in os.listdir(folder_path) if fn.endswith(input_ext))

    for filename in files:
        in_path = os.path.join(folder_path, filename)
        with open(in_path, "r", encoding="utf-8") as f:
            content = f.read()

        user_content = content + (("\n" + error_suffix) if error_suffix.strip() else "")
        print(f"Processing {filename} ...")

        # GPT 호출: GPTRunner가 log.json에 시간/토큰/시작/종료를 즉시 append
        success, output_text, metrics = runner.run_once(
            user_content,
            log_path=log_path,
            log_extra={"filename": filename},
        )

        # 결과 파일 저장 및 I/O 결과도 같은 log.json에 append
        base = os.path.splitext(filename)[0]
        out_name = f"{base}{output_ext}"
        out_path = os.path.join(round_out_dir, out_name)

        io_entry: Dict[str, Any] = {
            "phase": "file_output",
            "filename": filename,
            "output_filename": out_name,
            "output_path": out_path if success else None,
            "success": success,
        }

        if success:
            try:
                with open(out_path, "w", encoding="utf-8") as wf:
                    wf.write(output_text)
                print(f"💾 saved: {out_path} (elapsed {metrics.get('elapsed_sec')}s)")
            except Exception as e:
                io_entry["success"] = False
                io_entry["error"] = f"파일 저장 실패: {e}"
                print(f"❌ 파일 저장 실패: {e}")
        else:
            io_entry["error"] = metrics.get("error")

        _append_log_entry(log_path, io_entry)

def main():
    client = OpenAI(api_key=API_KEY)
    runner = GPTRunner(
        client=client,
        model=MODEL,
        system_prompt=_load_system_prompt(),
        max_retries=MAX_RETRIES,
        verbose=VERBOSE,
    )

    os.makedirs(OUTPUT_ROOT, exist_ok=True)
    for r in range(START_INDEX, START_INDEX + NUM_ROUNDS):
        round_dir = os.path.join(OUTPUT_ROOT, str(r))
        os.makedirs(round_dir, exist_ok=True)

        log_path = os.path.join(round_dir, "log.json")
        _init_round_log(
            log_path,
            meta={
                "round": r,
                "model": MODEL,
                "input_folder": os.path.abspath(INPUT_FOLDER),
                "output_dir": os.path.abspath(round_dir),
                "start_time": _now_iso(),
                "input_ext": INPUT_EXT,
                "output_ext": OUTPUT_EXT,
            },
        )

        print(f"\n====== Round {r} ({round_dir}) ======")
        _run_round(
            runner=runner,
            folder_path=INPUT_FOLDER,
            round_out_dir=round_dir,
            log_path=log_path,
            input_ext=INPUT_EXT,
            output_ext=OUTPUT_EXT,
            error_suffix=ERROR_SUFFIX,
        )

        # 라운드 종료 메타 업데이트(append 방식)
        _append_log_entry(log_path, {
            "phase": "round_complete",
            "round": r,
            "end_time": _now_iso(),
        })

    print("\n✅ all rounds done")

if __name__ == "__main__":
    main()