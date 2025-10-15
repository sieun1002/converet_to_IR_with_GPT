; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %low0, i32 %high0) {
entry:
  br label %loop.cond

loop.cond:                                               ; preds = %entry, %left.small.end, %right.big.end
  %low = phi i32 [ %low0, %entry ], [ %low.next.ls, %left.small.end ], [ %low.next.rb, %right.big.end ]
  %high = phi i32 [ %high0, %entry ], [ %high.next.ls, %left.small.end ], [ %high.next.rb, %right.big.end ]
  %cmp.loop = icmp slt i32 %low, %high
  br i1 %cmp.loop, label %partition.init, label %exit

partition.init:                                          ; preds = %loop.cond
  ; mid = low + (((high - low) + ((high - low) >> 31)) >> 1)
  %diff = sub i32 %high, %low
  %sign = lshr i32 %diff, 31
  %diff.adj = add i32 %diff, %sign
  %half = ashr i32 %diff.adj, 1
  %mid = add i32 %low, %half
  %mid.ext = sext i32 %mid to i64
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.ext
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %left.scan

left.scan:                                               ; preds = %partition.init, %left.scan, %partition.check
  %left.cur = phi i32 [ %low, %partition.init ], [ %left.inc, %left.scan ], [ %left.cont, %partition.check ]
  %right.cur.l = phi i32 [ %high, %partition.init ], [ %right.cur.l, %left.scan ], [ %right.cont, %partition.check ]
  %left.idx.ext = sext i32 %left.cur to i64
  %left.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %left.idx.ext
  %left.elem = load i32, i32* %left.elem.ptr, align 4
  %cmp.left = icmp sgt i32 %pivot, %left.elem
  %left.inc = add i32 %left.cur, 1
  br i1 %cmp.left, label %left.scan, label %right.scan

right.scan:                                              ; preds = %left.scan, %right.scan
  %right.cur = phi i32 [ %right.cur.l, %left.scan ], [ %right.dec, %right.scan ]
  %left.pass = phi i32 [ %left.cur, %left.scan ], [ %left.pass, %right.scan ]
  %right.idx.ext = sext i32 %right.cur to i64
  %right.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %right.idx.ext
  %right.elem = load i32, i32* %right.elem.ptr, align 4
  %cmp.right = icmp slt i32 %pivot, %right.elem
  %right.dec = sub i32 %right.cur, 1
  br i1 %cmp.right, label %right.scan, label %compare.swap

compare.swap:                                            ; preds = %right.scan
  %cmp.leq = icmp sgt i32 %left.pass, %right.cur
  br i1 %cmp.leq, label %partition.check, label %do.swap

do.swap:                                                 ; preds = %compare.swap
  %left.idx.ext2 = sext i32 %left.pass to i64
  %right.idx.ext2 = sext i32 %right.cur to i64
  %left.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left.idx.ext2
  %right.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right.idx.ext2
  %tmp = load i32, i32* %left.ptr2, align 4
  %val.right = load i32, i32* %right.ptr2, align 4
  store i32 %val.right, i32* %left.ptr2, align 4
  store i32 %tmp, i32* %right.ptr2, align 4
  %left.after = add i32 %left.pass, 1
  %right.after = sub i32 %right.cur, 1
  br label %partition.check

partition.check:                                         ; preds = %compare.swap, %do.swap
  %left.cont = phi i32 [ %left.pass, %compare.swap ], [ %left.after, %do.swap ]
  %right.cont = phi i32 [ %right.cur, %compare.swap ], [ %right.after, %do.swap ]
  %cont.cond = icmp sle i32 %left.cont, %right.cont
  br i1 %cont.cond, label %left.scan, label %partition.end

partition.end:                                           ; preds = %partition.check
  %size.left = sub i32 %right.cont, %low
  %size.right = sub i32 %high, %left.cont
  %cmp.size = icmp sge i32 %size.left, %size.right
  br i1 %cmp.size, label %right.big, label %left.small

left.small:                                              ; preds = %partition.end
  %need.call.left = icmp slt i32 %low, %right.cont
  br i1 %need.call.left, label %left.small.call, label %left.small.skip

left.small.call:                                         ; preds = %left.small
  call void @quick_sort(i32* %arr, i32 %low, i32 %right.cont)
  br label %left.small.end

left.small.skip:                                         ; preds = %left.small
  br label %left.small.end

left.small.end:                                          ; preds = %left.small.call, %left.small.skip
  %low.next.ls = add i32 %left.cont, 0
  %high.next.ls = add i32 %high, 0
  br label %loop.cond

right.big:                                               ; preds = %partition.end
  %need.call.right = icmp slt i32 %left.cont, %high
  br i1 %need.call.right, label %right.big.call, label %right.big.skip

right.big.call:                                          ; preds = %right.big
  call void @quick_sort(i32* %arr, i32 %left.cont, i32 %high)
  br label %right.big.end

right.big.skip:                                          ; preds = %right.big
  br label %right.big.end

right.big.end:                                           ; preds = %right.big.call, %right.big.skip
  %low.next.rb = add i32 %low, 0
  %high.next.rb = add i32 %right.cont, 0
  br label %loop.cond

exit:                                                    ; preds = %loop.cond
  ret void
}