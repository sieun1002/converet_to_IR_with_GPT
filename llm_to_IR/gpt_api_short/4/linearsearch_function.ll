; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: Linear search for target in int array, return index or -1 (confidence=0.98). Evidence: increments index, compares array element to target, returns index or -1.
; Preconditions: arr points to at least len 32-bit ints; len >= 0.
; Postconditions: returns index in [0, len) if found; otherwise -1.

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %ret_m1

body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add i32 %i, 1
  br label %loop

ret_m1:
  ret i32 -1
}