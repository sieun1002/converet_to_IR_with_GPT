; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1240
; Intent: In-place quicksort on 32-bit integer array using tail-recursive optimization (confidence=0.95). Evidence: pivot at mid index; compare/swap partition; recurse on smaller side first.
; Preconditions: %a is non-null; indices %lo and %hi are inclusive bounds within the same array.
; Postconditions: Elements in [%lo..%hi] sorted in non-decreasing (signed 32-bit) order.

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp = icmp sge i64 %lo, %hi
  br i1 %cmp, label %ret, label %outer.init

outer.init:
  br label %outer.loop

outer.loop:
  %lo.cur = phi i64 [ %lo, %outer.init ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i64 [ %hi, %outer.init ], [ %hi.next, %outer.cont ]
  %outer.cond = icmp slt i64 %lo.cur, %hi.cur
  br i1 %outer.cond, label %pivot, label %ret

pivot:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = ashr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot.val = load i32, i32* %mid.ptr, align 4
  br label %part.loop

part.loop:
  %i = phi i64 [ %lo.cur, %pivot ], [ %i.next, %swap_or_inc_cont ]
  %j = phi i64 [ %hi.cur, %pivot ], [ %j.next, %swap_or_inc_cont ]
  %ai.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %ai = load i32, i32* %ai.ptr, align 4
  %cmp_ai = icmp slt i32 %ai, %pivot.val
  br i1 %cmp_ai, label %inc_i, label %decj.loop

inc_i:
  %i.inc = add i64 %i, 1
  br label %swap_or_inc_cont

decj.loop:
  %aj.ptr = getelementptr inbounds i32, i32* %a, i64 %j
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp_p_lt_aj = icmp slt i32 %pivot.val, %aj
  br i1 %cmp_p_lt_aj, label %decj.decrement, label %after_decj

decj.decrement:
  %j.dec = add i64 %j, -1
  br label %decj.loop

after_decj:
  %cmp_i_gt_j = icmp sgt i64 %i, %j
  br i1 %cmp_i_gt_j, label %split, label %do_swap

do_swap:
  store i32 %aj, i32* %ai.ptr, align 4
  store i32 %ai, i32* %aj.ptr, align 4
  %i.sw = add i64 %i, 1
  %j.sw = add i64 %j, -1
  br label %swap_or_inc_cont

swap_or_inc_cont:
  %i.next = phi i64 [ %i.inc, %inc_i ], [ %i.sw, %do_swap ]
  %j.next = phi i64 [ %j, %inc_i ], [ %j.sw, %do_swap ]
  br label %part.loop

split:
  %left_len = sub i64 %j, %lo.cur
  %right_len = sub i64 %hi.cur, %i
  %cmp_left_lt_right = icmp slt i64 %left_len, %right_len
  br i1 %cmp_left_lt_right, label %recurse_left_check, label %recurse_right_check

recurse_left_check:
  %cmp_lo_lt_j = icmp slt i64 %lo.cur, %j
  br i1 %cmp_lo_lt_j, label %recurse_left, label %left_skip

recurse_left:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %j)
  br label %left_skip

left_skip:
  br label %outer.cont

recurse_right_check:
  %cmp_i_lt_hi = icmp slt i64 %i, %hi.cur
  br i1 %cmp_i_lt_hi, label %recurse_right, label %right_skip

recurse_right:
  call void @quick_sort(i32* %a, i64 %i, i64 %hi.cur)
  br label %right_skip

right_skip:
  br label %outer.cont

outer.cont:
  %lo.next = phi i64 [ %i, %left_skip ], [ %lo.cur, %right_skip ]
  %hi.next = phi i64 [ %hi.cur, %left_skip ], [ %j, %right_skip ]
  br label %outer.loop

ret:
  ret void
}