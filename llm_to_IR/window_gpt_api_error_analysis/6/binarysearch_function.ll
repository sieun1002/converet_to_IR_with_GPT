; ModuleID = 'binary_search_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %low.phi = phi i64 [ 0, %entry ], [ %low.next, %loop.body.merge ]
  %high.phi = phi i64 [ %n, %entry ], [ %high.next, %loop.body.merge ]
  %cmp.lohi = icmp ult i64 %low.phi, %high.phi
  br i1 %cmp.lohi, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high.phi, %low.phi
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.phi, %half
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %idxptr, align 4
  %cmp_le = icmp sle i32 %key, %val
  br i1 %cmp_le, label %set_high, label %set_low

set_high:
  br label %loop.body.merge

set_low:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.body.merge

loop.body.merge:
  %low.next = phi i64 [ %low.phi, %set_high ], [ %mid.plus1, %set_low ]
  %high.next = phi i64 [ %mid, %set_high ], [ %high.phi, %set_low ]
  br label %loop.header

after.loop:
  %cmp_bound = icmp ult i64 %low.phi, %n
  br i1 %cmp_bound, label %check_val, label %ret_m1

check_val:
  %idxptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.phi
  %val2 = load i32, i32* %idxptr2, align 4
  %cmp_eq = icmp eq i32 %val2, %key
  br i1 %cmp_eq, label %ret_index, label %ret_m1

ret_index:
  ret i64 %low.phi

ret_m1:
  ret i64 -1
}