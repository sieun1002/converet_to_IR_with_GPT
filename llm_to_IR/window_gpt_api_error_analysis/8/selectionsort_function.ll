; ModuleID = 'selection_sort.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @selection_sort(i32* %a, i32 %n) {
entry:
  %cmp.init = icmp sgt i32 %n, 1
  br i1 %cmp.init, label %outer.header, label %exit

outer.header:
  %i.cur = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %i.plus1 = add i32 %i.cur, 1
  br label %inner.check

inner.check:
  %j.cur = phi i32 [ %i.plus1, %outer.header ], [ %j.next, %inner.latch ]
  %min.cur = phi i32 [ %i.cur, %outer.header ], [ %min.next, %inner.latch ]
  %jlt.n = icmp slt i32 %j.cur, %n
  br i1 %jlt.n, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j64
  %vj = load i32, i32* %j.ptr, align 4
  %min64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min64
  %vmin = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %vj, %vmin
  %min.sel = select i1 %isless, i32 %j.cur, i32 %min.cur
  br label %inner.latch

inner.latch:
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add i32 %j.cur, 1
  br label %inner.check

after.inner:
  %i64 = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %ai = load i32, i32* %i.ptr, align 4
  %min.final64 = sext i32 %min.cur to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %a, i64 %min.final64
  %amin = load i32, i32* %min.final.ptr, align 4
  store i32 %amin, i32* %i.ptr, align 4
  store i32 %ai, i32* %min.final.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i.cur, 1
  %n.m1 = add i32 %n, -1
  %cont = icmp slt i32 %i.next, %n.m1
  br i1 %cont, label %outer.header, label %exit

exit:
  ret void
}