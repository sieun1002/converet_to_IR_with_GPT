define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.header

outer.header:
  %limit = phi i64 [ %n, %entry ], [ %limit.next, %outer.update ]
  %gt1 = icmp ugt i64 %limit, 1
  br i1 %gt1, label %outer.body.init, label %ret

outer.body.init:
  br label %inner.header

inner.header:
  %j = phi i64 [ 1, %outer.body.init ], [ %j.next, %inc ]
  %last = phi i64 [ 0, %outer.body.init ], [ %last.updated, %inc ]
  %j_lt_limit = icmp ult i64 %j, %limit
  br i1 %j_lt_limit, label %inner.body, label %after.inner

inner.body:
  %jm1 = add i64 %j, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %j
  %v.prev = load i32, i32* %ptr.prev
  %v.cur = load i32, i32* %ptr.cur
  %need.swap = icmp sgt i32 %v.prev, %v.cur
  br i1 %need.swap, label %swap, label %no.swap

swap:
  store i32 %v.cur, i32* %ptr.prev
  store i32 %v.prev, i32* %ptr.cur
  br label %inc

no.swap:
  br label %inc

inc:
  %last.updated = phi i64 [ %j, %swap ], [ %last, %no.swap ]
  %j.next = add i64 %j, 1
  br label %inner.header

after.inner:
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %ret, label %outer.update

outer.update:
  %limit.next = phi i64 [ %last, %after.inner ]
  br label %outer.header

ret:
  ret void
}