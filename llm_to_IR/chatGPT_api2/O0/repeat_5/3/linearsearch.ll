; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search for a 32-bit integer in an array; return index or -1 (confidence=0.98). Evidence: iterate i from 0, compare arr[i] to needle, return i or -1.
; Preconditions: arr points to at least len 32-bit elements.
; Postconditions: Returns the first index i in [0, len) where arr[i] == needle, or -1 if not found.

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %needle) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body_end, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body_end ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %ret_not_found

body:                                             ; preds = %cond
  %idx64 = sext i32 %i to i64
  %eltptr = getelementptr i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %eltptr
  %eq = icmp eq i32 %val, %needle
  br i1 %eq, label %found, label %body_end

body_end:                                         ; preds = %body
  %inc = add i32 %i, 1
  br label %cond

found:                                            ; preds = %body
  ret i32 %i

ret_not_found:                                    ; preds = %cond
  ret i32 -1
}