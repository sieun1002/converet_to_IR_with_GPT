; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search for 32-bit key in sorted ascending int array; return index or -1 (confidence=0.95). Evidence: mid=(low+high)/2 with 4-byte stride; -1 on not found.
; Preconditions: arr has at least n elements sorted in nondecreasing order under signed 32-bit comparison.
; Postconditions: Returns first index i where arr[i] == key, else -1.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %body
  %low = phi i64 [ 0, %entry ], [ %low.next, %body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %mid.ptr, align 4
  %le = icmp sle i32 %key, %val
  %low.plus1 = add i64 %mid, 1
  %low.next = select i1 %le, i64 %low, i64 %low.plus1
  %high.next = select i1 %le, i64 %mid, i64 %high
  br label %loop

exit:                                             ; preds = %loop
  %in.bounds = icmp ult i64 %low, %n
  br i1 %in.bounds, label %check, label %ret.notfound

check:                                            ; preds = %exit
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %idx.ptr, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:                                        ; preds = %check
  ret i64 %low

ret.notfound:                                     ; preds = %check, %exit
  ret i64 -1
}