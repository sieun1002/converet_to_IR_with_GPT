; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search (lower_bound style) on sorted i32 array, return index or -1 (confidence=0.95). Evidence: mid=(lo+hi)/2 loop with key > a[mid] then lo=mid+1 else hi=mid; final equality check.
; Preconditions: arr points to at least n i32 elements; array sorted in non-decreasing order.
; Postconditions: Returns index in [0,n) where arr[index]==key, else -1.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %latch
  %low = phi i64 [ 0, %entry ], [ %low.next, %latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %latch ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp_key_gt = icmp sgt i32 %key, %val
  br i1 %cmp_key_gt, label %then, label %else

then:                                             ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  br label %latch

else:                                             ; preds = %body
  br label %latch

latch:                                            ; preds = %then, %else
  %low.next = phi i64 [ %mid.plus1, %then ], [ %low, %else ]
  %high.next = phi i64 [ %high, %then ], [ %mid, %else ]
  br label %loop

exit:                                             ; preds = %loop
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %checkeq, label %retneg

checkeq:                                          ; preds = %exit
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %retlow, label %retneg

retlow:                                           ; preds = %checkeq
  ret i64 %low

retneg:                                           ; preds = %exit, %checkeq
  ret i64 -1
}