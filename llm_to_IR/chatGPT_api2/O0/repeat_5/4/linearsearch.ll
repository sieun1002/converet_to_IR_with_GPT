; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search for target in int array, return index or -1 (confidence=1.00). Evidence: stride 4 loads over base pointer; returns -1 on miss.
; Preconditions: arr points to at least n 32-bit integers; n >= 0.
; Postconditions: Returns the first index i in [0, n) with arr[i] == target, else -1.

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %ret_not_found

body:
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %target, %elt
  br i1 %eq, label %ret_found, label %cont

cont:
  %inc = add nsw i32 %i, 1
  br label %check

ret_found:
  ret i32 %i

ret_not_found:
  ret i32 -1
}