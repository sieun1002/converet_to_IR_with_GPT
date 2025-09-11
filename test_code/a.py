#!/usr/bin/env python3
import argparse
import os
import shlex
import subprocess
from pathlib import Path
from typing import List, Tuple

EXCLUDES = {".git", "build", "out", "dist", "node_modules", "__pycache__", "venv"}

def is_excluded(p: Path) -> bool:
    return any(part in EXCLUDES for part in p.parts)

def find_c_files(root: Path):
    for p in root.rglob("*.c"):
        if is_excluded(p):
            continue
        yield p

def run(cmd: List[str]) -> Tuple[bool, str]:
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return proc.returncode == 0, (proc.stdout + proc.stderr)

def main():
    ap = argparse.ArgumentParser(
        description="Recursively compile .c files to LLVM .bc and .ll"
    )
    ap.add_argument(
        "root",
        nargs="?",
        default="/home/nata20034/workspace/file/src",
        help="Root directory (default: /home/nata20034/workspace/file/src)",
    )
    ap.add_argument(
        "--out-root",
        default=None,
        help="Output root (default: <root>/build-llvm/{bc,ll})",
    )
    ap.add_argument("--clang", default="clang", help="clang path (default: clang)")
    ap.add_argument(
        "--opt", default="2", choices=["0","1","2","3","s","z"],
        help="Optimization level (default: 2 => -O2)",
    )
    ap.add_argument("--std", default="gnu11", help="C standard (default: gnu11)")
    ap.add_argument(
        "--cflags", default="",
        help='Extra CFLAGS, e.g. "-Iinclude -DMYDEF=1"',
    )
    ap.add_argument(
        "--inplace", action="store_true",
        help="Write .bc/.ll next to source (default: off)",
    )
    ap.add_argument(
        "-v","--verbose", action="store_true",
        help="Verbose: print commands"
    )
    args = ap.parse_args()

    root = Path(args.root).resolve()
    if not root.exists():
        print(f"[!] Root not found: {root}")
        raise SystemExit(1)

    extra_flags = shlex.split(args.cflags) if args.cflags else []
    # common compile flags
    common = [f"-O{args.opt}", f"-std={args.std}", "-fno-color-diagnostics"]

    # Decide output layout
    if args.inplace:
        out_bc_root = None
        out_ll_root = None
    else:
        out_base = Path(args.out_root) if args.out_root else (root / "build-llvm")
        out_bc_root = out_base / "bc"
        out_ll_root = out_base / "ll"
        out_bc_root.mkdir(parents=True, exist_ok=True)
        out_ll_root.mkdir(parents=True, exist_ok=True)

    c_files = list(find_c_files(root))
    if not c_files:
        print(f"[*] No .c files under {root}")
        return

    print(f"[*] Root: {root}")
    if args.inplace:
        print("[*] Mode: inplace (outputs sit next to sources)")
    else:
        print(f"[*] Output (bc): {out_bc_root}")
        print(f"[*] Output (ll): {out_ll_root}")
    print(f"[*] Compiler: {args.clang}")
    print(f"[*] Flags: {' '.join(common)} {' '.join(extra_flags)}".strip())
    print(f"[*] Found {len(c_files)} C files")

    ok_units, fail_items = 0, []

    for src in c_files:
        rel = src.relative_to(root)
        if args.inplace:
            bc_out = src.with_suffix(".bc")
            ll_out = src.with_suffix(".ll")
        else:
            bc_out = (out_bc_root / rel).with_suffix(".bc")
            ll_out = (out_ll_root / rel).with_suffix(".ll")
            bc_out.parent.mkdir(parents=True, exist_ok=True)
            ll_out.parent.mkdir(parents=True, exist_ok=True)

        # Commands
        cmd_bc = [args.clang] + common + extra_flags + ["-emit-llvm", "-c", str(src), "-o", str(bc_out)]
        cmd_ll = [args.clang] + common + extra_flags + ["-emit-llvm", "-S", str(src), "-o", str(ll_out)]

        print(f"[+] {rel} ->")
        print(f"    .bc: {bc_out}")
        print(f"    .ll: {ll_out}")

        if args.verbose:
            print("    CMD.bc:", " ".join(shlex.quote(x) for x in cmd_bc))
        ok1, log1 = run(cmd_bc)
        if not ok1 or not bc_out.exists():
            fail_items.append((src, "bc", log1))
            print("    [-] .bc failed")
            continue

        if args.verbose:
            print("    CMD.ll:", " ".join(shlex.quote(x) for x in cmd_ll))
        ok2, log2 = run(cmd_ll)
        if not ok2 or not ll_out.exists():
            fail_items.append((src, "ll", log2))
            print("    [-] .ll failed")
            continue

        ok_units += 1

    print("\n=== Summary ===")
    print(f"OK: {ok_units} / {len(c_files)}")
    if fail_items:
        print(f"Failures: {len(fail_items)}")
        for src, kind, log in fail_items:
            print(f"  - {src} ({kind})")
            snippet = log.strip().splitlines()[-30:]
            for line in snippet:
                print("    " + line)

    # Non-zero exit if any failed
    raise SystemExit(0 if not fail_items else 1)

if __name__ == "__main__":
    main()
