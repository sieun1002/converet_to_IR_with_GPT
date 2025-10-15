target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %nminus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %outer.body, %inner.body
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body ]
  %min = phi i32 [ %i, %outer.body ], [ %min.sel, %inner.body ]
  %cmp.jn = icmp slt i32 %j, %n
  br i1 %cmp.jn, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j64 = sext i32 %j to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptr.j, align 4
  %min64 = sext i32 %min to i64
  %ptr.min.cur = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptr.min.cur, align 4
  %cmp.min = icmp slt i32 %valj, %valmin
  %min.sel = select i1 %cmp.min, i32 %j, i32 %min
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i64 = sext i32 %i to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %ptr.i, align 4
  %min64.swap = sext i32 %min to i64
  %ptr.min.swap = getelementptr inbounds i32, i32* %arr, i64 %min64.swap
  %valAtMin = load i32, i32* %ptr.min.swap, align 4
  store i32 %valAtMin, i32* %ptr.i, align 4
  store i32 %tmp, i32* %ptr.min.swap, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}