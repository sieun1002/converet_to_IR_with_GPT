target triple = "x86_64-pc-linux-gnu"

define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp_i = icmp slt i32 %i, %n
  br i1 %cmp_i, label %inner.init, label %exit

inner.init:                                       ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                       ; preds = %inner.init, %inner.inc
  %j = phi i32 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %cmp_j = icmp slt i32 %j, %n
  br i1 %cmp_j, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %mul = mul nsw i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %idx = add nsw i64 %mul, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %ptr, align 4
  br label %inner.inc

inner.inc:                                        ; preds = %inner.body
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}