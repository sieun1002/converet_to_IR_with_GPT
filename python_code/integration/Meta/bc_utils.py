# bc_utils.py
import json
import subprocess
import time
from datetime import datetime
from typing import Dict, Any, Optional

def now_iso() -> str:
    return datetime.now().isoformat(timespec="seconds")

def append_json_entry(path: str, entry: Dict[str, Any]) -> None:
    try:
        with open(path, "r+", encoding="utf-8") as f:
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
        with open(path, "w", encoding="utf-8") as f:
            json.dump({"entries": [entry]}, f, ensure_ascii=False, indent=2)

def assemble_ll_to_bc(
    ll_path: str,
    bc_path: str,
    as_bin: str = "llvm-as-14",
    timeout_sec: int = 60,
) -> Dict[str, Any]:
    cmd = [as_bin, ll_path, "-o", bc_path]
    t0 = time.perf_counter()
    start_iso = now_iso()
    try:
        p = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout_sec,
            check=False,
        )
        dt = time.perf_counter() - t0
        return {
            "success": p.returncode == 0,
            "stdout": (p.stdout or ""),
            "stderr": (p.stderr or ""),
            "returncode": p.returncode,
            "cmd": " ".join(cmd),
            "start_time": start_iso,
            "end_time": now_iso(),
            "elapsed_sec": round(dt, 6),
        }
    except Exception as e:
        dt = time.perf_counter() - t0
        return {
            "success": False,
            "stdout": "",
            "stderr": f"[assemble exception] {e}",
            "returncode": None,
            "cmd": " ".join(cmd),
            "start_time": start_iso,
            "end_time": now_iso(),
            "elapsed_sec": round(dt, 6),
        }
