; ModuleID = 'selection_sort_module'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond = icmp slt i32 %i.ph, %n.minus1
  br i1 %outer.cond, label %outer.body, label %exit

outer.body:
  %j.init = add nsw i32 %i.ph, 1
  br label %inner.header

inner.header:
  %minidx.ph = phi i32 [ %i.ph, %outer.body ], [ %min.cand, %inner.body ]
  %j.ph = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body ]
  %j.cmp = icmp slt i32 %j.ph, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j.ph to i64
  %minidx.ext = sext i32 %minidx.ph to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %minidx.ext
  %valj = load i32, i32* %j.ptr, align 4
  %valmin = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %valj, %valmin
  %min.cand = select i1 %lt, i32 %j.ph, i32 %minidx.ph
  %j.next = add nsw i32 %j.ph, 1
  br label %inner.header

after.inner:
  %i.ext = sext i32 %i.ph to i64
  %minidx2.ext = sext i32 %minidx.ph to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %minptr2 = getelementptr inbounds i32, i32* %arr, i64 %minidx2.ext
  %tmp = load i32, i32* %iptr, align 4
  %minval = load i32, i32* %minptr2, align 4
  store i32 %minval, i32* %iptr, align 4
  store i32 %tmp, i32* %minptr2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i.ph, 1
  br label %outer.header

exit:
  ret void
}