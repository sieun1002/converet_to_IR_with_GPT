; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort on a signed 32-bit int array over inclusive index range [lo, hi] (confidence=0.95). Evidence: median pivot, signed comparisons, swap, recursion on subranges with tail-call elimination.
; Preconditions: %a points to an array of i32; 0 <= lo <= hi within bounds of %a.
; Postconditions: Elements in %a[lo..hi] are sorted ascending using signed 32-bit ordering.

; Only the needed extern declarations:
; (none)

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %outer.latch ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %outer.latch ]
  %cmp = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp, label %partition.init, label %exit

partition.init:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.loop

partition.loop:
  %i.start = phi i64 [ %lo.cur, %partition.init ], [ %i.next, %do.swap ]
  %j.start = phi i64 [ %hi.cur, %partition.init ], [ %j.next, %do.swap ]
  br label %scan.i

scan.i:
  %i.scan = phi i64 [ %i.start, %partition.loop ], [ %i.scan.inc, %scan.i.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.scan
  %i.val = load i32, i32* %i.ptr, align 4
  %cond_i = icmp slt i32 %i.val, %pivot
  br i1 %cond_i, label %scan.i.inc, label %after.scan.i

scan.i.inc:
  %i.scan.inc = add i64 %i.scan, 1
  br label %scan.i

after.scan.i:
  br label %scan.j

scan.j:
  %j.scan = phi i64 [ %j.start, %partition.loop ], [ %j.scan.dec, %scan.j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.scan
  %j.val = load i32, i32* %j.ptr, align 4
  %cond_j = icmp sgt i32 %j.val, %pivot
  br i1 %cond_j, label %scan.j.dec, label %after.scans

scan.j.dec:
  %j.scan.dec = add i64 %j.scan, -1
  br label %scan.j

after.scans:
  %cmp_ij = icmp sle i64 %i.scan, %j.scan
  br i1 %cmp_ij, label %do.swap, label %partition.done

do.swap:
  %pi.ptr2 = getelementptr inbounds i32, i32* %a, i64 %i.scan
  %pj.ptr2 = getelementptr inbounds i32, i32* %a, i64 %j.scan
  %ai.sw = load i32, i32* %pi.ptr2, align 4
  %aj.sw = load i32, i32* %pj.ptr2, align 4
  store i32 %aj.sw, i32* %pi.ptr2, align 4
  store i32 %ai.sw, i32* %pj.ptr2, align 4
  %i.next = add i64 %i.scan, 1
  %j.next = add i64 %j.scan, -1
  br label %partition.loop

partition.done:
  %left_len = sub i64 %j.scan, %lo.cur
  %right_len = sub i64 %hi.cur, %i.scan
  %left_smaller = icmp slt i64 %left_len, %right_len
  br i1 %left_smaller, label %recurse.left, label %recurse.right

recurse.left:
  %need.left = icmp slt i64 %lo.cur, %j.scan
  br i1 %need.left, label %do.left, label %skip.left

do.left:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %j.scan)
  br label %skip.left

skip.left:
  %lo.next.left = %i.scan
  %hi.next.left = %hi.cur
  br label %outer.latch

recurse.right:
  %need.right = icmp slt i64 %i.scan, %hi.cur
  br i1 %need.right, label %do.right, label %skip.right

do.right:
  call void @quick_sort(i32* %a, i64 %i.scan, i64 %hi.cur)
  br label %skip.right

skip.right:
  %lo.next.right = %lo.cur
  %hi.next.right = %j.scan
  br label %outer.latch

outer.latch:
  %lo.next = phi i64 [ %lo.next.left, %skip.left ], [ %lo.next.right, %skip.right ]
  %hi.next = phi i64 [ %hi.next.left, %skip.left ], [ %hi.next.right, %skip.right ]
  br label %outer.cond

exit:
  ret void
}