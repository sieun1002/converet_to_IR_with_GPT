target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %condLE = icmp sle i32 %key, %elem
  %mid.plus1 = add i64 %mid, 1
  %low.sel = select i1 %condLE, i64 %low, i64 %mid.plus1
  %high.sel = select i1 %condLE, i64 %mid, i64 %high
  br label %loop.latch

loop.latch:
  %low.next = phi i64 [ %low.sel, %loop.body ]
  %high.next = phi i64 [ %high.sel, %loop.body ]
  br label %loop.cond

after.loop:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.notfound

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:
  ret i64 %low

ret.notfound:
  ret i64 -1
}