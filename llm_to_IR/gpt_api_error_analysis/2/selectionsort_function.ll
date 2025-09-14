; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                      ; preds = %outer.latch, %entry
  %i.cur = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.cur, %n.minus1
  br i1 %cmp.outer, label %prep.inner, label %exit

prep.inner:                                        ; preds = %outer.header
  %j.init = add nsw i32 %i.cur, 1
  br label %inner.header

inner.header:                                      ; preds = %inner.latch, %prep.inner
  %min.cur = phi i32 [ %i.cur, %prep.inner ], [ %min.next, %inner.latch ]
  %j.cur = phi i32 [ %j.init, %prep.inner ], [ %j.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j.cur, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                        ; preds = %inner.header
  %j.ext = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %lt, i32 %j.cur, i32 %min.cur
  br label %inner.latch

inner.latch:                                       ; preds = %inner.body
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add nsw i32 %j.cur, 1
  br label %inner.header

after.inner:                                       ; preds = %inner.header
  %i.ext = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.exit.ext = sext i32 %min.cur to i64
  %min.exit.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.exit.ext
  %min.load = load i32, i32* %min.exit.ptr, align 4
  store i32 %min.load, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.exit.ptr, align 4
  br label %outer.latch

outer.latch:                                       ; preds = %after.inner
  %i.next = add nsw i32 %i.cur, 1
  br label %outer.header

exit:                                              ; preds = %outer.header
  ret void
}