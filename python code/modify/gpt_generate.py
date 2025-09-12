# txt_to_ll_module.py
from __future__ import annotations
import os
import time
from pathlib import Path
from typing import Optional, Dict, Any
from openai import OpenAI

DEFAULT_SYSTEM_PROMPT = """\
You are an LLVM 14 IR generator.
- Input: plain-text description or disassembly in the file.
- Output: ONE valid LLVM 14 IR module ONLY (no markdown fences, no explanations).
- Target triple: x86_64-unknown-linux-gnu
- Do NOT use opaque pointers; use typed pointers only (no bare `ptr`).
- The IR must assemble with llvm-as-14.
"""

def _extract_output_text(resp) -> str:
    """
    OpenAI SDK 편의 프로퍼티 우선 사용, 부족하면 호환 경로로 병합.
    """
    text = getattr(resp, "output_text", None)
    if isinstance(text, str) and text.strip():
        return text.strip()

    try:
        parts = []
        for item in getattr(resp, "output", []) or []:
            for c in getattr(item, "content", []) or []:
                if hasattr(c, "text") and c.text:
                    parts.append(c.text)
        return "".join(parts).strip()
    except Exception:
        return ""

def generate_ll_from_txt(
    input_path: str,
    *,
    output_dir: Optional[str] = None,
    output_file: Optional[str] = None,
    model: str = "gpt-5",
    system_prompt: str = DEFAULT_SYSTEM_PROMPT,
    api_key: Optional[str] = None,
) -> Dict[str, Any]:
    """
    단일 텍스트 파일을 입력으로 받아 LLM 결과를 .ll로 저장.
    반환: {"ll_path": str|None, "elapsed_sec": float, "error": str|None}

    - output_dir 미지정 시: 입력 파일과 같은 폴더
    - output_file 지정 시: 해당 경로로 저장(확장자는 .ll 권장)
    """
    src = Path(input_path).resolve()
    if not src.exists():
        return {"ll_path": None, "elapsed_sec": 0.0, "error": f"Input not found: {src}"}

    # 출력 경로 결정
    if output_file:
        ll_path = Path(output_file).resolve()
        ll_path.parent.mkdir(parents=True, exist_ok=True)
    else:
        out_dir = Path(output_dir).resolve() if output_dir else src.parent
        out_dir.mkdir(parents=True, exist_ok=True)
        ll_path = out_dir / (src.stem + ".ll")

    # API 키
    if api_key is None:
        api_key = os.getenv("OPENAI_API_KEY", "")

    # 파일 읽기
    try:
        file_content = src.read_text(encoding="utf-8")
    except Exception as e:
        return {"ll_path": None, "elapsed_sec": 0.0, "error": f"ReadError: {e}"}

    client = OpenAI(api_key=api_key)

    t0 = time.perf_counter()
    try:
        resp = client.responses.create(
            model=model,
            input=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": file_content},
            ],
        )
        output_text = _extract_output_text(resp)
        if not output_text:
            dt = time.perf_counter() - t0
            return {"ll_path": None, "elapsed_sec": round(dt, 6), "error": "Empty response from model"}
    except Exception as e:
        dt = time.perf_counter() - t0
        return {"ll_path": None, "elapsed_sec": round(dt, 6), "error": f"OpenAIError: {e}"}

    # 저장
    try:
        # IR 코드 블록 펜스가 있다면 제거
        cleaned = output_text.strip()
        if cleaned.startswith("```"):
            first_nl = cleaned.find("\n")
            if first_nl != -1:
                cleaned = cleaned[first_nl + 1 :]
            if cleaned.endswith("```"):
                cleaned = cleaned[:-3]
        cleaned = cleaned.strip()

        ll_path.write_text(cleaned, encoding="utf-8")
    except Exception as e:
        dt = time.perf_counter() - t0
        return {"ll_path": None, "elapsed_sec": round(dt, 6), "error": f"WriteError: {e}"}

    dt = time.perf_counter() - t0
    return {"ll_path": str(ll_path), "elapsed_sec": round(dt, 6), "error": None}


# ---- (선택) 간단 CLI ----
if __name__ == "__main__":
    import argparse, json
    p = argparse.ArgumentParser(description="Generate LLVM .ll from a text file via OpenAI and report elapsed time.")
    p.add_argument("input_path", help="입력 텍스트 파일 경로")
    p.add_argument("--out-dir", default=None, help="출력 디렉터리(지정 없으면 입력 파일 폴더)")
    p.add_argument("--out-file", default=None, help="출력 .ll 전체 경로(우선 적용)")
    p.add_argument("--model", default="gpt-5")
    p.add_argument("--system-prompt", default=DEFAULT_SYSTEM_PROMPT)
    args = p.parse_args()

    res = generate_ll_from_txt(
        args.input_path,
        output_dir=args.out_dir,
        output_file=args.out_file,
        model=args.model,
        system_prompt=args.system_prompt,
    )
    print(json.dumps(res, ensure_ascii=False, indent=2))
