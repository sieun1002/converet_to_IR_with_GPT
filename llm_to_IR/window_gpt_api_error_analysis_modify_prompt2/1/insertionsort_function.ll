target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.outer = icmp ult i64 %i, %n
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %idx.key = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.key, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %shift ]
  %j.zero = icmp eq i64 %j, 0
  br i1 %j.zero, label %inner.exit, label %inner.cmp

inner.cmp:
  %j.prev = add i64 %j, -1
  %idx.prev = getelementptr inbounds i32, i32* %arr, i64 %j.prev
  %prevval = load i32, i32* %idx.prev, align 4
  %cmp.inner = icmp slt i32 %key, %prevval
  br i1 %cmp.inner, label %shift, label %inner.exit

shift:
  %idx.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prevval, i32* %idx.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.fin = phi i64 [ %j, %inner.cond ], [ %j, %inner.cmp ]
  %idx.dest = getelementptr inbounds i32, i32* %arr, i64 %j.fin
  store i32 %key, i32* %idx.dest, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}