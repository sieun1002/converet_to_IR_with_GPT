; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %left0, i64 %right0) local_unnamed_addr nounwind {
entry:
  br label %outer_check

outer_check:                                           ; corresponds to top-level check (rsi >= rdx -> ret)
  %L = phi i64 [ %left0, %entry ], [ %L_after_left, %after_left ], [ %L_after_right, %after_right ]
  %R = phi i64 [ %right0, %entry ], [ %R_after_left, %after_left ], [ %R_after_right, %after_right ]
  %cmp_L_ge_R = icmp sge i64 %L, %R
  br i1 %cmp_L_ge_R, label %ret, label %outer_body

ret:
  ret void

outer_body:                                            ; setup for partition: compute pivot, init i, j, r9
  %i_init = add i64 %L, 0
  %j_init = add i64 %R, 0
  %r9_init = add i64 %L, 1
  %diff = sub i64 %R, %L
  %half = ashr i64 %diff, 1
  %mid = add i64 %L, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %inner_head

inner_head:                                            ; corresponds to 0x1260
  %i = phi i64 [ %i_init, %outer_body ], [ %i_inc, %inc_i ]
  %j = phi i64 [ %j_init, %outer_body ], [ %j_passthru, %inc_i ]
  %r9 = phi i64 [ %r9_init, %outer_body ], [ %r9_inc, %inc_i ]
  %a_i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %a_i = load i32, i32* %a_i.ptr, align 4
  %p_j.ptr_init = getelementptr inbounds i32, i32* %arr, i64 %j
  %edx0 = load i32, i32* %p_j.ptr_init, align 4
  %cmp_a_i_lt_pivot = icmp slt i32 %a_i, %pivot
  br i1 %cmp_a_i_lt_pivot, label %inc_i, label %check_pivot_ge_edx

check_pivot_ge_edx:                                    ; corresponds to 0x1271
  %cmp_pivot_ge_edx0 = icmp sge i32 %pivot, %edx0
  br i1 %cmp_pivot_ge_edx0, label %after_scan, label %scan_loop_pre

scan_loop_pre:                                         ; corresponds to 0x1275 pre-decrement
  %j_pre = add i64 %j, -1
  br label %scan_loop

scan_loop:                                             ; corresponds to 0x1280..0x128F
  %j_cur = phi i64 [ %j_pre, %scan_loop_pre ], [ %j_next_scan, %scan_loop_continue ]
  %p_j_cur = getelementptr inbounds i32, i32* %arr, i64 %j_cur
  %edx_cur = load i32, i32* %p_j_cur, align 4
  %cmp_edx_gt_pivot = icmp sgt i32 %edx_cur, %pivot
  br i1 %cmp_edx_gt_pivot, label %scan_loop_continue, label %after_scan_from_scan

scan_loop_continue:
  %j_next_scan = add i64 %j_cur, -1
  br label %scan_loop

after_scan_from_scan:
  br label %after_scan

after_scan:                                            ; corresponds to 0x1291
  %j_final = phi i64 [ %j, %check_pivot_ge_edx ], [ %j_cur, %after_scan_from_scan ]
  %edx_final = phi i32 [ %edx0, %check_pivot_ge_edx ], [ %edx_cur, %after_scan_from_scan ]
  %r14_i = add i64 %i, 0
  %cmp_i_le_j = icmp sle i64 %i, %j_final
  br i1 %cmp_i_le_j, label %swap_path, label %finish_select_from_no_swap

swap_path:                                             ; corresponds to 0x12C0..0x12CE
  store i32 %edx_final, i32* %a_i.ptr, align 4
  %p_j_final = getelementptr inbounds i32, i32* %arr, i64 %j_final
  store i32 %a_i, i32* %p_j_final, align 4
  %j_dec1 = add i64 %j_final, -1
  %r14_after_swap = add i64 %r9, 0
  %cmp_r9_gt_jdec = icmp sgt i64 %r9, %j_dec1
  br i1 %cmp_r9_gt_jdec, label %finish_select_from_swap, label %inc_i_from_swap

inc_i_from_swap:                                       ; corresponds to jump to 0x12DB after swap
  br label %inc_i

inc_i:                                                 ; corresponds to 0x12DB
  %j_passthru = phi i64 [ %j, %inner_head ], [ %j_dec1, %inc_i_from_swap ]
  %i_inc = add i64 %i, 1
  %r9_inc = add i64 %r9, 1
  br label %inner_head

finish_select_from_no_swap:                            ; corresponds to 0x1299 path when i > j
  br label %finish_select

finish_select_from_swap:                               ; corresponds to 0x1299 via 0x12C8/0x12D1
  br label %finish_select

finish_select:                                         ; corresponds to 0x1299..0x12B2 and branching to recurse
  %r14_final = phi i64 [ %r14_i, %finish_select_from_no_swap ], [ %r14_after_swap, %finish_select_from_swap ]
  %j_end = phi i64 [ %j_final, %finish_select_from_no_swap ], [ %j_dec1, %finish_select_from_swap ]
  %left_len = sub i64 %j_end, %L
  %right_len = sub i64 %R, %r14_final
  %choose_right_first = icmp sge i64 %left_len, %right_len
  br i1 %choose_right_first, label %prefer_right, label %prefer_left

prefer_left:                                           ; corresponds to 0x12AA..0x12F2
  %left_nonempty = icmp sgt i64 %j_end, %L
  br i1 %left_nonempty, label %call_left, label %after_left_no_call

call_left:
  call void @quick_sort(i32* %arr, i64 %L, i64 %j_end)
  br label %after_left_no_call

after_left_no_call:                                    ; corresponds to 0x12AF..0x12B2
  %L_after_left = add i64 %r14_final, 0
  %R_after_left = add i64 %R, 0
  br label %after_left

after_left:
  br label %outer_check

prefer_right:                                          ; corresponds to 0x12E8..0x1302
  %right_nonempty = icmp slt i64 %r14_final, %R
  br i1 %right_nonempty, label %call_right, label %after_right_no_call

call_right:
  call void @quick_sort(i32* %arr, i64 %r14_final, i64 %R)
  br label %after_right_no_call

after_right_no_call:                                   ; corresponds to 0x12ED..0x12B2
  %R_after_right = add i64 %j_end, 0
  %L_after_right = add i64 %L, 0
  br label %after_right

after_right:
  br label %outer_check
}