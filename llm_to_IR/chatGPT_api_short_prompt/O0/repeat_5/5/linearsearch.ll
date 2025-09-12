; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: search for target in int32 array, return index or -1 (confidence=0.98). Evidence: rdi base + 4*index loads i32; compares to edx target and returns index or -1.
; Preconditions: arr points to at least n int32 elements if n > 0.
; Postconditions: returns the first index i in [0, n) with arr[i] == target; otherwise returns -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:                                        ; preds = %entry, %loop.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %notfound

loop.body:                                         ; preds = %loop.check
  %idx64 = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %elt = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %elt, %target
  br i1 %eq, label %found, label %loop.inc

loop.inc:                                          ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.check

found:                                             ; preds = %loop.body
  ret i32 %i

notfound:                                          ; preds = %loop.check
  ret i32 -1
}