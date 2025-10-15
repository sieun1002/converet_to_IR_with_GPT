; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %cmp_n1 = icmp sgt i32 %n, 1
  br i1 %cmp_n1, label %outer.loop, label %exit

outer.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.swap ]
  %minInit = add i32 %i, 0
  %j0 = add i32 %i, 1
  %j_lt_n = icmp slt i32 %j0, %n
  br i1 %j_lt_n, label %inner.loop, label %do.swap

inner.loop:
  %j = phi i32 [ %j0, %outer.loop ], [ %j.next, %inner.cont ]
  %minIndex = phi i32 [ %minInit, %outer.loop ], [ %min.phi.next, %inner.cont ]
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %valj = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %minIndex to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %valmin = load i32, i32* %min.ptr, align 4
  %cmp = icmp slt i32 %valj, %valmin
  %min.updated = select i1 %cmp, i32 %j, i32 %minIndex
  br label %inner.cont

inner.cont:
  %min.phi.next = phi i32 [ %min.updated, %inner.loop ]
  %j.next = add i32 %j, 1
  %j.cond = icmp slt i32 %j.next, %n
  br i1 %j.cond, label %inner.loop, label %do.swap

do.swap:
  %minForSwap = phi i32 [ %minInit, %outer.loop ], [ %min.phi.next, %inner.cont ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %ai = load i32, i32* %i.ptr, align 4
  %minForSwap.ext = sext i32 %minForSwap to i64
  %minSwap.ptr = getelementptr inbounds i32, i32* %arr, i64 %minForSwap.ext
  %amin = load i32, i32* %minSwap.ptr, align 4
  store i32 %amin, i32* %i.ptr, align 4
  store i32 %ai, i32* %minSwap.ptr, align 4
  br label %after.swap

after.swap:
  %i.next = add i32 %i, 1
  %nminus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i.next, %nminus1
  br i1 %cond.outer, label %outer.loop, label %exit

exit:
  ret void
}