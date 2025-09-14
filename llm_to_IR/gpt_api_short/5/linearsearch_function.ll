; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: find index of target in int32 array (confidence=0.92). Evidence: loop compares arr[i] with target; returns i or -1.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: returns index of first match in [0, n); otherwise -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                         ; preds = %loop.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit.notfound

loop.body:                                         ; preds = %loop.cond
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %loop.inc

loop.inc:                                          ; preds = %loop.body
  %inc = add i32 %i, 1
  br label %loop.cond

found:                                             ; preds = %loop.body
  ret i32 %i

exit.notfound:                                     ; preds = %loop.cond
  ret i32 -1
}