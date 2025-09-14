; ModuleID = 'quick_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %while.head

while.head:
  %lo.ph = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.ph = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.lohi = icmp slt i64 %lo.ph, %hi.ph
  br i1 %cmp.lohi, label %partition.init, label %exit

partition.init:
  %i.init = add nsw i64 %lo.ph, 0
  %j.init = add nsw i64 %hi.ph, 0
  %diff = sub nsw i64 %hi.ph, %lo.ph
  %half = ashr i64 %diff, 1
  %mid = add nsw i64 %lo.ph, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.i

scan.i:
  %i.cur = phi i64 [ %i.init, %partition.init ], [ %i.next, %scan.i.inc ], [ %i.after, %resume.inner ]
  %j.start = phi i64 [ %j.init, %partition.init ], [ %j.start, %scan.i.inc ], [ %j.after, %resume.inner ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.pivot.gt.i = icmp sgt i32 %pivot, %i.val
  br i1 %cmp.pivot.gt.i, label %scan.i.inc, label %scan.j.entry

scan.i.inc:
  %i.next = add nsw i64 %i.cur, 1
  br label %scan.i

scan.j.entry:
  br label %scan.j

scan.j:
  %j.cur = phi i64 [ %j.start, %scan.j.entry ], [ %j.next, %scan.j.dec ]
  %i.hold = phi i64 [ %i.cur, %scan.j.entry ], [ %i.hold, %scan.j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.pivot.lt.j = icmp slt i32 %pivot, %j.val
  br i1 %cmp.pivot.lt.j, label %scan.j.dec, label %check

scan.j.dec:
  %j.next = add nsw i64 %j.cur, -1
  br label %scan.j

check:
  %cmp.i.le.j = icmp sle i64 %i.hold, %j.cur
  br i1 %cmp.i.le.j, label %do.swap, label %after.inner

do.swap:
  %i.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.hold
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %tmp.i.load = load i32, i32* %i.ptr2, align 4
  %tmp.j.load = load i32, i32* %j.ptr2, align 4
  store i32 %tmp.j.load, i32* %i.ptr2, align 4
  store i32 %tmp.i.load, i32* %j.ptr2, align 4
  %i.after = add nsw i64 %i.hold, 1
  %j.after = add nsw i64 %j.cur, -1
  br label %resume.inner

resume.inner:
  br label %scan.i

after.inner:
  %left.size = sub nsw i64 %j.cur, %lo.ph
  %right.size = sub nsw i64 %hi.ph, %i.hold
  %cmp.left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %cmp.left.ge.right, label %right.first, label %left.first

left.first:
  %condL = icmp slt i64 %lo.ph, %j.cur
  br i1 %condL, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i64 %lo.ph, i64 %j.cur)
  br label %skip.left

skip.left:
  %lo.next.left = add i64 %i.hold, 0
  br label %outer.cont

right.first:
  %condR = icmp slt i64 %i.hold, %hi.ph
  br i1 %condR, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i64 %i.hold, i64 %hi.ph)
  br label %skip.right

skip.right:
  br label %outer.cont

outer.cont:
  %lo.next = phi i64 [ %lo.next.left, %skip.left ], [ %lo.ph, %skip.right ]
  %hi.next = phi i64 [ %hi.ph, %skip.left ], [ %j.cur, %skip.right ]
  br label %while.head

exit:
  ret void
}