define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:
  %min.init = %i
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %min = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %inner.end

inner.body:
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %a.j = load i32, i32* %j.ptr, align 4
  %a.min = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %a.j, %a.min
  br i1 %is.less, label %inner.then, label %inner.inc

inner.then:
  br label %inner.inc

inner.inc:
  %min.next = phi i32 [ %min, %inner.body ], [ %j, %inner.then ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

inner.end:
  %min.final = phi i32 [ %min, %inner.cond ]
  %i64 = sext i32 %i to i64
  %min64.end = sext i32 %min.final to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %min.ptr.end = getelementptr inbounds i32, i32* %arr, i64 %min64.end
  %tmp = load i32, i32* %i.ptr, align 4
  %val.min = load i32, i32* %min.ptr.end, align 4
  store i32 %val.min, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr.end, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

return:
  ret void
}