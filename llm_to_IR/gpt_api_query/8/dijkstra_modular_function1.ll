; ModuleID = 'init_graph'
source_filename = "init_graph.c"

define void @init_graph([100 x i32]* %graph, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; i-loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:
  br label %inner.body

inner.body:                                       ; j-loop
  %j = phi i32 [ 0, %inner.cond ], [ %j.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %store, label %outer.inc

store:
  %i.ext = sext i32 %i to i64
  %j.ext = sext i32 %j to i64
  %elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %i.ext, i64 %j.ext
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner.body

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}