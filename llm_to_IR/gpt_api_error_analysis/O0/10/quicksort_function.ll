; target triple must match your build environment
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* noundef %arr, i64 noundef %low, i64 noundef %high) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:
  %low.hdr = phi i64 [ %low, %entry ], [ %low.next.L, %back.left ], [ %low.next.R, %back.right ]
  %high.hdr = phi i64 [ %high, %entry ], [ %high.next.L, %back.left ], [ %high.next.R, %back.right ]
  %cmp0 = icmp slt i64 %low.hdr, %high.hdr
  br i1 %cmp0, label %part.init, label %exit

part.init:
  %i.init = add i64 %low.hdr, 0
  %j.init = add i64 %high.hdr, 0
  %diff = sub i64 %high.hdr, %low.hdr
  %shifted = ashr i64 %diff, 1
  %mid = add i64 %low.hdr, %shifted
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.loop.header

part.loop.header:
  %i.loop = phi i64 [ %i.init, %part.init ], [ %i.next2, %swap.do ]
  %j.loop = phi i64 [ %j.init, %part.init ], [ %j.next2, %swap.do ]
  br label %left.scan

left.scan:
  %i.cur = phi i64 [ %i.loop, %part.loop.header ], [ %i.inc, %left.cont ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmpL = icmp sgt i32 %pivot, %i.val
  br i1 %cmpL, label %left.cont, label %left.done

left.cont:
  %i.inc = add i64 %i.cur, 1
  br label %left.scan

left.done:
  br label %right.scan

right.scan:
  %j.cur = phi i64 [ %j.loop, %left.done ], [ %j.dec, %right.cont ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmpR = icmp slt i32 %pivot, %j.val
  br i1 %cmpR, label %right.cont, label %after.scans

right.cont:
  %j.dec = add i64 %j.cur, -1
  br label %right.scan

after.scans:
  %cmpIJ = icmp sle i64 %i.cur, %j.cur
  br i1 %cmpIJ, label %swap.do, label %part.done

swap.do:
  %i.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %vi = load i32, i32* %i.ptr2, align 4
  %vj = load i32, i32* %j.ptr2, align 4
  store i32 %vj, i32* %i.ptr2, align 4
  store i32 %vi, i32* %j.ptr2, align 4
  %i.next2 = add i64 %i.cur, 1
  %j.next2 = add i64 %j.cur, -1
  br label %part.loop.header

part.done:
  %leftLen = sub i64 %j.cur, %low.hdr
  %rightLen = sub i64 %high.hdr, %i.cur
  %cmpSizes = icmp sge i64 %leftLen, %rightLen
  br i1 %cmpSizes, label %branch.rightFirst, label %branch.leftFirst

branch.leftFirst:
  %condL = icmp slt i64 %low.hdr, %j.cur
  br i1 %condL, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* noundef %arr, i64 noundef %low.hdr, i64 noundef %j.cur)
  br label %skip.left

skip.left:
  %low.next.L = add i64 %i.cur, 0
  %high.next.L = add i64 %high.hdr, 0
  br label %back.left

back.left:
  br label %loop.header

branch.rightFirst:
  %condR = icmp slt i64 %i.cur, %high.hdr
  br i1 %condR, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* noundef %arr, i64 noundef %i.cur, i64 noundef %high.hdr)
  br label %skip.right

skip.right:
  %low.next.R = add i64 %low.hdr, 0
  %high.next.R = add i64 %j.cur, 0
  br label %back.right

back.right:
  br label %loop.header

exit:
  ret void
}