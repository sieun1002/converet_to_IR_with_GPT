; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.header

outer.header:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %outer.body, label %exit

outer.body:
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %inner.header

inner.header:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %shift ]
  %j.is0 = icmp eq i64 %j, 0
  br i1 %j.is0, label %after.inner, label %check

check:
  %jm1 = add i64 %j, -1
  %addr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %addr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %shift, label %after.inner

shift:
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %addr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.header

after.inner:
  %j.final = phi i64 [ %j, %inner.header ], [ %j, %check ]
  %addr.jf = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %addr.jf, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.header

exit:
  ret void
}