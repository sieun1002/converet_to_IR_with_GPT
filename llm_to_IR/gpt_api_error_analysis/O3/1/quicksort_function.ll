; target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr nounwind {
entry:
  %cmp.entry = icmp sge i64 %low, %high
  br i1 %cmp.entry, label %ret, label %loop.header

loop.header:
  %lo.cur = phi i64 [ %low, %entry ], [ %lo.next, %loop.latch ]
  %hi.cur = phi i64 [ %high, %entry ], [ %hi.next, %loop.latch ]
  %cmp.loop = icmp sge i64 %lo.cur, %hi.cur
  br i1 %cmp.loop, label %ret, label %partition.init

partition.init:
  %sub.hi.lo = sub i64 %hi.cur, %lo.cur
  %shr = ashr i64 %sub.hi.lo, 1
  %mid = add i64 %shr, %lo.cur
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.loop

partition.loop:
  %i.cur = phi i64 [ %lo.cur, %partition.init ], [ %i.inc, %inc.i ], [ %i.after.swap, %do.swap ]
  %j.cur = phi i64 [ %hi.cur, %partition.init ], [ %j.cur, %inc.i ], [ %j.after.swap, %do.swap ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ai = load i32, i32* %i.ptr, align 4
  %cmp.ai.pivot = icmp slt i32 %ai, %pivot
  br i1 %cmp.ai.pivot, label %inc.i, label %scan.j

inc.i:
  %i.inc = add i64 %i.cur, 1
  br label %partition.loop

scan.j:
  br label %jscan.loop

jscan.loop:
  %j.scan = phi i64 [ %j.cur, %scan.j ], [ %j.next, %j.dec ]
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %aj = load i32, i32* %j.ptr2, align 4
  %cmp.aj.pivot = icmp sgt i32 %aj, %pivot
  br i1 %cmp.aj.pivot, label %j.dec, label %after.scan

j.dec:
  %j.next = add i64 %j.scan, -1
  br label %jscan.loop

after.scan:
  %cmp.i.le.j = icmp sle i64 %i.cur, %j.scan
  br i1 %cmp.i.le.j, label %do.swap, label %break.partition

do.swap:
  store i32 %aj, i32* %i.ptr, align 4
  store i32 %ai, i32* %j.ptr2, align 4
  %i.after.swap = add i64 %i.cur, 1
  %j.after.swap = add i64 %j.scan, -1
  br label %partition.loop

break.partition:
  %left.size = sub i64 %j.scan, %lo.cur
  %right.size = sub i64 %hi.cur, %i.cur
  %cmp.left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %cmp.left.ge.right, label %case.leftge, label %case.rightgt

case.leftge:
  %cond.right = icmp slt i64 %i.cur, %hi.cur
  br i1 %cond.right, label %call.right, label %skip.call.right

call.right:
  tail call void @quick_sort(i32* %arr, i64 %i.cur, i64 %hi.cur)
  br label %skip.call.right

skip.call.right:
  %lo.next.r = add i64 %lo.cur, 0
  %hi.next.r = add i64 %j.scan, 0
  br label %loop.latch

case.rightgt:
  %cond.left = icmp sgt i64 %j.scan, %lo.cur
  br i1 %cond.left, label %call.left, label %skip.call.left

call.left:
  tail call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.scan)
  br label %skip.call.left

skip.call.left:
  %lo.next.l = add i64 %i.cur, 0
  %hi.next.l = add i64 %hi.cur, 0
  br label %loop.latch

loop.latch:
  %lo.next = phi i64 [ %lo.next.r, %skip.call.right ], [ %lo.next.l, %skip.call.left ]
  %hi.next = phi i64 [ %hi.next.r, %skip.call.right ], [ %hi.next.l, %skip.call.left ]
  br label %loop.header

ret:
  ret void
}