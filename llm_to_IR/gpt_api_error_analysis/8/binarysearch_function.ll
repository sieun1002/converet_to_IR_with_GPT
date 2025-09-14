; ModuleID = 'binary_search'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %l = phi i64 [ 0, %entry ], [ %l.next, %set_l ], [ %l, %set_r ]
  %r = phi i64 [ %n, %entry ], [ %r, %set_l ], [ %mid, %set_r ]
  %cond = icmp ult i64 %l, %r
  br i1 %cond, label %body, label %exit

body:
  %sub = sub i64 %r, %l
  %shr = lshr i64 %sub, 1
  %mid = add i64 %l, %shr
  %gep = getelementptr inbounds i32, i32* %arr, i64 %mid
  %load = load i32, i32* %gep, align 4
  %cmp = icmp sle i32 %key, %load
  br i1 %cmp, label %set_r, label %set_l

set_l:
  %l.next = add i64 %mid, 1
  br label %loop

set_r:
  br label %loop

exit:
  %chk = icmp ult i64 %l, %n
  br i1 %chk, label %check, label %ret_neg

check:
  %gep2 = getelementptr inbounds i32, i32* %arr, i64 %l
  %load2 = load i32, i32* %gep2, align 4
  %eq = icmp eq i32 %key, %load2
  br i1 %eq, label %ret_idx, label %ret_neg

ret_idx:
  ret i64 %l

ret_neg:
  ret i64 -1
}