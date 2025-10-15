; target triple may need adjustment to match your build environment
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.0, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.init = add nsw i32 %i.0, 1
  br label %inner.cond

inner.cond:
  %j.0 = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body.end ]
  %min.0 = phi i32 [ %i.0, %outer.body ], [ %min.next, %inner.body.end ]
  %cmp.j.n = icmp slt i32 %j.0, %n
  br i1 %cmp.j.n, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j.0 to i64
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %val.j = load i32, i32* %gep.j, align 4
  %min.ext = sext i32 %min.0 to i64
  %gep.min = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.min = load i32, i32* %gep.min, align 4
  %cmp.lt = icmp slt i32 %val.j, %val.min
  br i1 %cmp.lt, label %if.then, label %if.end

if.then:
  br label %inner.body.end

if.end:
  br label %inner.body.end

inner.body.end:
  %min.next = phi i32 [ %j.0, %if.then ], [ %min.0, %if.end ]
  %j.next = add nsw i32 %j.0, 1
  br label %inner.cond

after.inner:
  %i.ext = sext i32 %i.0 to i64
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %val.i = load i32, i32* %gep.i, align 4
  %min.ext2 = sext i32 %min.0 to i64
  %gep.min2 = getelementptr inbounds i32, i32* %arr, i64 %min.ext2
  %val.min2 = load i32, i32* %gep.min2, align 4
  store i32 %val.min2, i32* %gep.i, align 4
  store i32 %val.i, i32* %gep.min2, align 4
  %i.next = add nsw i32 %i.0, 1
  br label %outer.cond

exit:
  ret void
}