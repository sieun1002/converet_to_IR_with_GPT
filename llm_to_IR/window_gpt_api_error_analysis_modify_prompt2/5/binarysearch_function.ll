; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %low = phi i64 [ 0, %entry ], [ %low.next, %latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %latch ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %loop.body, label %after

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %setHigh, label %setLow

setHigh:
  br label %latch

setLow:
  %midp1 = add i64 %mid, 1
  br label %latch

latch:
  %low.next = phi i64 [ %low, %setHigh ], [ %midp1, %setLow ]
  %high.next = phi i64 [ %mid, %setHigh ], [ %high, %setLow ]
  br label %loop.header

after:
  %chkBound = icmp ult i64 %low, %n
  br i1 %chkBound, label %checkval, label %retfail

checkval:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %retsuccess, label %retfail

retsuccess:
  ret i64 %low

retfail:
  ret i64 4294967295
}