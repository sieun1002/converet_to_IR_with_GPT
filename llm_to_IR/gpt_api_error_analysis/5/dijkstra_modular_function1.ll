; Function: init_graph
define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.loop

outer.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %outer.cond = icmp slt i32 %i, %n
  br i1 %outer.cond, label %inner.init, label %exit

inner.init:
  br label %inner.loop

inner.loop:
  %j = phi i32 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %inner.cond = icmp slt i32 %j, %n
  br i1 %inner.cond, label %store, label %outer.inc

store:
  %i.ext = sext i32 %i to i64
  %row.mul = mul nsw i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %idx = add nsw i64 %row.mul, %j.ext
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %elem.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.loop

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.loop

exit:
  ret void
}