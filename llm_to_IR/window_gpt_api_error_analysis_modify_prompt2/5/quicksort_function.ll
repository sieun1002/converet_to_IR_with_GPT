; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  br label %outer.cond

outer.cond:
  %l = phi i32 [ %left, %entry ], [ %i.end, %after.left ], [ %l.pass, %after.right ]
  %r = phi i32 [ %right, %entry ], [ %r.pass, %after.left ], [ %j.end, %after.right ]
  %cmp.lr = icmp slt i32 %l, %r
  br i1 %cmp.lr, label %part.init, label %ret

part.init:
  %i.start = add i32 %l, 0
  %j.start = add i32 %r, 0
  %diff = sub i32 %r, %l
  %sb = lshr i32 %diff, 31
  %diff2 = add i32 %diff, %sb
  %half = ashr i32 %diff2, 1
  %mid = add i32 %l, %half
  %mid64 = sext i32 %mid to i64
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %scan.i

scan.i:
  %i.cur = phi i32 [ %i.start, %part.init ], [ %i.inc, %incr.i ], [ %i.afterSwap, %do.swap ]
  %j.cur = phi i32 [ %j.start, %part.init ], [ %j.pass1, %incr.i ], [ %j.afterSwap, %do.swap ]
  %i64 = sext i32 %i.cur to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.pivot.gt = icmp sgt i32 %pivot, %val.i
  br i1 %cmp.pivot.gt, label %incr.i, label %scan.j

incr.i:
  %i.inc = add i32 %i.cur, 1
  %j.pass1 = add i32 %j.cur, 0
  br label %scan.i

scan.j:
  %i.cur2 = phi i32 [ %i.cur, %scan.i ], [ %i.pass2, %decr.j ]
  %j.cur2 = phi i32 [ %j.cur, %scan.i ], [ %j.dec, %decr.j ]
  %j64 = sext i32 %j.cur2 to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.pivot.lt = icmp slt i32 %pivot, %val.j
  br i1 %cmp.pivot.lt, label %decr.j, label %check.swap

decr.j:
  %j.dec = add i32 %j.cur2, -1
  %i.pass2 = add i32 %i.cur2, 0
  br label %scan.j

check.swap:
  %cmp.ij = icmp sle i32 %i.cur2, %j.cur2
  br i1 %cmp.ij, label %do.swap, label %part.after

do.swap:
  %i.idx64 = sext i32 %i.cur2 to i64
  %j.idx64 = sext i32 %j.cur2 to i64
  %ptr.i2 = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %ptr.j2 = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %val.i2 = load i32, i32* %ptr.i2, align 4
  %val.j2 = load i32, i32* %ptr.j2, align 4
  store i32 %val.j2, i32* %ptr.i2, align 4
  store i32 %val.i2, i32* %ptr.j2, align 4
  %i.afterSwap = add i32 %i.cur2, 1
  %j.afterSwap = add i32 %j.cur2, -1
  br label %scan.i

part.after:
  %left.size = sub i32 %j.cur2, %l
  %right.size = sub i32 %r, %i.cur2
  %cmp.left.ge.right = icmp sge i32 %left.size, %right.size
  br i1 %cmp.left.ge.right, label %recurse.right, label %recurse.left

recurse.left:
  %cond.left = icmp slt i32 %l, %j.cur2
  br i1 %cond.left, label %call.left, label %after.left

call.left:
  call void @quick_sort(i32* %arr, i32 %l, i32 %j.cur2)
  br label %after.left

after.left:
  %r.pass = add i32 %r, 0
  %i.end = add i32 %i.cur2, 0
  br label %outer.cond

recurse.right:
  %cond.right = icmp slt i32 %i.cur2, %r
  br i1 %cond.right, label %call.right, label %after.right

call.right:
  call void @quick_sort(i32* %arr, i32 %i.cur2, i32 %r)
  br label %after.right

after.right:
  %l.pass = add i32 %l, 0
  %j.end = add i32 %j.cur2, 0
  br label %outer.cond

ret:
  ret void
}