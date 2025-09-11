; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x0000000000001240
; Intent: In-place quicksort on an int32 array using inclusive indices and tail-call elimination (confidence=0.98). Evidence: pivot from middle, two-pointer partition with signed compares (jl/jg), recurse smaller side first.

; Only the necessary external declarations:

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp.pre = icmp sge i64 %lo, %hi
  br i1 %cmp.pre, label %ret, label %outer.pre

outer.pre:
  br label %outer

outer:                                             ; loop over partitions (tail-recursive elimination)
  %l = phi i64 [ %lo, %outer.pre ], [ %l2, %after_partition ]
  %h = phi i64 [ %hi, %outer.pre ], [ %h2, %after_partition ]
  ; compute pivot = arr[(l + h) / 2]
  %diff = sub i64 %h, %l
  %half = ashr i64 %diff, 1
  %mid = add i64 %l, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  ; init scanning indices
  %i0 = %l
  %next0 = add i64 %l, 1
  %j0 = %h
  br label %inner

inner:                                             ; partitioning loop
  %i = phi i64 [ %i0, %outer ], [ %i.inc, %inc_left ], [ %i.inc2, %cont_after_swap ]
  %j = phi i64 [ %j0, %outer ], [ %j, %inc_left ], [ %j.after, %cont_after_swap ]
  %next = phi i64 [ %next0, %outer ], [ %next.inc, %inc_left ], [ %next.inc2, %cont_after_swap ]
  ; load left and right values
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %lv = load i32, i32* %ptr.i, align 4
  %ptr.j.init = getelementptr inbounds i32, i32* %arr, i64 %j
  %rv.init = load i32, i32* %ptr.j.init, align 4
  ; if lv < pivot, advance left side
  %lv_lt_pivot = icmp slt i32 %lv, %pivot
  br i1 %lv_lt_pivot, label %inc_left, label %check_right

inc_left:                                          ; i++, next++
  %i.inc = add i64 %i, 1
  %next.inc = add i64 %next, 1
  br label %inner

check_right:
  ; if pivot >= rv, proceed; else move right pointer left while arr[j] > pivot
  %pivot_ge_rv = icmp sge i32 %pivot, %rv.init
  br i1 %pivot_ge_rv, label %after_right_adjust, label %move_right.loop

move_right.loop:
  %j.lr = phi i64 [ %j, %check_right ], [ %j.dec, %move_right.loop ]
  %j.dec = add i64 %j.lr, -1
  %ptr.j.lr = getelementptr inbounds i32, i32* %arr, i64 %j.dec
  %rv.lr = load i32, i32* %ptr.j.lr, align 4
  %rv_gt_pivot = icmp sgt i32 %rv.lr, %pivot
  br i1 %rv_gt_pivot, label %move_right.loop, label %move_right.exit

move_right.exit:
  ; j := j.dec, rv := rv.lr
  br label %after_right_adjust

after_right_adjust:
  %j.cur = phi i64 [ %j, %check_right ], [ %j.dec, %move_right.exit ]
  %rv.cur = phi i32 [ %rv.init, %check_right ], [ %rv.lr, %move_right.exit ]
  ; if i <= j then swap; else break
  %i_le_j = icmp sle i64 %i, %j.cur
  br i1 %i_le_j, label %do_swap, label %no_swap_break

do_swap:
  ; swap arr[i] <-> arr[j.cur]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  store i32 %rv.cur, i32* %ptr.i, align 4
  store i32 %lv, i32* %ptr.j, align 4
  ; j' = j - 1
  %j.minus1 = add i64 %j.cur, -1
  ; if next > j' break to partition; else continue with i++, next++
  %next_gt_jm1 = icmp sgt i64 %next, %j.minus1
  br i1 %next_gt_jm1, label %swap_break, label %cont_after_swap

cont_after_swap:
  %i.inc2 = add i64 %i, 1
  %next.inc2 = add i64 %next, 1
  %j.after = %j.minus1
  br label %inner

swap_break:
  ; break to partition with p = next, j_final = j.minus1
  br label %partition

no_swap_break:
  ; break to partition with p = i, j_final = j.cur
  br label %partition

partition:
  %j.final = phi i64 [ %j.minus1, %swap_break ], [ %j.cur, %no_swap_break ]
  %p.val = phi i64 [ %next, %swap_break ], [ %i, %no_swap_break ]
  ; decide which side to recurse on (smaller first)
  %left.size = sub i64 %j.final, %l
  %right.size = sub i64 %h, %p.val
  %left_ge_right = icmp sge i64 %left.size, %right.size
  br i1 %left_ge_right, label %right_first, label %left_first

left_first:
  ; if l < j.final: quick_sort(arr, l, j.final)
  %need_left = icmp slt i64 %l, %j.final
  br i1 %need_left, label %call_left, label %skip_call_left

call_left:
  call void @quick_sort(i32* %arr, i64 %l, i64 %j.final)
  br label %after_leftcall

skip_call_left:
  br label %after_leftcall

after_leftcall:
  ; tail on larger right side: [p.val .. h]
  %l2_left = %p.val
  %h2_left = %h
  br label %after_partition

right_first:
  ; if h > p.val: quick_sort(arr, p.val, h)
  %need_right = icmp sgt i64 %h, %p.val
  br i1 %need_right, label %call_right, label %skip_call_right

call_right:
  call void @quick_sort(i32* %arr, i64 %p.val, i64 %h)
  br label %after_rightcall

skip_call_right:
  br label %after_rightcall

after_rightcall:
  ; tail on larger left side: [l .. j.final]
  %l2_right = %l
  %h2_right = %j.final
  br label %after_partition

after_partition:
  %l2 = phi i64 [ %l2_left, %after_leftcall ], [ %l2_right, %after_rightcall ]
  %h2 = phi i64 [ %h2_left, %after_leftcall ], [ %h2_right, %after_rightcall ]
  ; continue if h2 > l2
  %cont = icmp sgt i64 %h2, %l2
  br i1 %cont, label %outer, label %ret

ret:
  ret void
}