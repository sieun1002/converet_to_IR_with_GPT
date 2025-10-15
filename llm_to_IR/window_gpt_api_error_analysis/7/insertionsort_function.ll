; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %ret

outer.body:
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %inner.cond

inner.cond:
  %j.cur = phi i64 [ %i, %outer.body ], [ %j.next, %inner.shift ]
  %j.zero = icmp eq i64 %j.cur, 0
  br i1 %j.zero, label %inner.done, label %inner.check

inner.check:
  %j.minus1 = add i64 %j.cur, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %inner.shift, label %inner.done

inner.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.next = add i64 %j.cur, -1
  br label %inner.cond

inner.done:
  %j.end = phi i64 [ %j.cur, %inner.cond ], [ %j.cur, %inner.check ]
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %dest.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:
  ret void
}