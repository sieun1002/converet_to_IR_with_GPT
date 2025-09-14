; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heapsort of a signed 32-bit int array in ascending order (confidence=0.95). Evidence: child index math 2*i+1, sift-down loops, end pointer shrink with swaps; signed comparisons for values.
; Preconditions: If n > 0 then a points to at least n 32-bit elements.
; Postconditions: The first n elements at a are sorted in nondecreasing order.

define dso_local void @heap_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %build.header

build.header:
  %start.init = lshr i64 %n, 1
  br label %build.check

build.check:
  %start.cur = phi i64 [ %start.init, %build.header ], [ %start.next, %build.afterSift ]
  %has_more = icmp ne i64 %start.cur, 0
  br i1 %has_more, label %build.predec, label %sort.init

build.predec:
  %start.dec = add i64 %start.cur, -1
  br label %sift.header

sift.header:
  %i.cur = phi i64 [ %start.dec, %build.predec ], [ %child.idx, %sift.swapDone ]
  %left.mul = shl i64 %i.cur, 1
  %left = add i64 %left.mul, 1
  %left.ge.n = icmp uge i64 %left, %n
  br i1 %left.ge.n, label %build.afterSift, label %sift.chooseChild

sift.chooseChild:
  %right = add i64 %left, 1
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %sift.compareChildren, label %sift.childIsLeft

sift.compareChildren:
  %a.right.ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %a.right = load i32, i32* %a.right.ptr, align 4
  %a.left.ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %a.left = load i32, i32* %a.left.ptr, align 4
  %right.gt.left = icmp sgt i32 %a.right, %a.left
  %child.idx = select i1 %right.gt.left, i64 %right, i64 %left
  br label %sift.compareParent

sift.childIsLeft:
  br label %sift.compareParent

sift.compareParent:
  %child.sel = phi i64 [ %child.idx, %sift.compareChildren ], [ %left, %sift.childIsLeft ]
  %a.i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.cur
  %a.i = load i32, i32* %a.i.ptr, align 4
  %a.child.ptr = getelementptr inbounds i32, i32* %a, i64 %child.sel
  %a.child = load i32, i32* %a.child.ptr, align 4
  %ge = icmp sge i32 %a.i, %a.child
  br i1 %ge, label %build.afterSift, label %sift.swap

sift.swap:
  store i32 %a.child, i32* %a.i.ptr, align 4
  store i32 %a.i, i32* %a.child.ptr, align 4
  %child.idx = phi i64 [ %child.sel, %sift.swap ]
  br label %sift.swapDone

sift.swapDone:
  br label %sift.header

build.afterSift:
  %start.next = add i64 %start.dec, 0
  br label %build.check

sort.init:
  %end.init = add i64 %n, -1
  br label %sort.loopHeader

sort.loopHeader:
  %end.cur = phi i64 [ %end.init, %sort.init ], [ %end.next, %sort.afterSift ]
  %condEnd = icmp ne i64 %end.cur, 0
  br i1 %condEnd, label %sort.body, label %ret

sort.body:
  %a0 = load i32, i32* %a, align 4
  %a.end.ptr = getelementptr inbounds i32, i32* %a, i64 %end.cur
  %a.end = load i32, i32* %a.end.ptr, align 4
  store i32 %a.end, i32* %a, align 4
  store i32 %a0, i32* %a.end.ptr, align 4
  br label %sift2.header

sift2.header:
  %i2.cur = phi i64 [ 0, %sort.body ], [ %child2.idx, %sift2.swapDone ]
  %left2.mul = shl i64 %i2.cur, 1
  %left2 = add i64 %left2.mul, 1
  %left2.ge.end = icmp uge i64 %left2, %end.cur
  br i1 %left2.ge.end, label %sort.afterSift, label %sift2.chooseChild

sift2.chooseChild:
  %right2 = add i64 %left2, 1
  %right2.lt.end = icmp ult i64 %right2, %end.cur
  br i1 %right2.lt.end, label %sift2.compareChildren, label %sift2.childIsLeft

sift2.compareChildren:
  %a.right2.ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %a.right2 = load i32, i32* %a.right2.ptr, align 4
  %a.left2.ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %a.left2 = load i32, i32* %a.left2.ptr, align 4
  %right2.gt.left2 = icmp sgt i32 %a.right2, %a.left2
  %child2.idx = select i1 %right2.gt.left2, i64 %right2, i64 %left2
  br label %sift2.compareParent

sift2.childIsLeft:
  br label %sift2.compareParent

sift2.compareParent:
  %child2.sel = phi i64 [ %child2.idx, %sift2.compareChildren ], [ %left2, %sift2.childIsLeft ]
  %a.i2.ptr = getelementptr inbounds i32, i32* %a, i64 %i2.cur
  %a.i2 = load i32, i32* %a.i2.ptr, align 4
  %a.child2.ptr = getelementptr inbounds i32, i32* %a, i64 %child2.sel
  %a.child2 = load i32, i32* %a.child2.ptr, align 4
  %ge2 = icmp sge i32 %a.i2, %a.child2
  br i1 %ge2, label %sort.afterSift, label %sift2.swap

sift2.swap:
  store i32 %a.child2, i32* %a.i2.ptr, align 4
  store i32 %a.i2, i32* %a.child2.ptr, align 4
  %child2.idx = phi i64 [ %child2.sel, %sift2.swap ]
  br label %sift2.swapDone

sift2.swapDone:
  br label %sift2.header

sort.afterSift:
  %end.next = add i64 %end.cur, -1
  br label %sort.loopHeader

ret:
  ret void
}