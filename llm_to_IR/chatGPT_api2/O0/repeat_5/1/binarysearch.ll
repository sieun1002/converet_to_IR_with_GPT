; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: binary search in ascending i32 array; return index or -1 (confidence=0.95). Evidence: lo/hi/mid loop with key<=arr[mid] -> hi=mid, else lo=mid+1; final equality check.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo_next, %cont ]
  %hi = phi i64 [ %n, %entry ], [ %hi_next, %cont ]
  %cond = icmp ult i64 %lo, %hi
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %elem.ptr, align 4
  %cmp_gt = icmp sgt i32 %key, %val
  br i1 %cmp_gt, label %set_lo, label %set_hi

set_lo:                                           ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  br label %cont

set_hi:                                           ; preds = %body
  br label %cont

cont:                                             ; preds = %set_hi, %set_lo
  %lo_next = phi i64 [ %mid.plus1, %set_lo ], [ %lo, %set_hi ]
  %hi_next = phi i64 [ %hi, %set_lo ], [ %mid, %set_hi ]
  br label %loop

after:                                            ; preds = %loop
  %in_range = icmp ult i64 %lo, %n
  br i1 %in_range, label %check_equal, label %ret_not_found

check_equal:                                      ; preds = %after
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_found, label %ret_not_found

ret_found:                                        ; preds = %check_equal
  ret i64 %lo

ret_not_found:                                    ; preds = %check_equal, %after
  ret i64 -1
}