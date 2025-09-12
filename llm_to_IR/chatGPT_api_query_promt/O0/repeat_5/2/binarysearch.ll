; ModuleID = 'binary_search.ll'

define i64 @binary_search(i32* %arr, i64 %n, i32 %target) {
entry:
  br label %while.header

while.header:
  %low = phi i64 [ 0, %entry ], [ %low.next, %latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %latch ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %body, label %after

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %target, %val
  br i1 %le, label %set_high, label %set_low

set_low:
  %mid.plus1 = add i64 %mid, 1
  br label %latch

set_high:
  br label %latch

latch:
  %low.next = phi i64 [ %mid.plus1, %set_low ], [ %low, %set_high ]
  %high.next = phi i64 [ %high, %set_low ], [ %mid, %set_high ]
  br label %while.header

after:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.neg1

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %target
  br i1 %eq, label %ret.low, label %ret.neg1

ret.low:
  ret i64 %low

ret.neg1:
  ret i64 -1
}