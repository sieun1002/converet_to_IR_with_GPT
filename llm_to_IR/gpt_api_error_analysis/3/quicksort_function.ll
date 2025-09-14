; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* noundef %arr, i64 noundef %low, i64 noundef %high) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:
  %low.cur = phi i64 [ %low, %entry ], [ %i.for.j, %after.left.call ], [ %low.cur, %after.right.call ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.cur, %after.left.call ], [ %j.cur2, %after.right.call ]
  %cmp.lh = icmp slt i64 %low.cur, %high.cur
  br i1 %cmp.lh, label %part.init, label %exit

part.init:
  %diff = sub i64 %high.cur, %low.cur
  %sign = lshr i64 %diff, 63
  %diff.adj = add i64 %diff, %sign
  %half = ashr i64 %diff.adj, 1
  %mid = add i64 %low.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %i.scan

i.scan:
  %i.cur = phi i64 [ %low.cur, %part.init ], [ %i.inc.val, %i.inc ], [ %i.after.swap, %after.swap ]
  %j.hold = phi i64 [ %high.cur, %part.init ], [ %j.hold, %i.inc ], [ %j.after.swap, %after.swap ]
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i.cur = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp sgt i32 %pivot, %val.i.cur
  br i1 %cmp.i, label %i.inc, label %j.scan

i.inc:
  %i.inc.val = add nsw i64 %i.cur, 1
  br label %i.scan

j.scan:
  %i.for.j = phi i64 [ %i.cur, %i.scan ], [ %i.for.j, %j.dec ]
  %j.cur2 = phi i64 [ %j.hold, %i.scan ], [ %j.dec.val, %j.dec ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur2
  %val.j.cur = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp slt i32 %pivot, %val.j.cur
  br i1 %cmp.j, label %j.dec, label %compare

j.dec:
  %j.dec.val = add nsw i64 %j.cur2, -1
  br label %j.scan

compare:
  %le.ij = icmp sle i64 %i.for.j, %j.cur2
  br i1 %le.ij, label %swap, label %part.done

swap:
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.for.j
  %a.i = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.cur2
  %a.j = load i32, i32* %ptr.j.swap, align 4
  store i32 %a.j, i32* %ptr.i.swap, align 4
  store i32 %a.i, i32* %ptr.j.swap, align 4
  br label %after.swap

after.swap:
  %i.after.swap = add nsw i64 %i.for.j, 1
  %j.after.swap = add nsw i64 %j.cur2, -1
  br label %i.scan

part.done:
  %left.size = sub nsw i64 %j.cur2, %low.cur
  %right.size = sub nsw i64 %high.cur, %i.for.j
  %choose.right = icmp sge i64 %left.size, %right.size
  br i1 %choose.right, label %cont.right, label %cont.left

cont.left:
  %do.left = icmp slt i64 %low.cur, %j.cur2
  br i1 %do.left, label %call.left, label %after.left.call

call.left:
  call void @quick_sort(i32* noundef %arr, i64 noundef %low.cur, i64 noundef %j.cur2)
  br label %after.left.call

after.left.call:
  br label %loop.check

cont.right:
  %do.right = icmp slt i64 %i.for.j, %high.cur
  br i1 %do.right, label %call.right, label %after.right.call

call.right:
  call void @quick_sort(i32* noundef %arr, i64 noundef %i.for.j, i64 noundef %high.cur)
  br label %after.right.call

after.right.call:
  br label %loop.check

exit:
  ret void
}