; ModuleID = 'selection_sort'
source_filename = "selection_sort.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer

outer:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer_latch ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %inner.init, label %exit

inner.init:
  %i.plus1 = add nsw i32 %i, 1
  br label %inner.header

inner.header:
  %j = phi i32 [ %i.plus1, %inner.init ], [ %j.next, %inner.body ]
  %minidx = phi i32 [ %i, %inner.init ], [ %minidx.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %j.val = load i32, i32* %j.ptr, align 4
  %min64 = sext i32 %minidx to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %min.val = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %j.val, %min.val
  %minidx.next = select i1 %isless, i32 %j, i32 %minidx
  %j.next = add nsw i32 %j, 1
  br label %inner.header

after.inner:
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %minfinal64 = sext i32 %minidx to i64
  %minfinal.ptr = getelementptr inbounds i32, i32* %arr, i64 %minfinal64
  %tmp = load i32, i32* %i.ptr, align 4
  %minload = load i32, i32* %minfinal.ptr, align 4
  store i32 %minload, i32* %i.ptr, align 4
  store i32 %tmp, i32* %minfinal.ptr, align 4
  br label %outer_latch

outer_latch:
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:
  ret void
}