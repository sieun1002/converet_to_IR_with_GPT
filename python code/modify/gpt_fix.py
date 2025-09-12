# ir_fix_module.py (temperature, max_output_tokens 제거판)
from __future__ import annotations
import os
from typing import Optional
from openai import OpenAI

DEFAULT_SYSTEM_PROMPT = """You are an LLVM 14 IR fixer.
- Input: a broken LLVM 14 IR ("bad_IR") and the compiler/linker error message.
- Output: a single corrected LLVM 14 IR module ONLY (no markdown fences, no extra text).
- Target: x86_64-unknown-linux-gnu, LLVM 14 syntax.
- Disallow opaque pointers (use typed pointers, no bare `ptr`).
- The IR must assemble with llvm-as-14 without errors.
"""

def rewrite_ir(
    bad_ir: str,
    error: str,
    *,
    model: str = "gpt-4",
    system_prompt: str = DEFAULT_SYSTEM_PROMPT,
    api_key: Optional[str] = None,
) -> str:
    """
    bad_ir와 error를 입력받아, 고쳐진 LLVM IR(good_IR)을 문자열로 반환.
    실패/빈 응답일 경우 빈 문자열을 반환.
    """
    if api_key is None:
        api_key = os.getenv("OPENAI_API_KEY", "")

    client = OpenAI(api_key=api_key)
    user_content = f"bad_IR:\n{bad_ir}\n\nerror message:\n{error}\n"

    resp = client.responses.create(
        model=model,
        input=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_content},
        ],
    )

    text = getattr(resp, "output_text", None)
    if isinstance(text, str) and text.strip():
        return _strip_md_fences(text)

    # 호환 처리
    try:
        parts = []
        for item in resp.output:
            for c in getattr(item, "content", []) or []:
                if getattr(c, "type", "") == "output_text" or hasattr(c, "text"):
                    parts.append(getattr(c, "text", "") or getattr(c, "content", ""))
        return _strip_md_fences("".join(parts).strip())
    except Exception:
        return ""

def _strip_md_fences(text: str) -> str:
    t = text.strip()
    if t.startswith("```"):
        first_nl = t.find("\n")
        if first_nl != -1:
            t = t[first_nl + 1 :]
        if t.endswith("```"):
            t = t[:-3]
    return t.strip()

if __name__ == "__main__":
    import argparse, sys
    p = argparse.ArgumentParser(description="Fix LLVM 14 IR using OpenAI.")
    p.add_argument("--model", default="gpt-4")
    p.add_argument("--system-prompt", default=DEFAULT_SYSTEM_PROMPT)
    p.add_argument("--bad-ir-file", help="깨진 IR 파일 경로 (없으면 stdin 사용)")
    p.add_argument("--error-file", help="에러 메시지 파일 경로 (없으면 빈 문자열)")
    args = p.parse_args()

    bad_ir = ""
    if args.bad_ir_file:
        with open(args.bad_ir_file, "r", encoding="utf-8") as f:
            bad_ir = f.read()
    else:
        bad_ir = sys.stdin.read()

    error = ""
    if args.error_file:
        with open(args.error_file, "r", encoding="utf-8") as f:
            error = f.read()

    fixed = rewrite_ir(
        bad_ir=bad_ir,
        error=error,
        model=args.model,
        system_prompt=args.system_prompt,
    )
    print(fixed)
