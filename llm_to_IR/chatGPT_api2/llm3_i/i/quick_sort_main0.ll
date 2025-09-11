; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1240
; Intent: In-place quicksort on a contiguous i32 array between inclusive indices [lo, hi] (confidence=0.95). Evidence: median pivot ((lo+hi)/2), signed compares and swaps, recursive calls on subranges.
; Preconditions: %a points to at least (max(hi,lo)+1) i32 elements; indices are valid (0-based). Sorting is by signed i32 order.
; Postconditions: Elements in [%lo, %hi] are sorted in non-decreasing (signed) order.

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer

outer:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.tail, %tail_cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.tail, %tail_cont ]
  %cmp_done = icmp sge i64 %lo.cur, %hi.cur
  br i1 %cmp_done, label %ret, label %prepare

prepare:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = ashr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %mid.ptr
  %i.init = add i64 %lo.cur, 0
  %j.init = add i64 %hi.cur, 0
  br label %part_loop

part_loop:
  %i.part = phi i64 [ %i.init, %prepare ], [ %i.after.ph, %cont_after_swap ]
  %j.part = phi i64 [ %j.init, %prepare ], [ %j.after.ph, %cont_after_swap ]
  br label %i_loop

i_loop:
  %i.curr = phi i64 [ %i.part, %part_loop ], [ %i.next, %i_incr ]
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.curr
  %val.i = load i32, i32* %i.ptr
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %i_incr, label %j_loop

i_incr:
  %i.next = add i64 %i.curr, 1
  br label %i_loop

j_loop:
  %j.curr = phi i64 [ %j.part, %i_loop ], [ %j.next, %j_decr ]
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.curr
  %val.j = load i32, i32* %j.ptr
  %cmp.j = icmp slt i32 %pivot, %val.j
  br i1 %cmp.j, label %j_decr, label %check

j_decr:
  %j.next = add i64 %j.curr, -1
  br label %j_loop

check:
  %i_gt_j = icmp sgt i64 %i.curr, %j.curr
  br i1 %i_gt_j, label %break, label %swap_block

swap_block:
  store i32 %val.j, i32* %i.ptr
  store i32 %val.i, i32* %j.ptr
  %i.after = add i64 %i.curr, 1
  %j.after = add i64 %j.curr, -1
  br label %cont_after_swap

cont_after_swap:
  %i.after.ph = phi i64 [ %i.after, %swap_block ]
  %j.after.ph = phi i64 [ %j.after, %swap_block ]
  br label %part_loop

break:
  %left.len = sub i64 %j.curr, %lo.cur
  %right.len = sub i64 %hi.cur, %i.curr
  %left_smaller = icmp slt i64 %left.len, %right.len
  br i1 %left_smaller, label %left_first, label %right_first

left_first:
  %left_nonempty = icmp slt i64 %lo.cur, %j.curr
  br i1 %left_nonempty, label %do_left_call, label %skip_left_call

do_left_call:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %j.curr)
  br label %skip_left_call

skip_left_call:
  %lo.tail.l = add i64 %i.curr, 0
  %hi.tail.l = add i64 %hi.cur, 0
  br label %tail_cont

right_first:
  %right_nonempty = icmp slt i64 %i.curr, %hi.cur
  br i1 %right_nonempty, label %do_right_call, label %skip_right_call

do_right_call:
  call void @quick_sort(i32* %a, i64 %i.curr, i64 %hi.cur)
  br label %skip_right_call

skip_right_call:
  %lo.tail.r = add i64 %lo.cur, 0
  %hi.tail.r = add i64 %j.curr, 0
  br label %tail_cont

tail_cont:
  %lo.tail = phi i64 [ %lo.tail.l, %skip_left_call ], [ %lo.tail.r, %skip_right_call ]
  %hi.tail = phi i64 [ %hi.tail.l, %skip_left_call ], [ %hi.tail.r, %skip_right_call ]
  br label %outer

ret:
  ret void
}