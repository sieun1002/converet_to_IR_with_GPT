target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  br label %while.check

while.check:
  %l.phi = phi i32 [ %left, %entry ], [ %l.merge, %after.recurse ]
  %r.phi = phi i32 [ %right, %entry ], [ %r.merge, %after.recurse ]
  %cmp0 = icmp slt i32 %l.phi, %r.phi
  br i1 %cmp0, label %part.init, label %ret

part.init:
  %diff = sub i32 %r.phi, %l.phi
  %shr1 = lshr i32 %diff, 31
  %tmp1 = add i32 %diff, %shr1
  %half = ashr i32 %tmp1, 1
  %mid = add i32 %l.phi, %half
  %mid64 = sext i32 %mid to i64
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %ptr.mid, align 4
  br label %inc.check

inc.check:
  %i.cur = phi i32 [ %l.phi, %part.init ], [ %i.inc2, %swap.block ], [ %i.inc, %inc.inc ]
  %j.cur = phi i32 [ %r.phi, %part.init ], [ %j.dec2, %swap.block ], [ %j.cur, %inc.inc ]
  %i64 = sext i32 %i.cur to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val.i = load i32, i32* %ptr.i, align 4
  %cmpi = icmp sgt i32 %pivot, %val.i
  br i1 %cmpi, label %inc.inc, label %dec.check

inc.inc:
  %i.inc = add i32 %i.cur, 1
  br label %inc.check

dec.check:
  %i.cur2 = phi i32 [ %i.cur, %inc.check ], [ %i.cur2, %dec.dec ]
  %j.cur2 = phi i32 [ %j.cur, %inc.check ], [ %j.dec, %dec.dec ]
  %j64 = sext i32 %j.cur2 to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val.j = load i32, i32* %ptr.j, align 4
  %cmpj = icmp slt i32 %pivot, %val.j
  br i1 %cmpj, label %dec.dec, label %cmp.ij

dec.dec:
  %j.dec = add i32 %j.cur2, -1
  br label %dec.check

cmp.ij:
  %le = icmp sle i32 %i.cur2, %j.cur2
  br i1 %le, label %swap.block, label %partition.exit

swap.block:
  %i64.swap = sext i32 %i.cur2 to i64
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i64.swap
  %tmp = load i32, i32* %ptr.i.swap, align 4
  %j64.swap = sext i32 %j.cur2 to i64
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j64.swap
  %valj.swap = load i32, i32* %ptr.j.swap, align 4
  store i32 %valj.swap, i32* %ptr.i.swap, align 4
  store i32 %tmp, i32* %ptr.j.swap, align 4
  %i.inc2 = add i32 %i.cur2, 1
  %j.dec2 = add i32 %j.cur2, -1
  br label %inc.check

partition.exit:
  %lenLeft = sub i32 %j.cur2, %l.phi
  %lenRight = sub i32 %r.phi, %i.cur2
  %leftSmaller = icmp slt i32 %lenLeft, %lenRight
  br i1 %leftSmaller, label %left.smaller, label %right.smaller

left.smaller:
  %needLeftCall = icmp slt i32 %l.phi, %j.cur2
  br i1 %needLeftCall, label %left.call, label %left.skip

left.call:
  call void @quick_sort(i32* %arr, i32 %l.phi, i32 %j.cur2)
  br label %left.cont

left.skip:
  br label %left.cont

left.cont:
  br label %after.recurse

right.smaller:
  %needRightCall = icmp slt i32 %i.cur2, %r.phi
  br i1 %needRightCall, label %right.call, label %right.skip

right.call:
  call void @quick_sort(i32* %arr, i32 %i.cur2, i32 %r.phi)
  br label %right.cont

right.skip:
  br label %right.cont

right.cont:
  br label %after.recurse

after.recurse:
  %l.merge = phi i32 [ %i.cur2, %left.cont ], [ %l.phi, %right.cont ]
  %r.merge = phi i32 [ %r.phi, %left.cont ], [ %j.cur2, %right.cont ]
  br label %while.check

ret:
  ret void
}