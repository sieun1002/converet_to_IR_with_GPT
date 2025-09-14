define void @init_graph([100 x i32]* %base, i32 %n) local_unnamed_addr nounwind {
entry:
  br label %outer.cond

outer.cond:                                           ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.init, label %exit

inner.init:                                           ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                           ; preds = %inner.init, %inner.inc
  %j = phi i32 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %body, label %outer.inc

body:                                                 ; preds = %inner.cond
  %i64 = sext i32 %i to i64
  %row = getelementptr inbounds [100 x i32], [100 x i32]* %base, i64 %i64
  %j64 = sext i32 %j to i64
  %elem = getelementptr inbounds [100 x i32], [100 x i32]* %row, i64 0, i64 %j64
  store i32 0, i32* %elem, align 4
  br label %inner.inc

inner.inc:                                            ; preds = %body
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                            ; preds = %inner.cond
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:                                                 ; preds = %outer.cond
  ret void
}