; ModuleID = 'selection_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                         ; preds = %entry, %outer.inc
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i.ph, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                         ; preds = %outer.cond
  %j.start = add i32 %i.ph, 1
  br label %inner.cond

inner.cond:                                         ; preds = %outer.body, %inner.body
  %j.ph = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.body ]
  %min.ph = phi i32 [ %i.ph, %outer.body ], [ %min.sel, %inner.body ]
  %cmp.jn = icmp slt i32 %j.ph, %n
  br i1 %cmp.jn, label %inner.body, label %after.inner

inner.body:                                         ; preds = %inner.cond
  %j.ext = sext i32 %j.ph to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %valj = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.ph to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %valmin = load i32, i32* %min.ptr, align 4
  %cmp.lt = icmp slt i32 %valj, %valmin
  %min.sel = select i1 %cmp.lt, i32 %j.ph, i32 %min.ph
  %j.next = add i32 %j.ph, 1
  br label %inner.cond

after.inner:                                        ; preds = %inner.cond
  %i.ext = sext i32 %i.ph to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.end.ext = sext i32 %min.ph to i64
  %min.end.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.end.ext
  %min.val = load i32, i32* %min.end.ptr, align 4
  store i32 %min.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.end.ptr, align 4
  br label %outer.inc

outer.inc:                                          ; preds = %after.inner
  %i.next = add i32 %i.ph, 1
  br label %outer.cond

exit:                                               ; preds = %outer.cond
  ret void
}