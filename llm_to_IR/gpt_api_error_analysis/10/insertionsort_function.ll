target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.outer = icmp ult i64 %i, %n
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %a.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %a.i.ptr, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.gt0 = icmp ugt i64 %j, 0
  br i1 %j.gt0, label %inner.cmp, label %inner.end

inner.cmp:
  %jm1 = add i64 %j, -1
  %a.jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a.jm1 = load i32, i32* %a.jm1.ptr, align 4
  %keylt = icmp slt i32 %key, %a.jm1
  br i1 %keylt, label %inner.shift, label %inner.end

inner.shift:
  %a.j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a.jm1, i32* %a.j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.end:
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}