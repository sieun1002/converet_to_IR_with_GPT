; ModuleID = 'quick_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %outer.loop

outer.loop:
  %lo.cur = phi i64 [ %lo, %entry ], [ %left.scan, %left.cont ], [ %lo.cur, %right.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.cur, %left.cont ], [ %right.scan, %right.cont ]
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %partition.init, label %ret

partition.init:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.loop

scan.loop:
  %left.cur2 = phi i64 [ %lo.cur, %partition.init ], [ %left.next, %doSwap ]
  %right.cur2 = phi i64 [ %hi.cur, %partition.init ], [ %right.next, %doSwap ]
  br label %incLeft

incLeft:
  %left.scan = phi i64 [ %left.cur2, %scan.loop ], [ %left.inc, %incLeft.inc ]
  %pl.ptr = getelementptr inbounds i32, i32* %arr, i64 %left.scan
  %pl = load i32, i32* %pl.ptr, align 4
  %cmpL = icmp slt i32 %pl, %pivot
  br i1 %cmpL, label %incLeft.inc, label %decRight.start

incLeft.inc:
  %left.inc = add i64 %left.scan, 1
  br label %incLeft

decRight.start:
  br label %decRight

decRight:
  %right.scan = phi i64 [ %right.cur2, %decRight.start ], [ %right.dec, %decRight.dec ]
  %pr.ptr = getelementptr inbounds i32, i32* %arr, i64 %right.scan
  %pr = load i32, i32* %pr.ptr, align 4
  %cmpR = icmp sgt i32 %pr, %pivot
  br i1 %cmpR, label %decRight.dec, label %after.step

decRight.dec:
  %right.dec = add i64 %right.scan, -1
  br label %decRight

after.step:
  %cmpLR = icmp sle i64 %left.scan, %right.scan
  br i1 %cmpLR, label %doSwap, label %partition.done

doSwap:
  %pl.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left.scan
  %pr.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right.scan
  %valL = load i32, i32* %pl.ptr2, align 4
  %valR = load i32, i32* %pr.ptr2, align 4
  store i32 %valR, i32* %pl.ptr2, align 4
  store i32 %valL, i32* %pr.ptr2, align 4
  %left.next = add i64 %left.scan, 1
  %right.next = add i64 %right.scan, -1
  br label %scan.loop

partition.done:
  %len.left = sub i64 %right.scan, %lo.cur
  %len.right = sub i64 %hi.cur, %left.scan
  %cmp.len = icmp sge i64 %len.left, %len.right
  br i1 %cmp.len, label %right.first, label %left.first

left.first:
  %need.left = icmp slt i64 %lo.cur, %right.scan
  br i1 %need.left, label %left.call, label %left.cont

left.call:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %right.scan)
  br label %left.cont

left.cont:
  br label %outer.loop

right.first:
  %need.right = icmp slt i64 %left.scan, %hi.cur
  br i1 %need.right, label %right.call, label %right.cont

right.call:
  call void @quick_sort(i32* %arr, i64 %left.scan, i64 %hi.cur)
  br label %right.cont

right.cont:
  br label %outer.loop

ret:
  ret void
}