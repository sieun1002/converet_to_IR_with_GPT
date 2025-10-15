target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.check

outer.check:
  %j = phi i64 [ 1, %entry ], [ %j.next, %outer.latch ]
  %cmp = icmp ult i64 %j, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %arrjptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %key = load i32, i32* %arrjptr, align 4
  br label %inner.cond

inner.cond:
  %i = phi i64 [ %j, %outer.body ], [ %i.dec, %inner.shift ]
  %i.zero = icmp eq i64 %i, 0
  br i1 %i.zero, label %inner.exit, label %inner.check

inner.check:
  %im1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %val_im1 = load i32, i32* %ptr_im1, align 4
  %key_lt = icmp slt i32 %key, %val_im1
  br i1 %key_lt, label %inner.shift, label %inner.exit

inner.shift:
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  store i32 %val_im1, i32* %ptr_i, align 4
  %i.dec = add i64 %i, -1
  br label %inner.cond

inner.exit:
  %ptr_i2 = getelementptr inbounds i32, i32* %arr, i64 %i
  store i32 %key, i32* %ptr_i2, align 4
  br label %outer.latch

outer.latch:
  %j.next = add i64 %j, 1
  br label %outer.check

exit:
  ret void
}