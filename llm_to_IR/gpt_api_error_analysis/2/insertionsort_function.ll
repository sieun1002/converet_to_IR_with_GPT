; ModuleID = 'insertion_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %exit

outer.body:
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %j.ne.zero = icmp ne i64 %j, 0
  br i1 %j.ne.zero, label %inner.cmp, label %inner.exit

inner.cmp:
  %j.prev = add i64 %j, -1
  %gep.prev = getelementptr inbounds i32, i32* %arr, i64 %j.prev
  %prev = load i32, i32* %gep.prev, align 4
  %key.lt.prev = icmp slt i32 %key, %prev
  br i1 %key.lt.prev, label %inner.body, label %inner.exit

inner.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %gep.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.final = phi i64 [ %j, %inner.cond ], [ %j, %inner.cmp ]
  %gep.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %gep.final, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}