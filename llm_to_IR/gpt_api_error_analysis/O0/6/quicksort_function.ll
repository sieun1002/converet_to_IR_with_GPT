; LLVM 14 IR for quick_sort(int* arr, long left, long right)
define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %outer.header

outer.header:
  %left.ph = phi i64 [ %left, %entry ], [ %left.next.left, %cont.left ], [ %left.next.right, %cont.right ]
  %right.ph = phi i64 [ %right, %entry ], [ %right.next.left, %cont.left ], [ %right.next.right, %cont.right ]
  %cmp.outer = icmp slt i64 %left.ph, %right.ph
  br i1 %cmp.outer, label %partition.init, label %return

partition.init:
  %i.init = add i64 %left.ph, 0
  %j.init = add i64 %right.ph, 0
  %diff = sub i64 %right.ph, %left.ph
  %half = sdiv i64 %diff, 2
  %mid = add i64 %left.ph, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %inner.iter

inner.iter:
  %i.cur = phi i64 [ %i.init, %partition.init ], [ %i.after, %swap.cont ]
  %j.cur = phi i64 [ %j.init, %partition.init ], [ %j.after, %swap.cont ]
  br label %inc_i.loop

inc_i.loop:
  %i.c = phi i64 [ %i.cur, %inner.iter ], [ %i.inc, %inc_i.body ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.c
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.body, label %inc_i.exit

inc_i.body:
  %i.inc = add i64 %i.c, 1
  br label %inc_i.loop

inc_i.exit:
  %i.out = phi i64 [ %i.c, %inc_i.loop ]
  br label %dec_j.loop

dec_j.loop:
  %i.keep = phi i64 [ %i.out, %inc_i.exit ], [ %i.keep, %dec_j.body ]
  %j.c = phi i64 [ %j.cur, %inc_i.exit ], [ %j.dec, %dec_j.body ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.body, label %dec_j.exit

dec_j.body:
  %j.dec = add i64 %j.c, -1
  br label %dec_j.loop

dec_j.exit:
  br label %cmp.swap

cmp.swap:
  %cmp.ij = icmp sgt i64 %i.keep, %j.c
  br i1 %cmp.ij, label %after.partition, label %do.swap

do.swap:
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.keep
  %val.i.swap = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %val.j.swap = load i32, i32* %ptr.j.swap, align 4
  store i32 %val.j.swap, i32* %ptr.i.swap, align 4
  store i32 %val.i.swap, i32* %ptr.j.swap, align 4
  %i.after = add i64 %i.keep, 1
  %j.after = add i64 %j.c, -1
  br label %swap.cont

swap.cont:
  br label %inner.iter

after.partition:
  %size.left = sub i64 %j.c, %left.ph
  %size.right = sub i64 %right.ph, %i.keep
  %left.smaller = icmp slt i64 %size.left, %size.right
  br i1 %left.smaller, label %left.case, label %right.case

left.case:
  %cond.left = icmp slt i64 %left.ph, %j.c
  br i1 %cond.left, label %left.call, label %left.skip

left.call:
  call void @quick_sort(i32* %arr, i64 %left.ph, i64 %j.c)
  br label %cont.left

left.skip:
  br label %cont.left

cont.left:
  %left.next.left = add i64 %i.keep, 0
  %right.next.left = add i64 %right.ph, 0
  br label %outer.header

right.case:
  %cond.right = icmp slt i64 %i.keep, %right.ph
  br i1 %cond.right, label %right.call, label %right.skip

right.call:
  call void @quick_sort(i32* %arr, i64 %i.keep, i64 %right.ph)
  br label %cont.right

right.skip:
  br label %cont.right

cont.right:
  %left.next.right = add i64 %left.ph, 0
  %right.next.right = add i64 %j.c, 0
  br label %outer.header

return:
  ret void
}