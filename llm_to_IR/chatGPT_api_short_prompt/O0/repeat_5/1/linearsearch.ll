; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: find index of key in int array via linear scan (confidence=0.98). Evidence: loop over 4-byte elements; compare to key; return index or 0xFFFFFFFF
; Preconditions: arr points to at least n 32-bit elements
; Postconditions: returns index of first match; returns -1 if not found

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 -1
}