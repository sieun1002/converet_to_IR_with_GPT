; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort on i32 array over inclusive indices [lo, hi], choosing smaller partition for recursion (confidence=0.95). Evidence: median-of-range pivot, signed compares with swap and size-based recursion order.
; Preconditions: a != null; indices are valid for 4-byte elements; segment [lo, hi] inclusive.
; Postconditions: a[lo..hi] sorted in nondecreasing (signed) order.

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer_check

outer_check:                                            ; preds = %outer_continue2, %outer_continue1, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.upd1, %outer_continue1 ], [ %lo.upd2, %outer_continue2 ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.upd1, %outer_continue1 ], [ %hi.upd2, %outer_continue2 ]
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %partition_init, label %exit

partition_init:                                         ; preds = %outer_check
  %i0 = %lo.cur
  %j0 = %hi.cur
  %diff = sub i64 %hi.cur, %lo.cur
  %sign = lshr i64 %diff, 63
  %diff_adj = add i64 %diff, %sign
  %half = ashr i64 %diff_adj, 1
  %mid = add i64 %lo.cur, %half
  %pivot_ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %pivot_ptr, align 4
  br label %loop_left

loop_left:                                              ; preds = %after_swap, %left_inc, %partition_init
  %iL = phi i64 [ %i0, %partition_init ], [ %iL.next, %left_inc ], [ %i.afterSwap, %after_swap ]
  %jL = phi i64 [ %j0, %partition_init ], [ %jL, %left_inc ], [ %j.afterSwap, %after_swap ]
  %elem_i_ptr = getelementptr inbounds i32, i32* %a, i64 %iL
  %elem_i = load i32, i32* %elem_i_ptr, align 4
  %cmpL = icmp slt i32 %elem_i, %pivot
  br i1 %cmpL, label %left_inc, label %loop_right

left_inc:                                               ; preds = %loop_left
  %iL.next = add i64 %iL, 1
  br label %loop_left

loop_right:                                             ; preds = %loop_left, %right_dec
  %iR = phi i64 [ %iL, %loop_left ], [ %iR, %right_dec ]
  %jR = phi i64 [ %jL, %loop_left ], [ %jR.next, %right_dec ]
  %elem_j_ptr = getelementptr inbounds i32, i32* %a, i64 %jR
  %elem_j = load i32, i32* %elem_j_ptr, align 4
  %cmpR = icmp sgt i32 %elem_j, %pivot
  br i1 %cmpR, label %right_dec, label %compare_ij

right_dec:                                              ; preds = %loop_right
  %jR.next = add i64 %jR, -1
  br label %loop_right

compare_ij:                                             ; preds = %loop_right
  %le = icmp sle i64 %iR, %jR
  br i1 %le, label %do_swap, label %after_partition

do_swap:                                                ; preds = %compare_ij
  %ptr_i = getelementptr inbounds i32, i32* %a, i64 %iR
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %jR
  %vi = load i32, i32* %ptr_i, align 4
  %vj = load i32, i32* %ptr_j, align 4
  store i32 %vj, i32* %ptr_i, align 4
  store i32 %vi, i32* %ptr_j, align 4
  %i.afterSwap = add i64 %iR, 1
  %j.afterSwap = add i64 %jR, -1
  br label %after_swap

after_swap:                                             ; preds = %do_swap
  br label %loop_left

after_partition:                                        ; preds = %compare_ij
  %left_size = sub i64 %jR, %lo.cur
  %right_size = sub i64 %hi.cur, %iR
  %smaller_left = icmp slt i64 %left_size, %right_size
  br i1 %smaller_left, label %left_smaller, label %right_smaller

left_smaller:                                           ; preds = %after_partition
  %need_left_call = icmp slt i64 %lo.cur, %jR
  br i1 %need_left_call, label %call_left, label %skip_left

call_left:                                              ; preds = %left_smaller
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %jR)
  br label %skip_left

skip_left:                                              ; preds = %call_left, %left_smaller
  %lo.upd1 = %iR
  %hi.upd1 = %hi.cur
  br label %outer_continue1

right_smaller:                                          ; preds = %after_partition
  %need_right_call = icmp slt i64 %iR, %hi.cur
  br i1 %need_right_call, label %call_right, label %skip_right

call_right:                                             ; preds = %right_smaller
  call void @quick_sort(i32* %a, i64 %iR, i64 %hi.cur)
  br label %skip_right

skip_right:                                             ; preds = %call_right, %right_smaller
  %lo.upd2 = %lo.cur
  %hi.upd2 = %jR
  br label %outer_continue2

outer_continue1:                                        ; preds = %skip_left
  br label %outer_check

outer_continue2:                                        ; preds = %skip_right
  br label %outer_check

exit:                                                   ; preds = %outer_check
  ret void
}