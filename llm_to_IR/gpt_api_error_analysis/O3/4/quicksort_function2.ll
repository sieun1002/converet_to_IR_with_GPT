target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  %cmp0 = icmp sge i64 %lo, %hi
  br i1 %cmp0, label %ret, label %compute_pivot

compute_pivot:
  %sub = sub nsw i64 %hi, %lo
  %shr = ashr i64 %sub, 1
  %mid = add nsw i64 %lo, %shr
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %outer

outer:
  %i0 = phi i64 [ %lo, %compute_pivot ], [ %i.next, %swap ]
  %j0 = phi i64 [ %hi, %compute_pivot ], [ %j.next, %swap ]
  br label %left.scan

left.scan:
  %i.cur = phi i64 [ %i0, %outer ], [ %i.inc, %left.inc ]
  %l.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %l.val = load i32, i32* %l.ptr, align 4
  %cmp.l = icmp slt i32 %l.val, %pivot
  br i1 %cmp.l, label %left.inc, label %right.init

left.inc:
  %i.inc = add nsw i64 %i.cur, 1
  br label %left.scan

right.init:
  br label %right.scan

right.scan:
  %j.cur = phi i64 [ %j0, %right.init ], [ %j.dec, %right.dec ]
  %i.fix = phi i64 [ %i.cur, %right.init ], [ %i.fix, %right.dec ]
  %r.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %r.val = load i32, i32* %r.ptr, align 4
  %cmp.r = icmp sgt i32 %r.val, %pivot
  br i1 %cmp.r, label %right.dec, label %compare

right.dec:
  %j.dec = add nsw i64 %j.cur, -1
  br label %right.scan

compare:
  %i.fin = phi i64 [ %i.fix, %right.scan ]
  %j.fin = phi i64 [ %j.cur, %right.scan ]
  %cmp.ij = icmp sle i64 %i.fin, %j.fin
  br i1 %cmp.ij, label %swap, label %done

swap:
  %l.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %i.fin
  %r.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %j.fin
  %l.val.swap = load i32, i32* %l.ptr.swap, align 4
  %r.val.swap = load i32, i32* %r.ptr.swap, align 4
  store i32 %r.val.swap, i32* %l.ptr.swap, align 4
  store i32 %l.val.swap, i32* %r.ptr.swap, align 4
  %i.next = add nsw i64 %i.fin, 1
  %j.next = add nsw i64 %j.fin, -1
  br label %outer

done:
  %left.nonempty = icmp slt i64 %lo, %j.fin
  br i1 %left.nonempty, label %recurse.left, label %after.left

recurse.left:
  call void @quick_sort(i32* %arr, i64 %lo, i64 %j.fin)
  br label %after.left

after.left:
  %right.nonempty = icmp slt i64 %i.fin, %hi
  br i1 %right.nonempty, label %recurse.right, label %ret

recurse.right:
  call void @quick_sort(i32* %arr, i64 %i.fin, i64 %hi)
  br label %ret

ret:
  ret void
}