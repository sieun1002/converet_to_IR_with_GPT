; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: Binary search (lower_bound) on sorted int32 array; return index or -1 (confidence=0.98). Evidence: loop mid=(lo+hi)/2 with jle to move hi=mid else lo=mid+1; final check lo<n and arr[lo]==key.
; Preconditions: Array is sorted in nondecreasing order; n fits in 64-bit; base has at least n elements.
; Postconditions: Returns 0-based index of key if present; otherwise returns -1.

; Only the necessary external declarations:

define dso_local i64 @binary_search(i32* nocapture readonly %base, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %while

while:                                            ; preds = %loop_latch, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %loop_latch ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %loop_latch ]
  %cond = icmp ult i64 %lo, %hi
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %while
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %val = load i32, i32* %elem.ptr, align 4
  %go.right = icmp sgt i32 %key, %val
  br i1 %go.right, label %go_right, label %go_left

go_right:                                         ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  br label %loop_latch

go_left:                                          ; preds = %body
  br label %loop_latch

loop_latch:                                       ; preds = %go_left, %go_right
  %lo.next = phi i64 [ %mid.plus1, %go_right ], [ %lo, %go_left ]
  %hi.next = phi i64 [ %hi, %go_right ], [ %mid, %go_left ]
  br label %while

exit:                                             ; preds = %while
  %lo.final = phi i64 [ %lo, %while ]
  %in.bounds = icmp ult i64 %lo.final, %n
  br i1 %in.bounds, label %check_eq, label %ret_neg1

check_eq:                                         ; preds = %exit
  %elem.ptr2 = getelementptr inbounds i32, i32* %base, i64 %lo.final
  %val2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_idx, label %ret_neg1

ret_idx:                                          ; preds = %check_eq
  ret i64 %lo.final

ret_neg1:                                         ; preds = %check_eq, %exit
  ret i64 -1
}