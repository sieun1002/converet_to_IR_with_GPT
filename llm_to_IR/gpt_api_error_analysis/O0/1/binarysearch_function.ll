; ModuleID = 'binary_search.ll'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmpk = icmp sle i32 %key, %val
  br i1 %cmpk, label %set.high, label %set.low

set.low:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.latch

set.high:
  br label %loop.latch

loop.latch:
  %low.next = phi i64 [ %mid.plus1, %set.low ], [ %low, %set.high ]
  %high.next = phi i64 [ %high, %set.low ], [ %mid, %set.high ]
  br label %loop.header

after.loop:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check.value, label %notfound

check.value:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low

notfound:
  ret i64 -1
}