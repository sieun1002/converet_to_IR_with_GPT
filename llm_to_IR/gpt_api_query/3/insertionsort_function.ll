; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %outer.body, label %outer.end

outer.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.next, %inner.latch ]
  %j.gt0 = icmp ne i64 %j, 0
  br i1 %j.gt0, label %inner.check, label %inner.end

inner.check:
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %inner.body, label %inner.end

inner.body:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  br label %inner.latch

inner.latch:
  %j.next = add i64 %j, -1
  br label %inner.cond

inner.end:
  %j.final = phi i64 [ 0, %inner.cond ], [ %j, %inner.check ]
  %dst = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %dst, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.cond

outer.end:
  ret void
}