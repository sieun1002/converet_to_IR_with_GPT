; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort of i32 array in index range [low, high], tail-recursing on smaller partition (confidence=0.98). Evidence: pivot from middle index with *4 scaling; two-pointer partition loops and recursive calls on subranges.
; Preconditions: base points to at least (high+1) i32 elements; indices are signed i64 with low <= high for non-empty range.
; Postconditions: Elements in [low, high] are sorted in non-decreasing order.

define dso_local void @quick_sort(i32* %base, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                          ; loop over remaining range
  %low.cur = phi i64 [ %low, %entry ], [ %low.next.phi, %loop.back ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.next.phi, %loop.back ]
  %cmp.outer = icmp slt i64 %low.cur, %high.cur
  br i1 %cmp.outer, label %outer.body, label %outer.end

outer.body:
  %i0 = %low.cur
  %j0 = %high.cur
  %diff = sub i64 %high.cur, %low.cur
  %sign = lshr i64 %diff, 63
  %tmp = add i64 %diff, %sign
  %midoff = ashr i64 %tmp, 1
  %mid = add i64 %low.cur, %midoff
  %mid.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %part.header

part.header:
  %i.phi = phi i64 [ %i0, %outer.body ], [ %i.next2, %swap.done ]
  %j.phi = phi i64 [ %j0, %outer.body ], [ %j.next2, %swap.done ]
  br label %left.scan

left.scan:
  %i.cur = phi i64 [ %i.phi, %part.header ], [ %i.inc, %left.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.cur
  %ival = load i32, i32* %i.ptr, align 4
  %cmp.left = icmp slt i32 %ival, %pivot
  br i1 %cmp.left, label %left.inc, label %left.done

left.inc:
  %i.inc = add i64 %i.cur, 1
  br label %left.scan

left.done:
  br label %right.scan

right.scan:
  %j.cur = phi i64 [ %j.phi, %left.done ], [ %j.dec, %right.inc ]
  %i.keep = phi i64 [ %i.cur, %left.done ], [ %i.keep, %right.inc ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %jval = load i32, i32* %j.ptr, align 4
  %cmp.right = icmp sgt i32 %jval, %pivot
  br i1 %cmp.right, label %right.inc, label %after.scans

right.inc:
  %j.dec = add i64 %j.cur, -1
  br label %right.scan

after.scans:
  %i.after = phi i64 [ %i.keep, %right.scan ]
  %j.after = phi i64 [ %j.cur, %right.scan ]
  %cmp.ij = icmp sle i64 %i.after, %j.after
  br i1 %cmp.ij, label %do.swap, label %break

do.swap:
  %i.ptr2 = getelementptr inbounds i32, i32* %base, i64 %i.after
  %t = load i32, i32* %i.ptr2, align 4
  %j.ptr2 = getelementptr inbounds i32, i32* %base, i64 %j.after
  %vj = load i32, i32* %j.ptr2, align 4
  store i32 %vj, i32* %i.ptr2, align 4
  store i32 %t, i32* %j.ptr2, align 4
  %i.next2 = add i64 %i.after, 1
  %j.next2 = add i64 %j.after, -1
  br label %swap.done

swap.done:
  br label %part.header

break:
  %i.fin = phi i64 [ %i.after, %after.scans ]
  %j.fin = phi i64 [ %j.after, %after.scans ]
  %left.size = sub i64 %j.fin, %low.cur
  %right.size = sub i64 %high.cur, %i.fin
  %choose.right = icmp sge i64 %left.size, %right.size
  br i1 %choose.right, label %right.path, label %left.path

left.path:
  %need.left = icmp slt i64 %low.cur, %j.fin
  br i1 %need.left, label %left.call, label %left.cont

left.call:
  call void @quick_sort(i32* %base, i64 %low.cur, i64 %j.fin)
  br label %left.cont

left.cont:
  %low.next = %i.fin
  %high.next = %high.cur
  br label %loop.back

right.path:
  %need.right = icmp slt i64 %i.fin, %high.cur
  br i1 %need.right, label %right.call, label %right.cont

right.call:
  call void @quick_sort(i32* %base, i64 %i.fin, i64 %high.cur)
  br label %right.cont

right.cont:
  %low.next2 = %low.cur
  %high.next2 = %j.fin
  br label %loop.back

loop.back:
  %low.next.phi = phi i64 [ %low.next, %left.cont ], [ %low.next2, %right.cont ]
  %high.next.phi = phi i64 [ %high.next, %left.cont ], [ %high.next2, %right.cont ]
  br label %outer.cond

outer.end:
  ret void
}