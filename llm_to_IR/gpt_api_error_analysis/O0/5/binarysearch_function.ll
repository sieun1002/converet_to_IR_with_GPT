; ModuleID = 'binary_search.ll'
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next, %update ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %update ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %after

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %set_high, label %set_low

set_high:
  br label %update

set_low:
  %mid.plus = add i64 %mid, 1
  br label %update

update:
  %low.next = phi i64 [ %low, %set_high ], [ %mid.plus, %set_low ]
  %high.next = phi i64 [ %mid, %set_high ], [ %high, %set_low ]
  br label %loop

after:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check_eq, label %ret_neg

check_eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_idx, label %ret_neg

ret_idx:
  ret i64 %low

ret_neg:
  ret i64 -1
}