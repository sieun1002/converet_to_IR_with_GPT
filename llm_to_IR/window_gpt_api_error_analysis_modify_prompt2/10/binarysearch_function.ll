; ModuleID = 'binary_search_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.head

loop.head:
  %low = phi i64 [ 0, %entry ], [ %low.next, %update ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %update ]
  %cmp.loop = icmp ult i64 %low, %high
  br i1 %cmp.loop, label %loop.body, label %after

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp.le = icmp sle i32 %key, %val
  br i1 %cmp.le, label %sethigh, label %setlow

setlow:
  %mid.plus = add i64 %mid, 1
  br label %update

sethigh:
  br label %update

update:
  %low.next = phi i64 [ %low, %sethigh ], [ %mid.plus, %setlow ]
  %high.next = phi i64 [ %mid, %sethigh ], [ %high, %setlow ]
  br label %loop.head

after:
  %cmp.n = icmp uge i64 %low, %n
  br i1 %cmp.n, label %ret_minus1, label %check

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %neq = icmp ne i32 %key, %val2
  br i1 %neq, label %ret_minus1, label %ret_index

ret_index:
  ret i64 %low

ret_minus1:
  ret i64 4294967295
}