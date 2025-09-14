; LLVM 14 IR for quick_sort

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %outer.cond

outer.cond:
  %left.cur = phi i64 [ %left, %entry ], [ %left.next, %latch ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.next, %latch ]
  %cmp.lr = icmp slt i64 %left.cur, %right.cur
  br i1 %cmp.lr, label %outer.body, label %ret

outer.body:
  %delta = sub i64 %right.cur, %left.cur
  %half = sdiv i64 %delta, 2
  %mid = add i64 %left.cur, %half
  %gep.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %gep.mid, align 4
  br label %inner.top

inner.top:
  %i.phi = phi i64 [ %left.cur, %outer.body ], [ %i.after.swap, %swap.cont ]
  %j.phi = phi i64 [ %right.cur, %outer.body ], [ %j.after.swap, %swap.cont ]
  br label %inc.loop

inc.loop:
  %i.loop = phi i64 [ %i.phi, %inner.top ], [ %i.next, %inc.iter ]
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.loop
  %val.i = load i32, i32* %gep.i, align 4
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %inc.iter, label %inc.done

inc.iter:
  %i.next = add i64 %i.loop, 1
  br label %inc.loop

inc.done:
  br label %dec.loop

dec.loop:
  %j.loop = phi i64 [ %j.phi, %inc.done ], [ %j.next, %dec.iter ]
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.loop
  %val.j = load i32, i32* %gep.j, align 4
  %cmp.j = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.j, label %dec.iter, label %dec.done

dec.iter:
  %j.next = add i64 %j.loop, -1
  br label %dec.loop

dec.done:
  %cmp.ij = icmp sle i64 %i.loop, %j.loop
  br i1 %cmp.ij, label %do.swap, label %after.partition

do.swap:
  %addr.i = getelementptr inbounds i32, i32* %arr, i64 %i.loop
  %tmp.i = load i32, i32* %addr.i, align 4
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j.loop
  %tmp.j = load i32, i32* %addr.j, align 4
  store i32 %tmp.j, i32* %addr.i, align 4
  store i32 %tmp.i, i32* %addr.j, align 4
  %i.after.swap = add i64 %i.loop, 1
  %j.after.swap = add i64 %j.loop, -1
  br label %swap.cont

swap.cont:
  br label %inner.top

after.partition:
  %left.size = sub i64 %j.loop, %left.cur
  %right.size = sub i64 %right.cur, %i.loop
  %cmp.size = icmp slt i64 %left.size, %right.size
  br i1 %cmp.size, label %left.small, label %right.small

left.small:
  %cond.leftcall = icmp slt i64 %left.cur, %j.loop
  br i1 %cond.leftcall, label %call.left, label %after.left.call

call.left:
  call void @quick_sort(i32* %arr, i64 %left.cur, i64 %j.loop)
  br label %after.left.call

after.left.call:
  br label %latch

right.small:
  %cond.rightcall = icmp slt i64 %i.loop, %right.cur
  br i1 %cond.rightcall, label %call.right, label %after.right.call

call.right:
  call void @quick_sort(i32* %arr, i64 %i.loop, i64 %right.cur)
  br label %after.right.call

after.right.call:
  br label %latch

latch:
  %left.next = phi i64 [ %i.loop, %after.left.call ], [ %left.cur, %after.right.call ]
  %right.next = phi i64 [ %right.cur, %after.left.call ], [ %j.loop, %after.right.call ]
  br label %outer.cond

ret:
  ret void
}