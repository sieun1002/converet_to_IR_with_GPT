# gpt_fix.py
from typing import Tuple, Dict, Any, Optional
from openai import OpenAI
import time
from bc_utils import append_json_entry, now_iso

def _extract_output_text(response) -> str:
    try:
        return response.output_text
    except Exception:
        pass
    try:
        parts = []
        for item in getattr(response, "output", []) or []:
            for c in getattr(item, "content", []) or []:
                txt = getattr(c, "text", None)
                if txt:
                    parts.append(txt)
        return "\n".join(parts).strip()
    except Exception:
        return ""

class GPTFixer:
    def __init__(
        self,
        client: OpenAI,
        model: str = "gpt-5",
        system_prompt: str = "",
        max_retries: int = 4,
        verbose: bool = True,
    ):
        self.client = client
        self.model = model
        self.system_prompt = system_prompt
        self.max_retries = max_retries
        self.verbose = verbose

    def run_once(
        self,
        user_content: str,
        *,
        log_path: Optional[str] = None,
        log_extra: Optional[Dict[str, Any]] = None,
    ) -> Tuple[bool, str, Dict[str, Any]]:
        attempt = 0
        while attempt <= self.max_retries:
            t0 = time.perf_counter()
            t0_iso = now_iso()
            try:
                resp = self.client.responses.create(
                    model=self.model,
                    input=[
                        {"role": "system", "content": self.system_prompt},
                        {"role": "user", "content": user_content},
                    ],
                )
                out = _extract_output_text(resp)
                dt = time.perf_counter() - t0
                usage = getattr(resp, "usage", None)
                metrics = {
                    "request_id": getattr(resp, "id", None),
                    "model": self.model,
                    "start_time": t0_iso,
                    "end_time": now_iso(),
                    "elapsed_sec": round(dt, 6),
                    "usage": {
                        "input_tokens": getattr(usage, "input_tokens", None) if usage else None,
                        "output_tokens": getattr(usage, "output_tokens", None) if usage else None,
                        "total_tokens": getattr(usage, "total_tokens", None) if usage else None,
                    },
                    "attempt": attempt + 1,
                    "retries": attempt,
                    "error": None,
                }
                if self.verbose:
                    print(f"✅ FIX OK id={metrics['request_id']} time={metrics['elapsed_sec']}s")

                if log_path:
                    append_json_entry(log_path, {
                        "phase": "gpt_fix_call",
                        **(log_extra or {}),
                        **metrics,
                        "success": True,
                    })
                return True, out, metrics

            except Exception as e:
                dt = time.perf_counter() - t0
                metrics = {
                    "request_id": None,
                    "model": self.model,
                    "start_time": t0_iso,
                    "end_time": now_iso(),
                    "elapsed_sec": round(dt, 6),
                    "usage": None,
                    "attempt": attempt + 1,
                    "retries": attempt,
                    "error": str(e),
                }
                if attempt < self.max_retries:
                    backoff = min(30.0, (2.0 * (1.5 ** attempt)))
                    if self.verbose:
                        print(f"⚠️ FIX 실패 attempt={attempt+1}/{self.max_retries+1} err={metrics['error']} -> {backoff:.1f}s 대기")
                    if log_path:
                        append_json_entry(log_path, {
                            "phase": "gpt_fix_retry_fail",
                            **(log_extra or {}),
                            **metrics,
                            "success": False,
                            "backoff_sec": backoff,
                        })
                    time.sleep(backoff)
                    attempt += 1
                else:
                    if self.verbose:
                        print(f"❌ FIX 최종 실패 err={metrics['error']}")
                    if log_path:
                        append_json_entry(log_path, {
                            "phase": "gpt_fix_final_fail",
                            **(log_extra or {}),
                            **metrics,
                            "success": False,
                        })
                    return False, "", metrics
