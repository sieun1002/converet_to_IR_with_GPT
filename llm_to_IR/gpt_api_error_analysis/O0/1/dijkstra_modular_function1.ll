target triple = "x86_64-pc-linux-gnu"

define void @init_graph([100 x i32]* %matrix, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.preheader, label %exit

inner.preheader:
  br label %inner.cond

inner.cond:
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:
  %i.ext = sext i32 %i to i64
  %j.ext = sext i32 %j to i64
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %matrix, i64 %i.ext, i64 %j.ext
  store i32 0, i32* %eltptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}