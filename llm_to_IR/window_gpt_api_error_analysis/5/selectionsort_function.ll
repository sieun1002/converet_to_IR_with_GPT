; ModuleID = 'selection_sort'
source_filename = "selection_sort.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %cmp.init = icmp sgt i32 %n, 1
  br i1 %cmp.init, label %outer.preheader, label %exit

outer.preheader:
  br label %outer

outer:
  %i = phi i32 [ 0, %outer.preheader ], [ %i.next, %after.inner ]
  %n.minus1 = add i32 %n, -1
  %cond = icmp slt i32 %i, %n.minus1
  br i1 %cond, label %inner.preheader, label %exit

inner.preheader:
  %j0 = add i32 %i, 1
  br label %inner

inner:
  %min.phi = phi i32 [ %i, %inner.preheader ], [ %min.next, %inner.body ]
  %j.phi = phi i32 [ %j0, %inner.preheader ], [ %j.next, %inner.body ]
  %j.cond = icmp slt i32 %j.phi, %n
  br i1 %j.cond, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j.phi to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val.j = load i32, i32* %j.ptr, align 4
  %min64 = sext i32 %min.phi to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %val.min = load i32, i32* %min.ptr, align 4
  %cmp = icmp slt i32 %val.j, %val.min
  %min.next = select i1 %cmp, i32 %j.phi, i32 %min.phi
  %j.next = add i32 %j.phi, 1
  br label %inner

after.inner:
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.fin64 = sext i32 %min.phi to i64
  %min.finptr = getelementptr inbounds i32, i32* %arr, i64 %min.fin64
  %val.min2 = load i32, i32* %min.finptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.finptr, align 4
  %i.next = add i32 %i, 1
  br label %outer

exit:
  ret void
}