; ModuleID = 'binary_search'
source_filename = "binary_search"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:
  %low.ph = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high.ph = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low.ph, %high.ph
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %sub = sub i64 %high.ph, %low.ph
  %shr = lshr i64 %sub, 1
  %mid = add i64 %low.ph, %shr
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %set.high, label %set.low

set.high:
  br label %loop.latch

set.low:
  %midp1 = add i64 %mid, 1
  br label %loop.latch

loop.latch:
  %low.next = phi i64 [ %low.ph, %set.high ], [ %midp1, %set.low ]
  %high.next = phi i64 [ %mid, %set.high ], [ %high.ph, %set.low ]
  br label %loop.cond

after.loop:
  %ge = icmp uge i64 %low.ph, %n
  br i1 %ge, label %ret.neg1, label %check.eq

check.eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.ph
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:
  ret i64 %low.ph

ret.neg1:
  ret i64 -1
}