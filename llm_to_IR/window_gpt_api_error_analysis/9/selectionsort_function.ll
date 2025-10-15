; ModuleID: selection_sort_module
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond: ; preds = %entry, %outer.latch
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body: ; preds = %outer.cond
  %min0 = add i32 %i, 0
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond: ; preds = %outer.body, %inner.body
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.body ]
  %minIdx = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.body ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.body, label %after.inner

inner.body: ; preds = %inner.cond
  %j.ext = sext i32 %j to i64
  %pJ = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %valJ = load i32, i32* %pJ, align 4
  %min.ext = sext i32 %minIdx to i64
  %pMin = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %valMin = load i32, i32* %pMin, align 4
  %isLess = icmp slt i32 %valJ, %valMin
  %min.cand = add i32 %j, 0
  %min.next = select i1 %isLess, i32 %min.cand, i32 %minIdx
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner: ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %pI = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %pI, align 4
  %min.ext2 = sext i32 %minIdx to i64
  %pMin2 = getelementptr inbounds i32, i32* %arr, i64 %min.ext2
  %valAtMin = load i32, i32* %pMin2, align 4
  store i32 %valAtMin, i32* %pI, align 4
  store i32 %tmp, i32* %pMin2, align 4
  br label %outer.latch

outer.latch: ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit: ; preds = %outer.cond
  ret void
}