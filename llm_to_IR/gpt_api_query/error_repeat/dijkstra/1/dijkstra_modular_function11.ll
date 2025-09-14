; ModuleID = 'init_graph.ll'
define void @init_graph(i32* %graph, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.cond, label %exit

inner.cond:
  %j = phi i32 [ 0, %outer.cond ], [ %j.next, %body ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %body, label %outer.inc

body:
  %i.ext = sext i32 %i to i64
  %j.ext = sext i32 %j to i64
  %mul = mul nsw i64 %i.ext, 100
  %idx = add nsw i64 %mul, %j.ext
  %ptr = getelementptr i32, i32* %graph, i64 %idx
  store i32 0, i32* %ptr, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}