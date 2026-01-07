# gpt_runner.py ((메타의 llm-compiler-13b-ftd 사용))
import os
import json
import time
from datetime import datetime
from typing import Tuple, Dict, Any, Optional

import torch
from transformers import AutoTokenizer, AutoModelForCausalLM


def _now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")


def _append_json_entry(log_path: str, entry: Dict[str, Any]) -> None:
    try:
        with open(log_path, "r+", encoding="utf-8") as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                data = {}
            if "entries" not in data or not isinstance(data.get("entries"), list):
                data["entries"] = []
            data["entries"].append(entry)
            f.seek(0)
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.truncate()
    except FileNotFoundError:
        with open(log_path, "w", encoding="utf-8") as f:
            json.dump({"entries": [entry]}, f, ensure_ascii=False, indent=2)


class GPTRunner:
    def __init__(
        self,
        *,
        model: str,
        system_prompt: str = "",
        max_retries: int = 4,
        verbose: bool = True,
        max_new_tokens: int = 2048,
        do_sample: bool = False,
        temperature: float = 0.1,
        top_p: float = 0.95,
        top_k: int = 50,
    ):
        self.model_id = model
        self.system_prompt = system_prompt
        self.max_retries = max_retries
        self.verbose = verbose

        self.max_new_tokens = max_new_tokens
        self.do_sample = do_sample
        self.temperature = temperature
        self.top_p = top_p
        self.top_k = top_k

        hf_token = os.getenv("HUGGINGFACE_HUB_TOKEN") or os.getenv("HF_TOKEN")

        tok_kwargs = {}
        if hf_token:
            tok_kwargs["token"] = hf_token

        self.tokenizer = AutoTokenizer.from_pretrained(self.model_id, **tok_kwargs)
        if self.tokenizer.pad_token is None:
            self.tokenizer.pad_token = self.tokenizer.eos_token

        model_kwargs = dict(
            device_map="auto",
            torch_dtype=torch.float16,
            low_cpu_mem_usage=True,
        )
        if hf_token:
            model_kwargs["token"] = hf_token

        self.model = AutoModelForCausalLM.from_pretrained(self.model_id, **model_kwargs)
        self.model.eval()

    def _build_prompt(self, user_content: str) -> str:
        if self.system_prompt.strip():
            return f"{self.system_prompt.rstrip()}\n\n{user_content}"
        return user_content

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
            t0_iso = _now_iso()
            try:
                prompt = self._build_prompt(user_content)

                inputs = self.tokenizer(prompt, return_tensors="pt")
                # device_map=auto일 때 안전하게 input embedding device로 보냄
                device = self.model.get_input_embeddings().weight.device
                inputs = {k: v.to(device) for k, v in inputs.items()}

                in_tokens = int(inputs["input_ids"].shape[-1])

                with torch.no_grad():
                    gen_ids = self.model.generate(
                        **inputs,
                        max_new_tokens=self.max_new_tokens,
                        do_sample=self.do_sample,
                        temperature=self.temperature if self.do_sample else None,
                        top_p=self.top_p if self.do_sample else None,
                        top_k=self.top_k if self.do_sample else None,
                        eos_token_id=self.tokenizer.eos_token_id,
                        pad_token_id=self.tokenizer.pad_token_id,
                    )

                out_ids = gen_ids[0][in_tokens:]
                output_text = self.tokenizer.decode(out_ids, skip_special_tokens=True).strip()

                t1 = time.perf_counter()
                out_tokens = int(out_ids.shape[-1])

                metrics = {
                    "request_id": None,
                    "model": self.model_id,
                    "start_time": t0_iso,
                    "end_time": _now_iso(),
                    "elapsed_sec": round(t1 - t0, 6),
                    "usage": {
                        "input_tokens": in_tokens,
                        "output_tokens": out_tokens,
                        "total_tokens": in_tokens + out_tokens,
                    },
                    "attempt": attempt + 1,
                    "retries": attempt,
                    "error": None,
                }

                if self.verbose:
                    print(f"✅ HF OK time={metrics['elapsed_sec']}s tokens={in_tokens}/{out_tokens}/{in_tokens+out_tokens}")

                if log_path:
                    _append_json_entry(log_path, {
                        "phase": "gpt_call",
                        **(log_extra or {}),
                        **metrics,
                        "success": True,
                    })

                return True, output_text, metrics

            except Exception as e:
                t1 = time.perf_counter()
                err = str(e)
                metrics = {
                    "request_id": None,
                    "model": self.model_id,
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
                        print(f"⚠️ HF 실패 attempt={attempt+1}/{self.max_retries+1} err={err}\n   {backoff:.1f}s 대기 후 재시도")
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
                        print(f"❌ HF 최종 실패 err={err}")
                    if log_path:
                        _append_json_entry(log_path, {
                            "phase": "gpt_call_final_fail",
                            **(log_extra or {}),
                            **metrics,
                            "success": False,
                        })
                    return False, "", metrics