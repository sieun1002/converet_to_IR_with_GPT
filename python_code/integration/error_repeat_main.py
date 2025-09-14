# main_pipeline.py
import os
import json
from typing import Dict, Any, List, Tuple
from openai import OpenAI
from bc_utils import now_iso, append_json_entry, assemble_ll_to_bc
from generative_ir import GPTRunner
from gpt_fix import GPTFixer

# ================= 사용자 설정 =================
API_KEY = os.getenv("OPENAI_API_KEY", "")

# 모델/프롬프트 (생성/수정 각각 분리 가능)
GENERATE_MODEL = "gpt-5"
FIX_MODEL      = "gpt-5"

GENERATE_SYSTEM_PROMPT      = ""
GENERATE_SYSTEM_PROMPT_FILE = "../systemprompt/short.txt"

FIX_SYSTEM_PROMPT      = ""
FIX_SYSTEM_PROMPT_FILE = "../systemprompt/error.txt"

# 입력/출력
INPUT_FOLDER_TXT = "/home/nata20034/workspace/convert_to_IR_with_LLM/ida_disassemble/O0/djkstra"               # 디스어셈블리 .txt 폴더
OUTPUT_ROOT      = "../../llm_to_IR/gpt_api_short/error_repeat/dijkstra"       # 라운드 루트

NUM_ROUNDS  = 1
START_INDEX = 1

INPUT_EXT_TXT = ".txt"

AS_BIN = "llvm-as-14"   # assemble 바이너리 경로
ASSEMBLE_TIMEOUT_SEC = 60

# 시도/버전 제한
MAX_IR_VERSIONS  = 5    # total IR files per input (1..5)
MAX_FIX_ATTEMPTS = 4    # fix 시도 최대 4

# Fix 입력 구성
ERROR_FIRST = True                    # 에러가 먼저, 그 후 IR (요구사항)
WRAP_ERROR_WITH_LL_COMMENTS = True    # ; 주석으로 감싸기
ERROR_PREVIEW_PRINT_CHARS = 300       # print 프리뷰 길이
IR_PREVIEW_PRINT_CHARS    = 200       # print 프리뷰 길이

# Debug 기록
WRITE_FIX_INPUT_DEBUG_FILE = True     # 결합 payload를 파일로 저장
# =================================================

def _load_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def _load_prompt(prompt_str: str, prompt_file: str) -> str:
    if prompt_file:
        return _load_text(prompt_file)
    return prompt_str

def _ensure_round_dir(round_dir: str) -> Dict[str, str]:
    os.makedirs(round_dir, exist_ok=True)
    paths = {
        "log": os.path.join(round_dir, "log.json"),
        "errors": os.path.join(round_dir, "errors.json"),
        "file_log": os.path.join(round_dir, "file_log.json"),
        "fix_inputs": os.path.join(round_dir, "fix_inputs.json"),
        "debug_fix_dir": os.path.join(round_dir, "debug_fix_inputs"),
    }
    os.makedirs(paths["debug_fix_dir"], exist_ok=True)
    # 초기화 파일들
    for p in [paths["log"], paths["errors"], paths["file_log"], paths["fix_inputs"]]:
        if not os.path.exists(p):
            with open(p, "w", encoding="utf-8") as f:
                json.dump({"meta": {}, "entries": []}, f, ensure_ascii=False, indent=2)
    return paths

def _append_simple_kv(file_log_path: str, key: str, value: str) -> None:
    # file_log.json 에 "a1.ll": "에러 ~" 같은 형태로 누적
    try:
        with open(file_log_path, "r+", encoding="utf-8") as f:
            data = json.load(f) or {}
            # 간단한 dict로 유지
            if "entries" in data and isinstance(data["entries"], list):
                # 기존 구조가 meta/entries면 entries를 dict처럼 쓰기 어려우니 변환
                flat = {"__migrated_from_entries__": data["entries"]}
                data = flat
            if not isinstance(data, dict):
                data = {}
            data[key] = value
            f.seek(0)
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.truncate()
    except FileNotFoundError:
        with open(file_log_path, "w", encoding="utf-8") as f:
            json.dump({key: value}, f, ensure_ascii=False, indent=2)

def _wrap_error(err_text: str, source_note: str = "assemble") -> str:
    if not err_text.strip():
        return ""
    if WRAP_ERROR_WITH_LL_COMMENTS:
        body = "\n".join("; " + line for line in err_text.splitlines())
        return f"; === ERROR LOG BEGIN [{source_note}] ===\n{body}\n; === ERROR LOG END ==="
    return err_text

def _compose_fix_input(ir_text: str, err_block: str) -> str:
    if not err_block.strip():
        return ir_text
    return (err_block + "\n\n" + ir_text) if ERROR_FIRST else (ir_text + "\n\n" + err_block)

def _save_text(path: str, text: str) -> None:
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)

def run_pipeline_for_file(
    base: str,
    disasm_text: str,
    paths: Dict[str, str],
    generator: GPTRunner,
    fixer: GPTFixer,
    round_dir: str,
) -> None:
    """
    한 개 파일(base)에 대해: generate -> assemble -> (실패 시) fix 루프
    """
    version = 1
    fix_attempts = 0
    # 1) generate
    print(f"\n▶ GENERATE {base} (version {version})")
    gen_ok, ir_text, gen_metrics = generator.run_once(
        disasm_text,
        log_path=paths["log"],
        log_extra={"filename": f"{base}.txt", "version": version},
    )
    ll_path = os.path.join(round_dir, f"{base}{version}.ll")
    _save_text(ll_path, ir_text if gen_ok else ir_text)  # 실패여도 기록(분석용)
    append_json_entry(paths["log"], {
        "phase": "ir_saved",
        "filename": f"{base}.txt",
        "version": version,
        "ll_path": ll_path,
        "success": gen_ok,
        "time": now_iso(),
    })
    # file_log (간단 요약)
    _append_simple_kv(paths["file_log"], f"{base}{version}.ll", "generated")

    # assemble
    bc_path = os.path.join(round_dir, f"{base}{version}.bc")
    print(f"→ ASSEMBLE {os.path.basename(ll_path)} → {os.path.basename(bc_path)}")
    res = assemble_ll_to_bc(ll_path, bc_path, as_bin=AS_BIN, timeout_sec=ASSEMBLE_TIMEOUT_SEC)
    append_json_entry(paths["log"], {
        "phase": "assemble_attempt",
        "filename": f"{base}.txt",
        "version": version,
        **res,
    })
    if res["success"]:
        print(f"✅ SUCCESS assemble {os.path.basename(ll_path)}")
        _append_simple_kv(paths["file_log"], f"{base}{version}.ll", "assemble success")
        return
    else:
        print(f"❌ FAIL assemble {os.path.basename(ll_path)} rc={res['returncode']}")
        err_text = res["stderr"] or res["stdout"] or "(no stderr/stdout)"
        # errors.json에 상세 저장
        append_json_entry(paths["errors"], {
            "filename": f"{base}.txt",
            "version": version,
            "ll_path": ll_path,
            "bc_path": bc_path,
            **res,
        })
        _append_simple_kv(paths["file_log"], f"{base}{version}.ll", f"assemble error: {err_text[:200]}")

    # 2) fix loop
    while fix_attempts < MAX_FIX_ATTEMPTS and version < MAX_IR_VERSIONS:
        prev_ll_path = ll_path
        prev_ir_text = _load_text(prev_ll_path)
        version += 1
        fix_attempts += 1

        print(f"\n▶ FIX {base} (version {version}) — error-first payload")
        err_block = _wrap_error(err_text, source_note="llvm-as")
        fix_input = _compose_fix_input(prev_ir_text, err_block)

        # 디버그 출력/기록 (프리뷰)
        err_preview = err_text[:ERROR_PREVIEW_PRINT_CHARS]
        ir_preview  = prev_ir_text[:IR_PREVIEW_PRINT_CHARS]
        print(f"   • error preview: {len(err_text)} chars -> {err_preview!r}")
        print(f"   • IR preview   : {len(prev_ir_text)} chars -> {ir_preview!r}")

        # fix_inputs.json 기록
        append_json_entry(paths["fix_inputs"], {
            "filename": f"{base}.txt",
            "version": version,
            "payload_order": "error_first_then_ir" if ERROR_FIRST else "ir_then_error",
            "error_len": len(err_text),
            "ir_len": len(prev_ir_text),
            "error_preview": err_preview,
            "ir_preview": ir_preview,
            "prev_ll_path": prev_ll_path,
        })

        # 디버그 payload 전체 저장(선택)
        if WRITE_FIX_INPUT_DEBUG_FILE:
            debug_in_path = os.path.join(paths["debug_fix_dir"], f"{base}_v{version}_input.txt")
            _save_text(debug_in_path, fix_input)
            print(f"   • fix input saved -> {os.path.basename(debug_in_path)}")

        # Fix GPT 호출
        fix_ok, fixed_ir, fix_metrics = fixer.run_once(
            fix_input,
            log_path=paths["log"],
            log_extra={"filename": f"{base}.txt", "version": version},
        )

        ll_path = os.path.join(round_dir, f"{base}{version}.ll")
        _save_text(ll_path, fixed_ir if fix_ok else fixed_ir)
        append_json_entry(paths["log"], {
            "phase": "ir_saved",
            "filename": f"{base}.txt",
            "version": version,
            "ll_path": ll_path,
            "success": fix_ok,
            "time": now_iso(),
        })
        _append_simple_kv(paths["file_log"], f"{base}{version}.ll", "fixed")

        # assemble
        bc_path = os.path.join(round_dir, f"{base}{version}.bc")
        print(f"→ ASSEMBLE {os.path.basename(ll_path)} → {os.path.basename(bc_path)}")
        res = assemble_ll_to_bc(ll_path, bc_path, as_bin=AS_BIN, timeout_sec=ASSEMBLE_TIMEOUT_SEC)
        append_json_entry(paths["log"], {
            "phase": "assemble_attempt",
            "filename": f"{base}.txt",
            "version": version,
            **res,
        })
        if res["success"]:
            print(f"✅ SUCCESS assemble {os.path.basename(ll_path)}")
            _append_simple_kv(paths["file_log"], f"{base}{version}.ll", "assemble success")
            return
        else:
            print(f"❌ FAIL assemble {os.path.basename(ll_path)} rc={res['returncode']}")
            err_text = res["stderr"] or res["stdout"] or "(no stderr/stdout)"
            append_json_entry(paths["errors"], {
                "filename": f"{base}.txt",
                "version": version,
                "ll_path": ll_path,
                "bc_path": bc_path,
                **res,
            })
            _append_simple_kv(paths["file_log"], f"{base}{version}.ll", f"assemble error: {err_text[:200]}")

    # 여기 오면: 성공 못했거나 한도 도달
    print(f"⛔ STOP {base} — reached limits (versions={version}, fixes={fix_attempts})")
    append_json_entry(paths["log"], {
        "phase": "file_limits_reached",
        "filename": f"{base}.txt",
        "last_version": version,
        "fix_attempts": fix_attempts,
        "time": now_iso(),
    })

def main():
    print(OUTPUT_ROOT)
    client = OpenAI(api_key=API_KEY)

    generator = GPTRunner(
        client=client,
        model=GENERATE_MODEL,
        system_prompt=_load_prompt(GENERATE_SYSTEM_PROMPT, GENERATE_SYSTEM_PROMPT_FILE),
        max_retries=4,
        verbose=True,
    )
    fixer = GPTFixer(
        client=client,
        model=FIX_MODEL,
        system_prompt=_load_prompt(FIX_SYSTEM_PROMPT, FIX_SYSTEM_PROMPT_FILE),
        max_retries=4,
        verbose=True,
    )

    for r in range(START_INDEX, START_INDEX + NUM_ROUNDS):
        round_dir = os.path.join(OUTPUT_ROOT, str(r))
        paths = _ensure_round_dir(round_dir)

        # 라운드 메타
        with open(paths["log"], "r+", encoding="utf-8") as f:
            data = json.load(f) or {}
            data["meta"] = {
                "round": r,
                "start_time": now_iso(),
                "input_folder": os.path.abspath(INPUT_FOLDER_TXT),
                "output_dir": os.path.abspath(round_dir),
                "generate_model": GENERATE_MODEL,
                "fix_model": FIX_MODEL,
                "max_ir_versions": MAX_IR_VERSIONS,
                "max_fix_attempts": MAX_FIX_ATTEMPTS,
                "error_first": ERROR_FIRST,
            }
            f.seek(0); json.dump(data, f, ensure_ascii=False, indent=2); f.truncate()

        files = sorted(fn for fn in os.listdir(INPUT_FOLDER_TXT) if fn.endswith(INPUT_EXT_TXT))
        for filename in files:
            base = os.path.splitext(filename)[0]
            disasm_text = _load_text(os.path.join(INPUT_FOLDER_TXT, filename))
            print(f"\n================ FILE: {filename} (base={base}) ================")
            run_pipeline_for_file(base, disasm_text, paths, generator, fixer, round_dir)

        append_json_entry(paths["log"], {
            "phase": "round_complete",
            "round": r,
            "end_time": now_iso(),
        })
        print(f"\n✅ ROUND {r} COMPLETE")

if __name__ == "__main__":
    main()
