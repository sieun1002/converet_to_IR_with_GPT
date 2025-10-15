; ModuleID = 'binary_search_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next.lo, %setlow ], [ %low.next.hi, %sethigh ]
  %high = phi i64 [ %n, %entry ], [ %high.next.lo, %setlow ], [ %high.next.hi, %sethigh ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %exit

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %idxptr, align 4
  %cmpkey = icmp sle i32 %key, %val
  br i1 %cmpkey, label %sethigh, label %setlow

setlow:
  %mid.plus1 = add i64 %mid, 1
  %low.next.lo = %mid.plus1
  %high.next.lo = %high
  br label %loop

sethigh:
  %low.next.hi = %low
  %high.next.hi = %mid
  br label %loop

exit:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %checkeq, label %retfail

checkeq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %retsucc, label %retfail

retsucc:
  ret i64 %low

retfail:
  ret i64 4294967295
}