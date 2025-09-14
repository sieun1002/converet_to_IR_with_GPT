; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort (signed i32) over inclusive [lo, hi] (confidence=0.94). Evidence: midpoint pivot, two-pointer partition with signed compares, recurse on smaller side and loop on larger.
; Preconditions: lo and hi are valid signed 64-bit indices into arr (lo <= hi).
; Postconditions: arr[lo0..hi0] sorted ascending by signed i32.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next.left, %left.cont ], [ %lo.next.right, %right.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next.left, %left.cont ], [ %hi.next.right, %right.cont ]
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %partition.init, label %end

partition.init:
  ; mid = lo + ((hi - lo + ((hi - lo) >> 63)) >> 1)
  %diff = sub i64 %hi.cur, %lo.cur
  %sign = ashr i64 %diff, 63
  %adj = add i64 %diff, %sign
  %half = ashr i64 %adj, 1
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.top

partition.top:
  %i.cur2 = phi i64 [ %lo.cur, %partition.init ], [ %i.after.swap, %do.swap ]
  %j.cur2 = phi i64 [ %hi.cur, %partition.init ], [ %j.after.swap, %do.swap ]
  br label %inc.loop.header

inc.loop.header:
  %i.scan = phi i64 [ %i.cur2, %partition.top ], [ %i.scan.next, %inc.loop.header ]
  %j.const = phi i64 [ %j.cur2, %partition.top ], [ %j.const, %inc.loop.header ]
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.scan
  %val.i = load i32, i32* %ptr.i, align 4
  %cond.i = icmp slt i32 %val.i, %pivot
  %i.scan.next = add i64 %i.scan, 1
  br i1 %cond.i, label %inc.loop.header, label %dec.loop.header

dec.loop.header:
  %i.fixed = phi i64 [ %i.scan, %inc.loop.header ], [ %i.fixed, %dec.loop.header ]
  %j.scan = phi i64 [ %j.const, %inc.loop.header ], [ %j.scan.next, %dec.loop.header ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %val.j = load i32, i32* %ptr.j, align 4
  %cond.j = icmp sgt i32 %val.j, %pivot
  %j.scan.next = add i64 %j.scan, -1
  br i1 %cond.j, label %dec.loop.header, label %check.swap

check.swap:
  %cond.le = icmp sle i64 %i.fixed, %j.scan
  br i1 %cond.le, label %do.swap, label %after.partition

do.swap:
  %ptr.i2 = getelementptr inbounds i32, i32* %arr, i64 %i.fixed
  %ptr.j2 = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %a = load i32, i32* %ptr.i2, align 4
  %b = load i32, i32* %ptr.j2, align 4
  store i32 %b, i32* %ptr.i2, align 4
  store i32 %a, i32* %ptr.j2, align 4
  %i.after.swap = add i64 %i.fixed, 1
  %j.after.swap = add i64 %j.scan, -1
  br label %partition.top

after.partition:
  %left.len = sub i64 %j.scan, %lo.cur
  %right.len = sub i64 %hi.cur, %i.fixed
  %left.ge.right = icmp sge i64 %left.len, %right.len
  br i1 %left.ge.right, label %right.rec.check, label %left.rec.check

left.rec.check:
  %cond.left.call = icmp slt i64 %lo.cur, %j.scan
  br i1 %cond.left.call, label %left.call, label %left.cont

left.call:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.scan)
  br label %left.cont

left.cont:
  %lo.next.left = %i.fixed
  %hi.next.left = %hi.cur
  br label %outer.cond

right.rec.check:
  %cond.right.call = icmp slt i64 %i.fixed, %hi.cur
  br i1 %cond.right.call, label %right.call, label %right.cont

right.call:
  call void @quick_sort(i32* %arr, i64 %i.fixed, i64 %hi.cur)
  br label %right.cont

right.cont:
  %lo.next.right = %lo.cur
  %hi.next.right = %j.scan
  br label %outer.cond

end:
  ret void
}