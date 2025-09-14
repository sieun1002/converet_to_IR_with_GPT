; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search for a 32-bit key in a sorted int32 array, return index or -1 (confidence=0.95). Evidence: mid=(hi-lo)>>1 loop; post-loop equality check returning -1 if not found
; Preconditions: arr points to at least n elements; elements are sorted in non-decreasing signed 32-bit order
; Postconditions: returns index in [0, n) where arr[index] == key, else -1

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %step
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %step ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %step ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %midcalc, label %exit

midcalc:                                          ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr = getelementptr i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %take_hi, label %take_lo

take_hi:                                          ; preds = %midcalc
  %hi.next = %mid
  %lo.stay = %lo
  br label %step

take_lo:                                          ; preds = %midcalc
  %mid.plus1 = add i64 %mid, 1
  %lo.next.lo = %mid.plus1
  %hi.stay = %hi
  br label %step

step:                                             ; preds = %take_lo, %take_hi
  %lo.next = phi i64 [ %lo.stay, %take_hi ], [ %lo.next.lo, %take_lo ]
  %hi.next = phi i64 [ %hi.next, %take_hi ], [ %hi.stay, %take_lo ]
  br label %loop

exit:                                             ; preds = %loop
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %checkeq, label %ret_neg1

checkeq:                                          ; preds = %exit
  %elt.ptr = getelementptr i32, i32* %arr, i64 %lo
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %key, %elt
  br i1 %eq, label %ret_lo, label %ret_neg1

ret_lo:                                           ; preds = %checkeq
  ret i64 %lo

ret_neg1:                                         ; preds = %checkeq, %exit
  ret i64 -1
}