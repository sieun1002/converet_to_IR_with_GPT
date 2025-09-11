#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path

def main():
    ap = argparse.ArgumentParser(
        description=(
            "For each .ll file in SRC, save it as <chosen_dir>/mcsema.ll where chosen_dir is:\n"
            "  1) DEST/<stem> if exists\n"
            "  2) else SRC/<stem> if exists\n"
            "  3) else create DEST/<stem>\n"
        )
    )
    ap.add_argument(
        "src",
        nargs="?",
        default="/home/nata20034/workspace/mcsema_to_IR/ll",
        help="Source folder containing .ll files (default: /home/nata20034/workspace/mcsema_to_IR/ll)",
    )
    ap.add_argument(
        "--dest",
        default="/home/nata20034/workspace/test_file",
        help="Destination root (default: /home/nata20034/workspace/test_file)",
    )
    ap.add_argument(
        "--outfile",
        default="llm.ll",
        help="Output file name inside the chosen directory (default: llm.ll)",
    )
    ap.add_argument("--force", action="store_true", help="Overwrite existing output file")
    ap.add_argument("--move", action="store_true", help="Move instead of copy")
    ap.add_argument("-v", "--verbose", action="store_true", help="Verbose output")
    args = ap.parse_args()

    src_root = Path(args.src)
    dest_root = Path(args.dest)

    if not src_root.is_dir():
        print(f"[!] Not a directory: {src_root}")
        raise SystemExit(1)
    dest_root.mkdir(parents=True, exist_ok=True)

    ll_files = [p for p in sorted(src_root.iterdir()) if p.is_file() and p.suffix == ".ll"]
    if not ll_files:
        print(f"[*] No .ll files found in {src_root}")
        return

    written = skipped = overwritten = 0

    for src_file in ll_files:
        stem = src_file.stem
        # 1) prefer existing DEST/<stem>
        dest_same = dest_root / stem
        # 2) else fall back to existing SRC/<stem>
        src_same = src_root / stem

        if dest_same.is_dir():
            chosen_dir = dest_same
        elif src_same.is_dir():
            chosen_dir = src_same
        else:
            chosen_dir = dest_same  # will be created under DEST

        chosen_dir.mkdir(parents=True, exist_ok=True)
        dest_file = chosen_dir / args.outfile

        if dest_file.exists() and not args.force:
            if args.verbose:
                print(f"[-] Exists, skip: {dest_file}")
            skipped += 1
            continue

        if dest_file.exists() and args.force:
            overwritten += 1

        if args.verbose:
            where = "MOVE" if args.move else "COPY"
            print(f"[+] {src_file.name} -> {dest_file} ({where})")

        if args.move:
            shutil.move(str(src_file), str(dest_file))
        else:
            shutil.copy2(src_file, dest_file)

        written += 1

    print(f"Done. written: {written}, skipped: {skipped}, overwritten: {overwritten}")
    print(f"Source: {src_root}")
    print(f"Dest  : {dest_root}")

if __name__ == "__main__":
    main()
