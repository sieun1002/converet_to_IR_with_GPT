target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %outer.header.init

outer.header.init:
  br label %outer.header

outer.header:
  %endBound = phi i64 [ %n, %outer.header.init ], [ %lastSwap.phi, %after.inner.set ]
  %cond.end.gt1 = icmp ugt i64 %endBound, 1
  br i1 %cond.end.gt1, label %outer.body.init, label %exit

outer.body.init:
  br label %inner.header.init

inner.header.init:
  br label %inner.header

inner.header:
  %i.phi = phi i64 [ 1, %inner.header.init ], [ %i.next, %inner.after ]
  %lastSwap.phi = phi i64 [ 0, %inner.header.init ], [ %lastSwap.next, %inner.after ]
  %cond.i.lt.end = icmp ult i64 %i.phi, %endBound
  br i1 %cond.i.lt.end, label %inner.body, label %after.inner

inner.body:
  %i.minus1 = add i64 %i.phi, -1
  %ptr.left = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %val.left = load i32, i32* %ptr.left, align 4
  %ptr.right = getelementptr inbounds i32, i32* %arr, i64 %i.phi
  %val.right = load i32, i32* %ptr.right, align 4
  %cmp.le = icmp sle i32 %val.left, %val.right
  br i1 %cmp.le, label %inner.after, label %swap

swap:
  store i32 %val.right, i32* %ptr.left, align 4
  store i32 %val.left, i32* %ptr.right, align 4
  br label %inner.after

inner.after:
  %lastSwap.next = phi i64 [ %lastSwap.phi, %inner.body ], [ %i.phi, %swap ]
  %i.next = add i64 %i.phi, 1
  br label %inner.header

after.inner:
  %no.swap = icmp eq i64 %lastSwap.phi, 0
  br i1 %no.swap, label %exit, label %after.inner.set

after.inner.set:
  br label %outer.header

exit:
  ret void
}