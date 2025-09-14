; Reconstructed LLVM 14 IR for quick_sort(int* base, long left, long right)
; Uses typed pointers (no opaque ptr), strictly typed ops, correct PHIs, and no plain assignments.

define void @quick_sort(i32* %base, i64 %left, i64 %right) {
entry:
  br label %while.cond

while.cond:
  %l.cur = phi i64 [ %left, %entry ], [ %l.next.left, %left.nocall ], [ %l.next.right, %right.nocall ]
  %r.cur = phi i64 [ %right, %entry ], [ %r.next.left, %left.nocall ], [ %r.next.right, %right.nocall ]
  %cmp.lr = icmp slt i64 %l.cur, %r.cur
  br i1 %cmp.lr, label %part.entry, label %ret

part.entry:
  %diff = sub i64 %r.cur, %l.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %l.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.loop.header

part.loop.header:
  %i.ph = phi i64 [ %l.cur, %part.entry ], [ %i.inc2, %swap.then ]
  %j.ph = phi i64 [ %r.cur, %part.entry ], [ %j.dec2, %swap.then ]
  br label %scan.i

scan.i:
  %i.scan = phi i64 [ %i.ph, %part.loop.header ], [ %i.inc, %scan.i ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.scan
  %i.val = load i32, i32* %i.ptr, align 4
  %cmpI = icmp sgt i32 %pivot, %i.val
  %i.inc = add i64 %i.scan, 1
  br i1 %cmpI, label %scan.i, label %scan.j.entry

scan.j.entry:
  br label %scan.j

scan.j:
  %j.scan = phi i64 [ %j.ph, %scan.j.entry ], [ %j.dec, %scan.j ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.scan
  %j.val = load i32, i32* %j.ptr, align 4
  %cmpJ = icmp slt i32 %pivot, %j.val
  %j.dec = add i64 %j.scan, -1
  br i1 %cmpJ, label %scan.j, label %check

check:
  %cmpIJ = icmp sle i64 %i.scan, %j.scan
  br i1 %cmpIJ, label %swap.then, label %after.partition

swap.then:
  %ptrI2 = getelementptr inbounds i32, i32* %base, i64 %i.scan
  %valI2 = load i32, i32* %ptrI2, align 4
  %ptrJ2 = getelementptr inbounds i32, i32* %base, i64 %j.scan
  %valJ2 = load i32, i32* %ptrJ2, align 4
  store i32 %valJ2, i32* %ptrI2, align 4
  store i32 %valI2, i32* %ptrJ2, align 4
  %i.inc2 = add i64 %i.scan, 1
  %j.dec2 = add i64 %j.scan, -1
  br label %part.loop.header

after.partition:
  %sizeL = sub i64 %j.scan, %l.cur
  %sizeR = sub i64 %r.cur, %i.scan
  %leftSmaller = icmp slt i64 %sizeL, %sizeR
  br i1 %leftSmaller, label %left.branch, label %right.branch

left.branch:
  %doLeft = icmp slt i64 %l.cur, %j.scan
  br i1 %doLeft, label %left.call, label %left.nocall

left.call:
  call void @quick_sort(i32* %base, i64 %l.cur, i64 %j.scan)
  br label %left.nocall

left.nocall:
  %l.next.left = add i64 %i.scan, 0
  %r.next.left = add i64 %r.cur, 0
  br label %while.cond

right.branch:
  %doRight = icmp slt i64 %i.scan, %r.cur
  br i1 %doRight, label %right.call, label %right.nocall

right.call:
  call void @quick_sort(i32* %base, i64 %i.scan, i64 %r.cur)
  br label %right.nocall

right.nocall:
  %l.next.right = add i64 %l.cur, 0
  %r.next.right = add i64 %j.scan, 0
  br label %while.cond

ret:
  ret void
}