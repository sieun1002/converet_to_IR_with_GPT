; ModuleID = 'selection_sort.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @selection_sort(i32* nocapture noundef %arr, i32 noundef %n) local_unnamed_addr {
entry:
  %cmp0 = icmp sle i32 %n, 1
  br i1 %cmp0, label %ret, label %outer.init

outer.init:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %outer.init ], [ %i.next, %outer.latch ]
  %i64 = sext i32 %i to i64
  %base.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val.i = load i32, i32* %base.ptr, align 4
  %i.plus1 = add i32 %i, 1
  br label %inner.header

inner.header:
  %j = phi i32 [ %i.plus1, %outer.header ], [ %j.next, %inner.latch ]
  %min.idx = phi i32 [ %i, %outer.header ], [ %min.idx.next, %inner.latch ]
  %min.val = phi i32 [ %val.i, %outer.header ], [ %min.val.next, %inner.latch ]
  %cmpj = icmp eq i32 %j, %n
  br i1 %cmpj, label %swap, label %inner.body

inner.body:
  %j64 = sext i32 %j to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %elt = load i32, i32* %elt.ptr, align 4
  %isless = icmp slt i32 %elt, %min.val
  %min.idx.sel = select i1 %isless, i32 %j, i32 %min.idx
  %min.val.sel = select i1 %isless, i32 %elt, i32 %min.val
  br label %inner.latch

inner.latch:
  %min.idx.next = phi i32 [ %min.idx.sel, %inner.body ]
  %min.val.next = phi i32 [ %min.val.sel, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.header

swap:
  store i32 %min.val, i32* %base.ptr, align 4
  %minidx64 = sext i32 %min.idx to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %minidx64
  store i32 %val.i, i32* %min.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  %cont = icmp slt i32 %i.next, %n
  br i1 %cont, label %outer.header, label %ret

ret:
  ret void
}