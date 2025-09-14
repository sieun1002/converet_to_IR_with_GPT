# gpt_runner.py
import json
import time
from datetime import datetime
from typing import Tuple, Dict, Any, Optional
from openai import OpenAI

def _now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")

def _extract_output_text(response) -> str:
    # Responses API 권장 경로
    try:
        return response.output_text
    except Exception:
        pass
    # 호환 경로 (버전별 필드 차이 대비)
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

def _append_json_entry(log_path: str, entry: Dict[str, Any]) -> None:
    """log_path(JSON 파일)의 'entries' 배열에 entry를 append."""
    try:
        with open(log_path, "r+", encoding="utf-8") as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                data = {}
            if not isinstance(data, dict):
                data = {}
            if "entries" not in data or not isinstance(data["entries"], list):
                data["entries"] = []
            data["entries"].append(entry)
            f.seek(0)
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.truncate()
    except FileNotFoundError:
        data = {"entries": [entry]}
        with open(log_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

class GPTRunner:
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
        """
        단일 입력(user_content)을 GPT에 처리(재시도 포함).
        - log_path가 주어지면, GPT 메트릭을 log.json의 'entries'에 즉시 append.
        - log_extra는 파일명 등 상위 컨텍스트를 함께 기록할 때 사용.
        반환: (success, output_text, metrics)
        """
        attempt = 0
        while attempt <= self.max_retries:
            t0 = time.perf_counter()
            t0_iso = _now_iso()
            try:
                resp = self.client.responses.create(
                    model=self.model,
                    input=[
                        {"role": "system", "content": self.system_prompt},
                        {"role": "user", "content": user_content},
                    ],
                )
                out = _extract_output_text(resp)
                t1 = time.perf_counter()
                usage = getattr(resp, "usage", None)
                metrics = {
                    "request_id": getattr(resp, "id", None),
                    "model": self.model,
                    "start_time": t0_iso,
                    "end_time": _now_iso(),
                    "elapsed_sec": round(t1 - t0, 6),
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
                    it = metrics["usage"]["input_tokens"]
                    ot = metrics["usage"]["output_tokens"]
                    tt = metrics["usage"]["total_tokens"]
                    print(f"✅ GPT OK id={metrics['request_id']} time={metrics['elapsed_sec']}s tokens={it}/{ot}/{tt}")

                # JSON에 즉시 기록
                if log_path:
                    entry = {
                        "phase": "gpt_call",
                        **(log_extra or {}),
                        **metrics,
                        "success": True,
                    }
                    _append_json_entry(log_path, entry)

                return True, out, metrics

            except Exception as e:
                t1 = time.perf_counter()
                err = str(e)
                metrics = {
                    "request_id": None,
                    "model": self.model,
                    "start_time": t0_iso,
                    "end_time": _now_iso(),
                    "elapsed_sec": round(t1 - t0, 6),
                    "usage": None,
                    "attempt": attempt + 1,
                    "retries": attempt,
                    "error": err,
                }
                if attempt < self.max_retries:
                    backoff = min(30.0, (2.0 * (1.5 ** attempt)))
                    if self.verbose:
                        print(f"⚠️ GPT 실패 attempt={attempt+1}/{self.max_retries+1} err={err}\n   {backoff:.1f}s 대기 후 재시도")
                    # 실패 기록도 남겨두고 재시도
                    if log_path:
                        _append_json_entry(log_path, {
                            "phase": "gpt_call_retry_fail",
                            **(log_extra or {}),
                            **metrics,
                            "success": False,
                            "backoff_sec": backoff,
                        })
                    time.sleep(backoff)
                    attempt += 1
                else:
                    if self.verbose:
                        print(f"❌ GPT 최종 실패 err={err}")
                    # 최종 실패 기록
                    if log_path:
                        _append_json_entry(log_path, {
                            "phase": "gpt_call_final_fail",
                            **(log_extra or {}),
                            **metrics,
                            "success": False,
                        })
                    return False, "", metrics
