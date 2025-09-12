; ModuleID = 'binary_search.ll'
source_filename = "binary_search"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %set_high, %set_low, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %set_low ], [ %low, %set_high ]
  %high = phi i64 [ %n, %entry ], [ %high, %set_low ], [ %mid, %set_high ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %set_high, label %set_low

set_low:                                          ; preds = %body
  %low.next = add i64 %mid, 1
  br label %loop

set_high:                                         ; preds = %body
  br label %loop

exit:                                             ; preds = %loop
  %low.end = phi i64 [ %low, %loop ]
  %in.range = icmp ult i64 %low.end, %n
  br i1 %in.range, label %check_eq, label %ret_neg1

check_eq:                                         ; preds = %exit
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.end
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_idx, label %ret_neg1

ret_idx:                                          ; preds = %check_eq
  ret i64 %low.end

ret_neg1:                                         ; preds = %check_eq, %exit
  ret i64 -1
}