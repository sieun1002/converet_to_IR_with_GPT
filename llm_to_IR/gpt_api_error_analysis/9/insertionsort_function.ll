define void @insertion_sort(i32* %arr, i64 %len) {
entry:
  br label %outer.cond

outer.cond:
  %i.cur = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp ult i64 %i.cur, %len
  br i1 %cmp.outer, label %outer.body.preheader, label %exit

outer.body.preheader:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %key = load i32, i32* %elem.ptr, align 4
  br label %inner.cond

inner.cond:
  %j.cur = phi i64 [ %i.cur, %outer.body.preheader ], [ %j.dec, %inner.body ]
  %j.is.zero = icmp eq i64 %j.cur, 0
  br i1 %j.is.zero, label %inner.exit, label %inner.check

inner.check:
  %j.minus1 = add i64 %j.cur, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %prev = load i32, i32* %jm1.ptr, align 4
  %key.lt.prev = icmp slt i32 %key, %prev
  br i1 %key.lt.prev, label %inner.body, label %inner.exit

inner.body:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  store i32 %prev, i32* %j.ptr, align 4
  %j.dec = add i64 %j.cur, -1
  br label %inner.cond

inner.exit:
  %j.final = phi i64 [ %j.cur, %inner.cond ], [ %j.cur, %inner.check ]
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %dest.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i.cur, 1
  br label %outer.cond

exit:
  ret void
}