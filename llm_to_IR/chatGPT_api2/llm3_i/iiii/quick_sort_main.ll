; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1240
; Intent: In-place quicksort on i32 array segment [lo..hi], tail-recursive optimization (confidence=0.95). Evidence: mid-pivot selection, bidirectional partition with swaps
; Preconditions: a points to an array of at least hi+1 32-bit elements; indices lo, hi are valid (0 <= lo,hi) and hi may be < lo (no-op). Segment is inclusive [lo..hi].
; Postconditions: a[lo..hi] is sorted in nondecreasing order.

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp0 = icmp sge i64 %lo, %hi
  br i1 %cmp0, label %ret, label %outer.loop

outer.loop:                                           ; loop over (lo,hi) with tail recursion elimination
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cond = icmp sgt i64 %hi.cur, %lo.cur
  br i1 %cond, label %part.setup, label %ret

part.setup:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = ashr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  %i.init = %lo.cur
  %j.init = %hi.cur
  %next.init = add i64 %lo.cur, 1
  br label %part.top

part.top:
  %i = phi i64 [ %i.init, %part.setup ], [ %i.inc2, %incI ], [ %i.next2, %swap.cont ]
  %j = phi i64 [ %j.init, %part.setup ], [ %j, %incI ], [ %j.new2, %swap.cont ]
  %next = phi i64 [ %next.init, %part.setup ], [ %next.inc2, %incI ], [ %next2, %swap.cont ]
  %ptr.i = getelementptr inbounds i32, i32* %a, i64 %i
  %vali = load i32, i32* %ptr.i, align 4
  %ptr.j0 = getelementptr inbounds i32, i32* %a, i64 %j
  %valj0 = load i32, i32* %ptr.j0, align 4
  %cmp_i_lt_pivot = icmp slt i32 %vali, %pivot
  br i1 %cmp_i_lt_pivot, label %incI, label %maybe.decj

incI:
  %i.inc = add i64 %i, 1
  %i.inc2 = %i.inc
  %next.inc = add i64 %next, 1
  %next.inc2 = %next.inc
  br label %part.top

maybe.decj:
  %cmp_pivot_ge_valj0 = icmp sge i32 %pivot, %valj0
  br i1 %cmp_pivot_ge_valj0, label %check, label %decj.start

decj.start:
  %j1 = add i64 %j, -1
  br label %decj.loop

decj.loop:
  %j.cur = phi i64 [ %j1, %decj.start ], [ %j.next, %decj.loop ]
  %ptr.j = getelementptr inbounds i32, i32* %a, i64 %j.cur
  %valj = load i32, i32* %ptr.j, align 4
  %cmp_valj_gt_pivot = icmp sgt i32 %valj, %pivot
  %j.next = add i64 %j.cur, -1
  br i1 %cmp_valj_gt_pivot, label %decj.loop, label %decj.exit

decj.exit:
  br label %check

check:
  %j.ch = phi i64 [ %j, %maybe.decj ], [ %j.cur, %decj.exit ]
  %ptr.j.ch = phi i32* [ %ptr.j0, %maybe.decj ], [ %ptr.j, %decj.exit ]
  %valj.ch = phi i32 [ %valj0, %maybe.decj ], [ %valj, %decj.exit ]
  %cmp_i_le_j = icmp sle i64 %i, %j.ch
  br i1 %cmp_i_le_j, label %do.swap, label %afterpart

do.swap:
  %j.new = add i64 %j.ch, -1
  store i32 %valj.ch, i32* %ptr.i, align 4
  store i32 %vali, i32* %ptr.j.ch, align 4
  %cmp_next_gt_jnew = icmp sgt i64 %next, %j.new
  br i1 %cmp_next_gt_jnew, label %afterpart.swap, label %swap.cont

swap.cont:
  %i.next = add i64 %i, 1
  %i.next2 = %i.next
  %next.next = add i64 %next, 1
  %next2 = %next.next
  %j.new2 = %j.new
  br label %part.top

afterpart.swap:
  br label %afterpart

afterpart:
  %iStartRight = phi i64 [ %next, %afterpart.swap ], [ %i, %check ]
  %j.part = phi i64 [ %j.new, %afterpart.swap ], [ %j.ch, %check ]
  %leftSize = sub i64 %j.part, %lo.cur
  %rightSize = sub i64 %hi.cur, %iStartRight
  %cmp_left_ge_right = icmp sge i64 %leftSize, %rightSize
  br i1 %cmp_left_ge_right, label %right.case, label %left.case

right.case:
  %cond_right_nonempty = icmp slt i64 %iStartRight, %hi.cur
  br i1 %cond_right_nonempty, label %right.recurse, label %right.skip

right.recurse:
  call void @quick_sort(i32* %a, i64 %iStartRight, i64 %hi.cur)
  br label %right.skip

right.skip:
  %lo.next.r = %lo.cur
  %hi.next.r = %j.part
  br label %outer.cont

left.case:
  %cond_left_nonempty = icmp slt i64 %lo.cur, %j.part
  br i1 %cond_left_nonempty, label %left.recurse, label %left.skip

left.recurse:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %j.part)
  br label %left.skip

left.skip:
  %lo.next.l = %iStartRight
  %hi.next.l = %hi.cur
  br label %outer.cont

outer.cont:
  %lo.next = phi i64 [ %lo.next.r, %right.skip ], [ %lo.next.l, %left.skip ]
  %hi.next = phi i64 [ %hi.next.r, %right.skip ], [ %hi.next.l, %left.skip ]
  br label %outer.loop

ret:
  ret void
}