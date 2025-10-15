; target: System V x86_64 Linux (LLVM 14)
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  %cmp.entry = icmp sge i64 %low, %high
  br i1 %cmp.entry, label %ret, label %outer.header

outer.header:
  %low.h = phi i64 [ %low, %entry ], [ %low.next.ph, %outer.cont ]
  %high.h = phi i64 [ %high, %entry ], [ %high.next.ph, %outer.cont ]
  %delta = sub nsw i64 %high.h, %low.h
  %half = ashr i64 %delta, 1
  %mid = add nsw i64 %low.h, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %ptr.mid, align 4
  br label %p.loop.header

p.loop.header:
  %i.cur = phi i64 [ %low.h, %outer.header ], [ %i.afterSwap, %p.loop.afterSwap ]
  %j.cur = phi i64 [ %high.h, %outer.header ], [ %j.afterSwap, %p.loop.afterSwap ]
  br label %p.adjust_i

p.adjust_i:
  %i.scan = phi i64 [ %i.cur, %p.loop.header ], [ %i.scan.next, %p.i.inc ]
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.scan
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %p.i.inc, label %p.adjust_j.init

p.i.inc:
  %i.scan.next = add nsw i64 %i.scan, 1
  br label %p.adjust_i

p.adjust_j.init:
  br label %p.adjust_j

p.adjust_j:
  %j.scan = phi i64 [ %j.cur, %p.adjust_j.init ], [ %j.scan.next, %p.j.dec ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.j, label %p.j.dec, label %p.compare

p.j.dec:
  %j.scan.next = add nsw i64 %j.scan, -1
  br label %p.adjust_j

p.compare:
  %cmp.ilej = icmp sle i64 %i.scan, %j.scan
  br i1 %cmp.ilej, label %p.swap, label %p.break

p.swap:
  store i32 %val.j, i32* %ptr.i, align 4
  store i32 %val.i, i32* %ptr.j, align 4
  %i.afterSwap = add nsw i64 %i.scan, 1
  %j.afterSwap = add nsw i64 %j.scan, -1
  br label %p.loop.afterSwap

p.loop.afterSwap:
  br label %p.loop.header

p.break:
  %leftsize = sub nsw i64 %j.scan, %low.h
  %rightsize = sub nsw i64 %high.h, %i.scan
  %leftGeRight = icmp sge i64 %leftsize, %rightsize
  br i1 %leftGeRight, label %recurse.right.first, label %recurse.left.first

recurse.left.first:
  %needL = icmp sgt i64 %j.scan, %low.h
  br i1 %needL, label %call.left, label %after.left

call.left:
  call void @quick_sort(i32* %arr, i64 %low.h, i64 %j.scan)
  br label %after.left

after.left:
  %low.next = add i64 %i.scan, 0
  %high.next = add i64 %high.h, 0
  br label %outer.cont

recurse.right.first:
  %needR = icmp slt i64 %i.scan, %high.h
  br i1 %needR, label %call.right, label %after.right

call.right:
  call void @quick_sort(i32* %arr, i64 %i.scan, i64 %high.h)
  br label %after.right

after.right:
  %low.next2 = add i64 %low.h, 0
  %high.next2 = add i64 %j.scan, 0
  br label %outer.cont

outer.cont:
  %low.next.ph = phi i64 [ %low.next, %after.left ], [ %low.next2, %after.right ]
  %high.next.ph = phi i64 [ %high.next, %after.left ], [ %high.next2, %after.right ]
  %cont = icmp slt i64 %low.next.ph, %high.next.ph
  br i1 %cont, label %outer.header, label %ret

ret:
  ret void
}