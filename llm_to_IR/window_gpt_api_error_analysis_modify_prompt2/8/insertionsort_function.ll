target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.check

outer.check:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %outer.body, label %exit

outer.body:
  %arr.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %arr.i.ptr, align 4
  br label %inner.check

inner.check:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.zero = icmp eq i64 %j, 0
  br i1 %j.zero, label %insert, label %compare

compare:
  %j.minus1 = add i64 %j, -1
  %arr.jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %arr.jm1 = load i32, i32* %arr.jm1.ptr, align 4
  %key.lt = icmp slt i32 %key, %arr.jm1
  br i1 %key.lt, label %inner.shift, label %insert

inner.shift:
  %arr.j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %arr.jm1, i32* %arr.j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

insert:
  %arr.j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %arr.j.ptr2, align 4
  %i.next = add i64 %i, 1
  br label %outer.latch

outer.latch:
  br label %outer.check

exit:
  ret void
}