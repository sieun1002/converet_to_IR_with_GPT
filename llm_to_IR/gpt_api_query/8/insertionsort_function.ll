; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %len) {
entry:
  br label %outer.check

outer.check:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idxptr, align 4
  br label %inner.check

inner.check:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %jzero = icmp eq i64 %j, 0
  br i1 %jzero, label %place.key, label %cmp.key

cmp.key:
  %jm1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key.lt = icmp slt i32 %key, %val.jm1
  br i1 %key.lt, label %inner.shift, label %place.key

inner.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

place.key:
  %ptr.place = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr.place, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.check

exit:
  ret void
}