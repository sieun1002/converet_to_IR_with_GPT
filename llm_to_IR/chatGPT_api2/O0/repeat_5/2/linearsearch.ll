; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search over int32 array, return index or -1 (confidence=0.98). Evidence: loop over i32 elements with 4-byte stride; returns index on match, else -1.
; Preconditions: %arr points to at least %n 32-bit elements; %n may be negative (then returns -1).
; Postconditions: Returns index of first match in [0, %n) if any; otherwise returns -1.

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %cont
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %ret_not_found

body:                                             ; preds = %loop
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i32 %i
  %val = load i32, i32* %elem_ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret_found, label %cont

cont:                                             ; preds = %body
  %inc = add nsw i32 %i, 1
  br label %loop

ret_found:                                        ; preds = %body
  ret i32 %i

ret_not_found:                                    ; preds = %loop
  ret i32 -1
}