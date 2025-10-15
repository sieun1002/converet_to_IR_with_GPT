; ModuleID = 'selection_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nMinusOne = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %i, %nMinusOne
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:
  %i.plus1 = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %i.plus1, %outer.body ], [ %j.next, %inner.body_end ]
  %minCur = phi i32 [ %i, %outer.body ], [ %min.next, %inner.body_end ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %v.j = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %minCur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %v.min = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %v.j, %v.min
  %min.updated = select i1 %is.less, i32 %j, i32 %minCur
  br label %inner.body_end

inner.body_end:
  %min.next = phi i32 [ %min.updated, %inner.body ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

after.inner:
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %minFinal.ext = sext i32 %minCur to i64
  %minFinal.ptr = getelementptr inbounds i32, i32* %arr, i64 %minFinal.ext
  %min.val = load i32, i32* %minFinal.ptr, align 4
  store i32 %min.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %minFinal.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}