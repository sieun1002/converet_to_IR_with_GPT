; ModuleID = 'init_graph.ll'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @init_graph([100 x i32]* nocapture %graph, i32 %n) nounwind {
entry:
  br label %outer.loop

outer.loop:                                       ; i loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.loop.preheader, label %exit

inner.loop.preheader:
  br label %inner.loop

inner.loop:                                       ; j loop
  %j = phi i32 [ 0, %inner.loop.preheader ], [ %j.next, %inner.latch ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.body, label %inner.end

inner.body:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %i64, i64 %j64
  store i32 0, i32* %eltptr, align 4
  br label %inner.latch

inner.latch:
  %j.next = add nsw i32 %j, 1
  br label %inner.loop

inner.end:
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.loop

exit:
  ret void
}