; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: Linear search for target in int array, return index or -1 (confidence=1.00). Evidence: loop over i, compare arr[i] to target, return i else -1.
; Preconditions: arr points to at least n 32-bit integers; n may be non-negative.
; Postconditions: returns index of first occurrence of target in [0, n), else -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %ret_not_found

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret_found, label %cont

cont:                                             ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

ret_found:                                        ; preds = %body
  ret i32 %i

ret_not_found:                                    ; preds = %loop
  ret i32 -1
}