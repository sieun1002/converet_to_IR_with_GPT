; ModuleID = 'awaiting-user-input'
source_filename = "awaiting-user-input.ll"
target triple = "x86_64-pc-windows-msvc"

; This module is intentionally minimal and compilable.
; To produce a fully corrected IR, please provide:
; - The full LLVM IR module text you’re trying to compile (the original file contents).
; - The exact error messages from llc/opt/llvm-link/clang (whichever fails), with the command used.
; - Target triple and datalayout if present; if missing, confirm it’s x86_64-pc-windows-msvc and LLVM 14.
; - Any external functions/globals you expect (e.g., printf/scanf, __security_cookie) and whether /GS- was used.
;
; From your log, llvm-as failed with:
; llvm-as-14: ...heapsort_resource_function431.ll:1:1: error: expected top-level entity
; This typically occurs when non-IR text (e.g., “Please provide:”) was inserted at the top of the IR file.