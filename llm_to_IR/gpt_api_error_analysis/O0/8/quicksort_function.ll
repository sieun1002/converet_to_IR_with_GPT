; Reconstructed LLVM IR for quick_sort (x86-64, LLVM 14)
; Signature: void quick_sort(i32* base, i64 left, i64 right)

define void @quick_sort(i32* nocapture %base, i64 %left, i64 %right) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %left.cur = phi i64 [ %left, %entry ], [ %left.next.l, %left.no.recurse ], [ %left.next.r, %right.no.recurse ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.next.l, %left.no.recurse ], [ %right.next.r, %right.no.recurse ]
  %cmp.lr = icmp slt i64 %left.cur, %right.cur
  br i1 %cmp.lr, label %partition.init, label %exit

partition.init:
  %diff = sub i64 %right.cur, %left.cur
  %diff_shr = lshr i64 %diff, 63
  %adj = add i64 %diff, %diff_shr
  %half = ashr i64 %adj, 1
  %mid = add i64 %left.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %i.header

i.header:
  %i.h = phi i64 [ %left.cur, %partition.init ], [ %i.next, %i.inc ], [ %i.after.swap, %swap.back ]
  %j.h = phi i64 [ %right.cur, %partition.init ], [ %j.stay, %i.inc ], [ %j.after.swap, %swap.back ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.h
  %i.load = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.load, %pivot.val
  br i1 %cmp.i, label %i.inc, label %j.header

i.inc:
  %i.next = add i64 %i.h, 1
  %j.stay = add i64 %j.h, 0
  br label %i.header

j.header:
  %i.j = phi i64 [ %i.h, %i.header ], [ %i.j.stay, %j.dec ]
  %j.j = phi i64 [ %j.h, %i.header ], [ %j.next, %j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.j
  %j.load = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.load, %pivot.val
  br i1 %cmp.j, label %j.dec, label %check

j.dec:
  %j.next = add i64 %j.j, -1
  %i.j.stay = add i64 %i.j, 0
  br label %j.header

check:
  %cmp.ij = icmp sle i64 %i.j, %j.j
  br i1 %cmp.ij, label %swap, label %after

swap:
  %i.ptr.s = getelementptr inbounds i32, i32* %base, i64 %i.j
  %tmp.load = load i32, i32* %i.ptr.s, align 4
  %j.ptr.s = getelementptr inbounds i32, i32* %base, i64 %j.j
  %val.j = load i32, i32* %j.ptr.s, align 4
  store i32 %val.j, i32* %i.ptr.s, align 4
  store i32 %tmp.load, i32* %j.ptr.s, align 4
  %i.after.swap = add i64 %i.j, 1
  %j.after.swap = add i64 %j.j, -1
  br label %swap.back

swap.back:
  br label %i.header

after:
  %left.size = sub i64 %j.j, %left.cur
  %right.size = sub i64 %right.cur, %i.j
  %cmp.size = icmp sge i64 %left.size, %right.size
  br i1 %cmp.size, label %right.small, label %left.small

left.small:
  %cond.left.recurse = icmp slt i64 %left.cur, %j.j
  br i1 %cond.left.recurse, label %left.recurse, label %left.no.recurse

left.recurse:
  call void @quick_sort(i32* %base, i64 %left.cur, i64 %j.j)
  br label %left.no.recurse

left.no.recurse:
  %left.next.l = add i64 %i.j, 0
  %right.next.l = add i64 %right.cur, 0
  br label %outer.cond

right.small:
  %cond.right.recurse = icmp slt i64 %i.j, %right.cur
  br i1 %cond.right.recurse, label %right.recurse, label %right.no.recurse

right.recurse:
  call void @quick_sort(i32* %base, i64 %i.j, i64 %right.cur)
  br label %right.no.recurse

right.no.recurse:
  %left.next.r = add i64 %left.cur, 0
  %right.next.r = add i64 %j.j, 0
  br label %outer.cond

exit:
  ret void
}