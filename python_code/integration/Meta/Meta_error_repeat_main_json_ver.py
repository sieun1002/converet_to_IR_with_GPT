# main_pipeline.py 
import os
import json
import glob
import shutil
from typing import Dict, Any, List, Optional

from bc_utils import now_iso, append_json_entry, assemble_ll_to_bc
from Meta_generative_ir import GPTRunner
from Meta_gpt_fix import GPTFixer

# ================= 사용자 설정 =================
# JSON 입력 경로 및 타입 필터
INPUT_JSON_PATH = "/root/workspace/LLM4Decompile/legacy-test/decompile-eval-executable-gcc-obj.json"
TYPE_FILTER: Optional[set[str]] = {"O0", "O3"}  # None 이면 전체 타입 처리

# task_id 범위 (inclusive). None이면 경계 없음.
TASK_ID_START: Optional[int] = 118
TASK_ID_END: Optional[int] = 120

# Hugging Face 모델/프롬프트
GENERATE_MODEL = "facebook/llm-compiler-13b-ftd"
FIX_MODEL = "facebook/llm-compiler-13b-ftd"

GENERATE_SYSTEM_PROMPT = ""
GENERATE_SYSTEM_PROMPT_FILE = "../../systemprompt/error_analysis.txt"

FIX_SYSTEM_PROMPT = ""
FIX_SYSTEM_PROMPT_FILE = "../../systemprompt/fix.txt"

# 출력 루트 (라운드 단위 폴더 생성됨)
OUTPUT_ROOT = "../../../llm_to_IR/Meta_compiler_13b_ftd_json"

# 라운드 및 버전/시도 제한
NUM_ROUNDS = 1
START_INDEX = 1

# LLVM assemble
AS_BIN = "llvm-as-14"
ASSEMBLE_TIMEOUT_SEC = 60

MAX_IR_VERSIONS = 5
MAX_FIX_ATTEMPTS = 4

# Fix 입력 구성
ERROR_FIRST = True
WRAP_ERROR_WITH_LL_COMMENTS = True
ERROR_PREVIEW_PRINT_CHARS = 300
IR_PREVIEW_PRINT_CHARS = 200

# Debug 기록
WRITE_FIX_INPUT_DEBUG_FILE = True
# =================================================


def _load_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def _save_text(path: str, text: str) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)


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
        "tmp_dir": os.path.join(round_dir, "_tmp"),
        "ll_dir": os.path.join(round_dir, "ll"),
        "bc_dir": os.path.join(round_dir, "bc"),
    }
    os.makedirs(paths["debug_fix_dir"], exist_ok=True)
    os.makedirs(paths["tmp_dir"], exist_ok=True)
    os.makedirs(paths["ll_dir"], exist_ok=True)
    os.makedirs(paths["bc_dir"], exist_ok=True)

    for p in [paths["log"], paths["errors"], paths["file_log"], paths["fix_inputs"]]:
        if not os.path.exists(p):
            with open(p, "w", encoding="utf-8") as f:
                json.dump({"meta": {}, "entries": []}, f, ensure_ascii=False, indent=2)
    return paths


def _append_simple_kv(file_log_path: str, key: str, value: str) -> None:
    """
    file_log.json 에 key:value 형태로 누적 기록
    (기존이 meta/entries 구조면 간단 dict로 마이그레이션)
    """
    try:
        with open(file_log_path, "r+", encoding="utf-8") as f:
            data = json.load(f) or {}
            if "entries" in data and isinstance(data["entries"], list):
                data = {"__migrated_from_entries__": data["entries"]}
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


def _cleanup_tmp_for_base(tmp_dir: str, base: str) -> None:
    for pat in (f"{base}_v*.ll", f"{base}_v*.bc"):
        for p in glob.glob(os.path.join(tmp_dir, pat)):
            try:
                os.remove(p)
            except Exception:
                pass


def _load_json_records(
    json_path: str,
    type_filter: Optional[set[str]],
    task_id_start: Optional[int],
    task_id_end: Optional[int],
) -> List[Dict[str, Any]]:
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, list):
        raise ValueError("INPUT JSON must be a list of records.")

    if (task_id_start is not None) and (task_id_end is not None) and (task_id_start > task_id_end):
        raise ValueError(f"TASK_ID_START ({task_id_start}) must be <= TASK_ID_END ({task_id_end}).")

    records: List[Dict[str, Any]] = []
    for rec in data:
        if not all(k in rec for k in ("task_id", "type", "input_asm_prompt")):
            continue
        if type_filter is not None and rec.get("type") not in type_filter:
            continue

        tid = rec.get("task_id")
        if not isinstance(tid, int):
            try:
                tid = int(tid)
            except Exception:
                continue

        if task_id_start is not None and tid < task_id_start:
            continue
        if task_id_end is not None and tid > task_id_end:
            continue

        records.append(rec)
    return records


def run_pipeline_for_record(
    task_id: Any,
    otype: str,
    disasm_text: str,
    paths: Dict[str, str],
    generator: GPTRunner,
    fixer: GPTFixer,
    round_dir: str,
) -> None:
    """
    최종 산출물:
      - round_dir/ll/{task_id}_{otype}.ll  (최종본 1개만)
      - round_dir/bc/{task_id}_{otype}.bc
    """
    base = f"{task_id}_{otype}"
    version = 1
    fix_attempts = 0

    tmp_dir = paths["tmp_dir"]
    ll_dir = paths["ll_dir"]
    bc_dir = paths["bc_dir"]

    final_ll_path = os.path.join(ll_dir, f"{base}.ll")
    final_bc_path = os.path.join(bc_dir, f"{base}.bc")

    # 기존 결과 제거
    for p in (final_ll_path, final_bc_path):
        if os.path.exists(p):
            try:
                os.remove(p)
            except Exception:
                pass

    _cleanup_tmp_for_base(tmp_dir, base)

    # 1) generate
    print(f"\n▶ GENERATE {base} (version {version})")
    gen_ok, ir_text, _gen_metrics = generator.run_once(
        disasm_text,
        log_path=paths["log"],
        log_extra={"task_id": task_id, "type": otype, "version": version},
    )

    tmp_ll_path = os.path.join(tmp_dir, f"{base}_v{version}.ll")
    _save_text(tmp_ll_path, ir_text)
    append_json_entry(paths["log"], {
        "phase": "ir_saved_tmp",
        "task_id": task_id,
        "type": otype,
        "version": version,
        "tmp_ll_path": tmp_ll_path,
        "success": gen_ok,
        "time": now_iso(),
    })
    _append_simple_kv(paths["file_log"], f"{base}.ll@v{version}", "generated (tmp)")

    # assemble
    tmp_bc_path = os.path.join(tmp_dir, f"{base}_v{version}.bc")
    print(f"→ ASSEMBLE {os.path.basename(tmp_ll_path)} → {os.path.basename(tmp_bc_path)}")
    res = assemble_ll_to_bc(tmp_ll_path, tmp_bc_path, as_bin=AS_BIN, timeout_sec=ASSEMBLE_TIMEOUT_SEC)
    append_json_entry(paths["log"], {
        "phase": "assemble_attempt",
        "task_id": task_id,
        "type": otype,
        "version": version,
        **res,
    })

    if res.get("success"):
        shutil.move(tmp_ll_path, final_ll_path)
        shutil.move(tmp_bc_path, final_bc_path)
        _cleanup_tmp_for_base(tmp_dir, base)
        _append_simple_kv(paths["file_log"], f"ll/{base}.ll", f"assemble success in {version} attempt(s)")
        _append_simple_kv(paths["file_log"], f"bc/{base}.bc", f"assemble success in {version} attempt(s)")
        append_json_entry(paths["log"], {
            "phase": "finalize_success",
            "task_id": task_id,
            "type": otype,
            "attempts_total": version,
            "fix_attempts": version - 1,
            "final_ll_path": final_ll_path,
            "final_bc_path": final_bc_path,
            "time": now_iso(),
        })
        print(f"✅ SUCCESS — saved: ll/{os.path.basename(final_ll_path)}, bc/{os.path.basename(final_bc_path)}")
        return

    print(f"❌ FAIL assemble {os.path.basename(tmp_ll_path)} rc={res.get('returncode')}")
    err_text = res.get("stderr") or res.get("stdout") or "(no stderr/stdout)"
    append_json_entry(paths["errors"], {
        "task_id": task_id,
        "type": otype,
        "version": version,
        "tmp_ll_path": tmp_ll_path,
        "tmp_bc_path": tmp_bc_path,
        **res,
    })
    _append_simple_kv(paths["file_log"], f"{base}.ll@v{version}", f"assemble error: {err_text[:200]}")

    # 2) fix loop
    while fix_attempts < MAX_FIX_ATTEMPTS and version < MAX_IR_VERSIONS:
        prev_ir_text = _load_text(tmp_ll_path)
        version += 1
        fix_attempts += 1

        print(f"\n▶ FIX {base} (version {version}) — error-first payload")
        err_block = _wrap_error(err_text, source_note="llvm-as")
        fix_input = _compose_fix_input(prev_ir_text, err_block)

        # 디버그 프리뷰
        err_preview = err_text[:ERROR_PREVIEW_PRINT_CHARS]
        ir_preview = prev_ir_text[:IR_PREVIEW_PRINT_CHARS]
        print(f"   • error preview: {len(err_text)} chars -> {err_preview!r}")
        print(f"   • IR preview   : {len(prev_ir_text)} chars -> {ir_preview!r}")

        append_json_entry(paths["fix_inputs"], {
            "task_id": task_id,
            "type": otype,
            "version": version,
            "payload_order": "error_first_then_ir" if ERROR_FIRST else "ir_then_error",
            "error_len": len(err_text),
            "ir_len": len(prev_ir_text),
            "error_preview": err_preview,
            "ir_preview": ir_preview,
            "prev_tmp_ll_path": tmp_ll_path,
        })

        if WRITE_FIX_INPUT_DEBUG_FILE:
            debug_in_path = os.path.join(paths["debug_fix_dir"], f"{base}_v{version}_input.txt")
            _save_text(debug_in_path, fix_input)
            print(f"   • fix input saved -> {os.path.basename(debug_in_path)}")

        fix_ok, fixed_ir, _fix_metrics = fixer.run_once(
            fix_input,
            log_path=paths["log"],
            log_extra={"task_id": task_id, "type": otype, "version": version},
        )

        tmp_ll_path = os.path.join(tmp_dir, f"{base}_v{version}.ll")
        _save_text(tmp_ll_path, fixed_ir)
        append_json_entry(paths["log"], {
            "phase": "ir_saved_tmp",
            "task_id": task_id,
            "type": otype,
            "version": version,
            "tmp_ll_path": tmp_ll_path,
            "success": fix_ok,
            "time": now_iso(),
        })
        _append_simple_kv(paths["file_log"], f"{base}.ll@v{version}", "fixed (tmp)")

        tmp_bc_path = os.path.join(tmp_dir, f"{base}_v{version}.bc")
        print(f"→ ASSEMBLE {os.path.basename(tmp_ll_path)} → {os.path.basename(tmp_bc_path)}")
        res = assemble_ll_to_bc(tmp_ll_path, tmp_bc_path, as_bin=AS_BIN, timeout_sec=ASSEMBLE_TIMEOUT_SEC)
        append_json_entry(paths["log"], {
            "phase": "assemble_attempt",
            "task_id": task_id,
            "type": otype,
            "version": version,
            **res,
        })

        if res.get("success"):
            shutil.move(tmp_ll_path, final_ll_path)
            shutil.move(tmp_bc_path, final_bc_path)
            _cleanup_tmp_for_base(tmp_dir, base)
            _append_simple_kv(paths["file_log"], f"ll/{base}.ll", f"assemble success in {version} attempt(s)")
            _append_simple_kv(paths["file_log"], f"bc/{base}.bc", f"assemble success in {version} attempt(s)")
            append_json_entry(paths["log"], {
                "phase": "finalize_success",
                "task_id": task_id,
                "type": otype,
                "attempts_total": version,
                "fix_attempts": version - 1,
                "final_ll_path": final_ll_path,
                "final_bc_path": final_bc_path,
                "time": now_iso(),
            })
            print(f"✅ SUCCESS — saved: ll/{os.path.basename(final_ll_path)}, bc/{os.path.basename(final_bc_path)}")
            return

        print(f"❌ FAIL assemble {os.path.basename(tmp_ll_path)} rc={res.get('returncode')}")
        err_text = res.get("stderr") or res.get("stdout") or "(no stderr/stdout)"
        append_json_entry(paths["errors"], {
            "task_id": task_id,
            "type": otype,
            "version": version,
            "tmp_ll_path": tmp_ll_path,
            "tmp_bc_path": tmp_bc_path,
            **res,
        })
        _append_simple_kv(paths["file_log"], f"{base}.ll@v{version}", f"assemble error: {err_text[:200]}")

    # 실패 종료
    _cleanup_tmp_for_base(paths["tmp_dir"], base)
    print(f"⛔ STOP {base} — reached limits (versions={version}, fixes={fix_attempts})")
    append_json_entry(paths["log"], {
        "phase": "finalize_fail",
        "task_id": task_id,
        "type": otype,
        "last_version": version,
        "attempts_total": version,
        "fix_attempts": fix_attempts,
        "time": now_iso(),
    })


def main():
    print(OUTPUT_ROOT)

    # Hugging Face Runner 초기화 (OpenAI client 없음)
    generator = GPTRunner(
        model=GENERATE_MODEL,
        system_prompt=_load_prompt(GENERATE_SYSTEM_PROMPT, GENERATE_SYSTEM_PROMPT_FILE),
        max_retries=4,
        verbose=True,
    )
    fixer = GPTFixer(
        model=FIX_MODEL,
        system_prompt=_load_prompt(FIX_SYSTEM_PROMPT, FIX_SYSTEM_PROMPT_FILE),
        max_retries=4,
        verbose=True,
    )

    # JSON 레코드 로드 (+ 타입/ID 범위 필터)
    records = _load_json_records(
        INPUT_JSON_PATH,
        TYPE_FILTER,
        TASK_ID_START,
        TASK_ID_END,
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
                "input_json": os.path.abspath(INPUT_JSON_PATH),
                "type_filter": sorted(list(TYPE_FILTER)) if TYPE_FILTER else "ALL",
                "task_id_range": {
                    "start": TASK_ID_START if TASK_ID_START is not None else "MIN",
                    "end": TASK_ID_END if TASK_ID_END is not None else "MAX",
                },
                "output_dir": os.path.abspath(round_dir),
                "generate_model": GENERATE_MODEL,
                "fix_model": FIX_MODEL,
                "max_ir_versions": MAX_IR_VERSIONS,
                "max_fix_attempts": MAX_FIX_ATTEMPTS,
                "error_first": ERROR_FIRST,
                "ll_dir": paths["ll_dir"],
                "bc_dir": paths["bc_dir"],
                "as_bin": AS_BIN,
                "assemble_timeout_sec": ASSEMBLE_TIMEOUT_SEC,
            }
            f.seek(0)
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.truncate()

        for rec in records:
            task_id = rec.get("task_id")
            otype = rec.get("type")
            disasm_text = rec.get("input_asm_prompt") or ""
            base = f"{task_id}_{otype}"
            print(f"\n================ RECORD: task_id={task_id}, type={otype} -> base={base} ================")
            if not disasm_text.strip():
                print("⚠️  empty input_asm_prompt — skip")
                append_json_entry(paths["log"], {
                    "phase": "skip_empty_input",
                    "task_id": task_id,
                    "type": otype,
                    "time": now_iso(),
                })
                continue
            run_pipeline_for_record(task_id, otype, disasm_text, paths, generator, fixer, round_dir)

        append_json_entry(paths["log"], {
            "phase": "round_complete",
            "round": r,
            "end_time": now_iso(),
        })
        print(f"\n✅ ROUND {r} COMPLETE")


if __name__ == "__main__":
    main()