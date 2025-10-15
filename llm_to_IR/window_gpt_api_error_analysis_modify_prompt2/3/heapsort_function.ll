; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

ret:
  ret void

build_init:
  %half = lshr i64 %n, 1
  br label %build_control

build_control:
  %i_prev = phi i64 [ %half, %build_init ], [ %i_dec, %after_sift ]
  %i_is_zero = icmp eq i64 %i_prev, 0
  br i1 %i_is_zero, label %sort_init, label %build_set

build_set:
  %i_dec = add i64 %i_prev, -1
  br label %sift_head

sift_head:
  %j_cur = phi i64 [ %i_dec, %build_set ], [ %child_idx, %sift_swapped ]
  %twice_j = add i64 %j_cur, %j_cur
  %left = add i64 %twice_j, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %sift_has_left, label %after_sift

sift_has_left:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %check_right, label %sift_compare_from_left

check_right:
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %gep_right, align 4
  %gep_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %gep_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %child_idx_sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %sift_compare

sift_compare_from_left:
  br label %sift_compare

sift_compare:
  %child_idx = phi i64 [ %child_idx_sel, %check_right ], [ %left, %sift_compare_from_left ]
  %gep_j = getelementptr inbounds i32, i32* %arr, i64 %j_cur
  %val_j = load i32, i32* %gep_j, align 4
  %gep_child = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  %val_child = load i32, i32* %gep_child, align 4
  %j_lt_child = icmp slt i32 %val_j, %val_child
  br i1 %j_lt_child, label %sift_swap, label %after_sift

sift_swap:
  store i32 %val_child, i32* %gep_j, align 4
  store i32 %val_j, i32* %gep_child, align 4
  br label %sift_swapped

sift_swapped:
  br label %sift_head

after_sift:
  br label %build_control

sort_init:
  %end0 = add i64 %n, -1
  br label %sort_loop

sort_loop:
  %end_cur = phi i64 [ %end0, %sort_init ], [ %end_next, %after_sift2 ]
  %end_is_zero = icmp eq i64 %end_cur, 0
  br i1 %end_is_zero, label %ret2, label %sort_body

sort_body:
  %gep0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %gep0, align 4
  %gep_end = getelementptr inbounds i32, i32* %arr, i64 %end_cur
  %val_end = load i32, i32* %gep_end, align 4
  store i32 %val_end, i32* %gep0, align 4
  store i32 %val0, i32* %gep_end, align 4
  br label %sift2_head

sift2_head:
  %j2 = phi i64 [ 0, %sort_body ], [ %child2_idx, %sift2_swapped ]
  %twice_j2 = add i64 %j2, %j2
  %left2 = add i64 %twice_j2, 1
  %left2_lt_end = icmp ult i64 %left2, %end_cur
  br i1 %left2_lt_end, label %sift2_has_left, label %after_sift2

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2_lt_end = icmp ult i64 %right2, %end_cur
  br i1 %right2_lt_end, label %check_right2, label %sift2_compare_from_left

check_right2:
  %gep_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %gep_right2, align 4
  %gep_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %gep_left2, align 4
  %right2_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %child2_sel = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %sift2_compare

sift2_compare_from_left:
  br label %sift2_compare

sift2_compare:
  %child2_idx = phi i64 [ %child2_sel, %check_right2 ], [ %left2, %sift2_compare_from_left ]
  %gep_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %gep_j2, align 4
  %gep_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  %val_child2 = load i32, i32* %gep_child2, align 4
  %j2_lt_child2 = icmp slt i32 %val_j2, %val_child2
  br i1 %j2_lt_child2, label %sift2_swap, label %after_sift2

sift2_swap:
  store i32 %val_child2, i32* %gep_j2, align 4
  store i32 %val_j2, i32* %gep_child2, align 4
  br label %sift2_swapped

sift2_swapped:
  br label %sift2_head

after_sift2:
  %end_next = add i64 %end_cur, -1
  br label %sort_loop

ret2:
  ret void
}