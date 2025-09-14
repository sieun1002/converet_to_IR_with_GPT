; LLVM 14 IR for: void selection_sort(int* arr, int n)

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %limit = add i32 %n, -1
  br label %outer.cond

outer.cond:                                           ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.outer = icmp slt i32 %i, %limit
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                           ; preds = %outer.cond
  %min0 = %i
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                           ; preds = %inner.latch, %outer.body
  %min.cur = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.latch ]
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                           ; preds = %inner.cond
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %islt = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %islt, i32 %j, i32 %min.cur
  br label %inner.latch

inner.latch:                                          ; preds = %inner.body
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                          ; preds = %inner.cond
  %min.final = phi i32 [ %min.cur, %inner.cond ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %minf.ext = sext i32 %min.final to i64
  %minf.ptr = getelementptr inbounds i32, i32* %arr, i64 %minf.ext
  %min.val2 = load i32, i32* %minf.ptr, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %minf.ptr, align 4
  br label %outer.latch

outer.latch:                                          ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                                 ; preds = %outer.cond
  ret void
}