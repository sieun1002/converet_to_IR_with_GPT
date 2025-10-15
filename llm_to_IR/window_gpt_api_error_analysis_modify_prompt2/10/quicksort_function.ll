target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %low, i32 %high) {
entry:
  br label %outer.cond

outer.cond:
  %cur.low = phi i32 [ %low, %entry ], [ %next.low, %outer.latch ]
  %cur.high = phi i32 [ %high, %entry ], [ %next.high, %outer.latch ]
  %cmp.outer = icmp slt i32 %cur.low, %cur.high
  br i1 %cmp.outer, label %part.init, label %ret

part.init:
  %delta = sub i32 %cur.high, %cur.low
  %sign = ashr i32 %delta, 31
  %delta.adj = add i32 %delta, %sign
  %half = ashr i32 %delta.adj, 1
  %mid = add i32 %cur.low, %half
  %mid.idx = sext i32 %mid to i64
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.idx
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %left.loop

left.loop:
  %i = phi i32 [ %cur.low, %part.init ], [ %i.inc, %left.inc ], [ %i3, %check.back ]
  %j = phi i32 [ %cur.high, %part.init ], [ %j.pass, %left.inc ], [ %j3, %check.back ]
  %i.idx = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx
  %ai = load i32, i32* %i.ptr, align 4
  %cmp.left = icmp sgt i32 %pivot, %ai
  br i1 %cmp.left, label %left.inc, label %right.loop

left.inc:
  %i.inc = add nsw i32 %i, 1
  %j.pass = add i32 %j, 0
  br label %left.loop

right.loop:
  %iR = phi i32 [ %i, %left.loop ], [ %i.pass, %right.dec ]
  %jR = phi i32 [ %j, %left.loop ], [ %j.dec, %right.dec ]
  %j.idx = sext i32 %jR to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx
  %aj = load i32, i32* %j.ptr, align 4
  %cmp.right = icmp slt i32 %pivot, %aj
  br i1 %cmp.right, label %right.dec, label %cmp.ij

right.dec:
  %j.dec = add nsw i32 %jR, -1
  %i.pass = add i32 %iR, 0
  br label %right.loop

cmp.ij:
  %cmp.ij.gt = icmp sgt i32 %iR, %jR
  br i1 %cmp.ij.gt, label %part.after, label %swap

swap:
  %iR.idx = sext i32 %iR to i64
  %iR.ptr = getelementptr inbounds i32, i32* %arr, i64 %iR.idx
  %tmp = load i32, i32* %iR.ptr, align 4
  %jR.idx = sext i32 %jR to i64
  %jR.ptr = getelementptr inbounds i32, i32* %arr, i64 %jR.idx
  %valj = load i32, i32* %jR.ptr, align 4
  store i32 %valj, i32* %iR.ptr, align 4
  store i32 %tmp, i32* %jR.ptr, align 4
  %i3 = add nsw i32 %iR, 1
  %j3 = add nsw i32 %jR, -1
  br label %check.back

check.back:
  %cmp.le = icmp sle i32 %i3, %j3
  br i1 %cmp.le, label %left.loop, label %part.after

part.after:
  %i.end = phi i32 [ %iR, %cmp.ij ], [ %i3, %check.back ]
  %j.end = phi i32 [ %jR, %cmp.ij ], [ %j3, %check.back ]
  %left.sz = sub i32 %j.end, %cur.low
  %right.sz = sub i32 %cur.high, %i.end
  %choose.right = icmp sge i32 %left.sz, %right.sz
  br i1 %choose.right, label %right.case, label %left.case

left.case:
  %need.left = icmp slt i32 %cur.low, %j.end
  br i1 %need.left, label %left.call, label %left.skip

left.call:
  call void @quick_sort(i32* %arr, i32 %cur.low, i32 %j.end)
  br label %left.skip

left.skip:
  br label %outer.latch

right.case:
  %need.right = icmp slt i32 %i.end, %cur.high
  br i1 %need.right, label %right.call, label %right.skip

right.call:
  call void @quick_sort(i32* %arr, i32 %i.end, i32 %cur.high)
  br label %right.skip

right.skip:
  br label %outer.latch

outer.latch:
  %next.low = phi i32 [ %i.end, %left.skip ], [ %cur.low, %right.skip ]
  %next.high = phi i32 [ %cur.high, %left.skip ], [ %j.end, %right.skip ]
  br label %outer.cond

ret:
  ret void
}