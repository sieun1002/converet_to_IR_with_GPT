; ModuleID = 'init_graph.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @init_graph(i8* %base, i32 %n) {
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp sge i32 %i, %n
  br i1 %cmp.i, label %exit, label %inner.header

inner.header:
  %j = phi i32 [ 0, %outer.header ], [ %j.next, %inner.latch ]
  %cmp.j = icmp sge i32 %j, %n
  br i1 %cmp.j, label %after.inner, label %inner.body

inner.body:
  %i.ext = sext i32 %i to i64
  %row.off = mul nsw i64 %i.ext, 400
  %row.ptr.i8 = getelementptr inbounds i8, i8* %base, i64 %row.off
  %row.ptr.i32 = bitcast i8* %row.ptr.i8 to i32*
  %j.ext = sext i32 %j to i64
  %elem.ptr = getelementptr inbounds i32, i32* %row.ptr.i32, i64 %j.ext
  store i32 0, i32* %elem.ptr, align 4
  br label %inner.latch

inner.latch:
  %j.next = add nsw i32 %j, 1
  br label %inner.header

after.inner:
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.header

exit:
  ret void
}