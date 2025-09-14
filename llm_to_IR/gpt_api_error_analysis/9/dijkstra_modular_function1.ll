; ModuleID = 'init_graph.ll'
target triple = "x86_64-pc-linux-gnu"

define void @init_graph(i32* nocapture %base, i32 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.preheader, label %exit

inner.preheader:
  br label %inner.header

inner.header:
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %inner.latch ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.body, label %outer.latch

inner.body:
  %i.ext = sext i32 %i to i64
  %row.off = mul nsw i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %elem.idx = add nsw i64 %row.off, %j.ext
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %elem.idx
  store i32 0, i32* %elem.ptr, align 4
  br label %inner.latch

inner.latch:
  %j.next = add nsw i32 %j, 1
  br label %inner.header

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.header

exit:
  ret void
}