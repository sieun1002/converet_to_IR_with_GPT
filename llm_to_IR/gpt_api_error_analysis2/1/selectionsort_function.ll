define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %nminus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.start = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %min.cur = phi i32 [ %i, %outer.body ], [ %min.next, %inner.inc ]
  %j.cur = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.jn = icmp slt i32 %j.cur, %n
  br i1 %cmp.jn, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j.cur to i64
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %vj = load i32, i32* %gep.j, align 4
  %min.ext = sext i32 %min.cur to i64
  %gep.min = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %vmin = load i32, i32* %gep.min, align 4
  %cmp.lt = icmp slt i32 %vj, %vmin
  br i1 %cmp.lt, label %if.then, label %if.end

if.then:
  br label %inner.inc

if.end:
  br label %inner.inc

inner.inc:
  %min.next = phi i32 [ %j.cur, %if.then ], [ %min.cur, %if.end ]
  %j.next = add i32 %j.cur, 1
  br label %inner.cond

after.inner:
  %i.ext = sext i32 %i to i64
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %val.i = load i32, i32* %gep.i, align 4
  %min2.ext = sext i32 %min.cur to i64
  %gep.min2 = getelementptr inbounds i32, i32* %arr, i64 %min2.ext
  %val.min = load i32, i32* %gep.min2, align 4
  store i32 %val.min, i32* %gep.i, align 4
  store i32 %val.i, i32* %gep.min2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}