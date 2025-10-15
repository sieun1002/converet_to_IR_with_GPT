; ModuleID = 'binary_search_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define i32 @binary_search(i32* %arr, i64 %n, i32 %key) {
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
  %cmpkey = icmp sle i32 %key, %elem
  br i1 %cmpkey, label %then, label %else

then:
  br label %loop.latch

else:
  %midp1 = add i64 %mid, 1
  br label %loop.latch

loop.latch:
  %low.next = phi i64 [ %low, %then ], [ %midp1, %else ]
  %high.next = phi i64 [ %mid, %then ], [ %high, %else ]
  br label %loop.cond

after.loop:
  %lt_n = icmp ult i64 %low, %n
  br i1 %lt_n, label %check.eq, label %ret.neg

check.eq:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %ret.index, label %ret.neg

ret.index:
  %idx32 = trunc i64 %low to i32
  ret i32 %idx32

ret.neg:
  ret i32 -1
}