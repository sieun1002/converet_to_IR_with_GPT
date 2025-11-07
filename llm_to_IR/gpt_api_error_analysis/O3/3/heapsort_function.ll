target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_dec

build_dec:
  %i_var50 = phi i64 [ %half, %build_init ], [ %i_next_var50, %build_after_sift ]
  %i_prev_nonzero = icmp ne i64 %i_var50, 0
  %i_dec_for_j = add i64 %i_var50, -1
  br i1 %i_prev_nonzero, label %build_sift_entry, label %sort_init

build_sift_entry:
  br label %build_sift_loop

build_sift_loop:
  %j_cur = phi i64 [ %i_dec_for_j, %build_sift_entry ], [ %child_idx_sel, %build_sift_swap ]
  %j_mul2 = shl i64 %j_cur, 1
  %left_idx = add i64 %j_mul2, 1
  %cond_left_ge_n = icmp uge i64 %left_idx, %n
  br i1 %cond_left_ge_n, label %build_after_sift, label %build_has_left

build_has_left:
  %right_idx = add i64 %left_idx, 1
  %cond_right_lt_n = icmp ult i64 %right_idx, %n
  br i1 %cond_right_lt_n, label %build_cmp_children, label %build_choose_left

build_cmp_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right_idx
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left_idx
  %val_left = load i32, i32* %ptr_left, align 4
  %cmp_right_gt_left = icmp sgt i32 %val_right, %val_left
  %child_idx_cmp = select i1 %cmp_right_gt_left, i64 %right_idx, i64 %left_idx
  br label %build_child_selected

build_choose_left:
  br label %build_child_selected

build_child_selected:
  %child_idx_sel = phi i64 [ %left_idx, %build_choose_left ], [ %child_idx_cmp, %build_cmp_children ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j_cur
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_child = getelementptr inbounds i32, i32* %arr, i64 %child_idx_sel
  %val_child = load i32, i32* %ptr_child, align 4
  %cmp_j_ge_child = icmp sge i32 %val_j, %val_child
  br i1 %cmp_j_ge_child, label %build_after_sift, label %build_sift_swap

build_sift_swap:
  store i32 %val_child, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_child, align 4
  br label %build_sift_loop

build_after_sift:
  %i_next_var50 = add i64 %i_var50, -1
  br label %build_dec

sort_init:
  %end_init = add i64 %n, -1
  br label %sort_loop_header

sort_loop_header:
  %end_cur = phi i64 [ %end_init, %sort_init ], [ %end_next, %sort_after_sift ]
  %cond_end_nonzero = icmp ne i64 %end_cur, 0
  br i1 %cond_end_nonzero, label %sort_do_swap, label %ret

sort_do_swap:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end_cur
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %sort_sift_loop

sort_sift_loop:
  %j2_cur = phi i64 [ 0, %sort_do_swap ], [ %child2_idx_sel, %sort_sift_swap ]
  %j2_mul2 = shl i64 %j2_cur, 1
  %left2_idx = add i64 %j2_mul2, 1
  %left_ge_end = icmp uge i64 %left2_idx, %end_cur
  br i1 %left_ge_end, label %sort_after_sift, label %sort_has_left

sort_has_left:
  %right2_idx = add i64 %left2_idx, 1
  %right_lt_end = icmp ult i64 %right2_idx, %end_cur
  br i1 %right_lt_end, label %sort_cmp_children, label %sort_choose_left

sort_cmp_children:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2_idx
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2_idx
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %cmp_right_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %child2_idx_cmp = select i1 %cmp_right_gt_left2, i64 %right2_idx, i64 %left2_idx
  br label %sort_child_selected

sort_choose_left:
  br label %sort_child_selected

sort_child_selected:
  %child2_idx_sel = phi i64 [ %left2_idx, %sort_choose_left ], [ %child2_idx_cmp, %sort_cmp_children ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2_cur
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2_idx_sel
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %cmp_j_ge_child2 = icmp sge i32 %val_j2, %val_child2
  br i1 %cmp_j_ge_child2, label %sort_after_sift, label %sort_sift_swap

sort_sift_swap:
  store i32 %val_child2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_child2, align 4
  br label %sort_sift_loop

sort_after_sift:
  %end_next = add i64 %end_cur, -1
  br label %sort_loop_header

ret:
  ret void
}