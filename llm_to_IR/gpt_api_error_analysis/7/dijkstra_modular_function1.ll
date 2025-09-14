define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp sge i32 %i, %n
  br i1 %cmp.outer, label %exit, label %inner.init

inner.init:                                       ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                       ; preds = %inner.init, %inner.body
  %j = phi i32 [ 0, %inner.init ], [ %j.next, %inner.body ]
  %cmp.inner = icmp sge i32 %j, %n
  br i1 %cmp.inner, label %outer.inc, label %inner.body

inner.body:                                       ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %row.off = mul nsw i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %elem.off = add nsw i64 %row.off, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %elem.off
  store i32 0, i32* %ptr, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}