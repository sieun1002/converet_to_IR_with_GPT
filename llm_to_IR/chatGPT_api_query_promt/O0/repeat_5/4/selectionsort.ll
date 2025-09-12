; ModuleID = 'selection_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  %nm1 = add nsw i32 %n, -1
  br label %outer.cond

outer.cond:                                      ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.outer = icmp slt i32 %i, %nm1
  br i1 %cmp.outer, label %outer.body, label %end

outer.body:                                       ; preds = %outer.cond
  %i.plus1 = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.latch, %outer.body
  %j = phi i32 [ %i.plus1, %outer.body ], [ %j.next, %inner.latch ]
  %min.idx = phi i32 [ %i, %outer.body ], [ %min.idx.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.ext = sext i32 %j to i64
  %min.ext = sext i32 %min.idx to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.idx.next = select i1 %lt, i32 %j, i32 %min.idx
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %min.ext2 = sext i32 %min.idx to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.ext2
  %tmp = load i32, i32* %i.ptr, align 4
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %after.inner
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

end:                                              ; preds = %outer.cond
  ret void
}