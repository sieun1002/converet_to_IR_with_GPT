; ModuleID = 'tim_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x401000
; Preconditions: Valid pointer %argc and pointer %argv.
; Postconditions: Returns an integer value.

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; body (SSA-friendly; no unnecessary alloca)
  ret i32 0
}