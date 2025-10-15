define void @init_graph([100 x i32]* %graph, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp sge i32 %i, %n
  br i1 %cmp.outer, label %exit, label %inner.init

inner.init:
  br label %inner.cond

inner.cond:
  %j = phi i32 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp sge i32 %j, %n
  br i1 %cmp.inner, label %outer.inc_prep, label %store

store:
  %rowptr = getelementptr [100 x i32], [100 x i32]* %graph, i32 %i
  %eltptr = getelementptr [100 x i32], [100 x i32]* %rowptr, i32 0, i32 %j
  store i32 0, i32* %eltptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc_prep:
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}