; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: Binary search (lower_bound then equality) on sorted i32 array; returns index or -1 (confidence=0.97). Evidence: mid=(lo+hi)/2 with 4-byte stride; branch on key <= arr[mid], final equality check.
; Preconditions: arr points to at least n elements; array sorted ascending under signed 32-bit comparison.
; Postconditions: Returns i64 index of key if found, else -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %cont
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %cont ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %cont ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %key, %elt
  br i1 %le, label %set_hi, label %set_lo

set_hi:                                           ; preds = %body
  br label %cont

set_lo:                                           ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  br label %cont

cont:                                             ; preds = %set_lo, %set_hi
  %lo.next = phi i64 [ %lo, %set_hi ], [ %mid.plus1, %set_lo ]
  %hi.next = phi i64 [ %mid, %set_hi ], [ %hi, %set_lo ]
  br label %loop

exit:                                             ; preds = %loop
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check, label %ret_neg1

check:                                            ; preds = %exit
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %v2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %v2
  br i1 %eq, label %ret_idx, label %ret_neg1

ret_idx:                                          ; preds = %check
  ret i64 %lo

ret_neg1:                                         ; preds = %check, %exit
  ret i64 -1
}