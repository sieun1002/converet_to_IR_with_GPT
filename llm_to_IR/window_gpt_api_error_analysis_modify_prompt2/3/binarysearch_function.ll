; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %len, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %low = phi i64 [ 0, %entry ], [ %low.next, %set.low ], [ %low, %set.high ]
  %high = phi i64 [ %len, %entry ], [ %high, %set.low ], [ %mid, %set.high ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %set.high, label %set.low

set.low:
  %low.next = add i64 %mid, 1
  br label %loop.header

set.high:
  br label %loop.header

after.loop:
  %lt_len = icmp ult i64 %low, %len
  br i1 %lt_len, label %check, label %ret.neg

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %neq = icmp ne i32 %key, %val2
  br i1 %neq, label %ret.neg, label %ret.idx

ret.idx:
  ret i64 %low

ret.neg:
  ret i64 4294967295
}