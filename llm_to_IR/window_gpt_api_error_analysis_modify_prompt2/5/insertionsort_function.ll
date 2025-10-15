target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %outer.end

outer.body:
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %ptr.i, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %inner.exit, label %inner.cmp

inner.cmp:
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key.lt = icmp slt i32 %key, %val.jm1
  br i1 %key.lt, label %inner.shift, label %inner.exit

inner.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.final = phi i64 [ %j, %inner.cond ], [ %j, %inner.cmp ]
  %ptr.dest = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ptr.dest, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

outer.end:
  ret void
}