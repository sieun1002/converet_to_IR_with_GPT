; ModuleID = 'heap_sort'
define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build_init

build_init:
  %half0 = lshr i64 %n, 1
  br label %build_loop_cond

build_loop_cond:
  %r = phi i64 [ %half0, %build_init ], [ %r_dec, %build_after_sift ]
  %r_is_zero = icmp eq i64 %r, 0
  br i1 %r_is_zero, label %after_build, label %build_body_prep

build_body_prep:
  %idx0 = add i64 %r, -1
  br label %sift1_loop_cond

sift1_loop_cond:
  %cur = phi i64 [ %idx0, %build_body_prep ], [ %j, %sift1_swapped ]
  %cur_shl = shl i64 %cur, 1
  %left = add i64 %cur_shl, 1
  %cmp_left_n = icmp uge i64 %left, %n
  br i1 %cmp_left_n, label %build_after_sift, label %choose_right

choose_right:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  br i1 %right_in, label %compare_right, label %child_is_left

compare_right:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %cmp_right_left = icmp sgt i32 %val_right, %val_left
  br i1 %cmp_right_left, label %child_is_right, label %child_is_left_from_compare

child_is_right:
  br label %child_selected

child_is_left_from_compare:
  br label %child_selected

child_is_left:
  br label %child_selected

child_selected:
  %j = phi i64 [ %right, %child_is_right ], [ %left, %child_is_left_from_compare ], [ %left, %child_is_left ]
  %val_j = phi i32 [ %val_right, %child_is_right ], [ %val_left, %child_is_left_from_compare ], [ %val_left, %child_is_left ]
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_cur = load i32, i32* %ptr_cur, align 4
  %cmp_cur_child = icmp sge i32 %val_cur, %val_j
  br i1 %cmp_cur_child, label %build_after_sift, label %sift1_swapped

sift1_swapped:
  store i32 %val_j, i32* %ptr_cur, align 4
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_cur, i32* %ptr_j, align 4
  br label %sift1_loop_cond

build_after_sift:
  %r_dec = add i64 %r, -1
  br label %build_loop_cond

after_build:
  %m_init = add i64 %n, -1
  br label %sort_loop_cond

sort_loop_cond:
  %m = phi i64 [ %m_init, %after_build ], [ %m_dec, %sort_after_sift ]
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %ret, label %sort_swap_root

sort_swap_root:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pm = getelementptr inbounds i32, i32* %arr, i64 %m
  %vm = load i32, i32* %pm, align 4
  store i32 %vm, i32* %p0, align 4
  store i32 %v0, i32* %pm, align 4
  br label %sift2_loop_cond

sift2_loop_cond:
  %cur2 = phi i64 [ 0, %sort_swap_root ], [ %j2, %sift2_swapped ]
  %cur2_shl = shl i64 %cur2, 1
  %left2 = add i64 %cur2_shl, 1
  %cmp_left2_m = icmp uge i64 %left2, %m
  br i1 %cmp_left2_m, label %sort_after_sift, label %choose_right2

choose_right2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %m
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  br i1 %right2_in, label %compare_right2, label %child_is_left2

compare_right2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %cmp_right_left2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %cmp_right_left2, label %child_is_right2, label %child_is_left_from_compare2

child_is_right2:
  br label %child_selected2

child_is_left_from_compare2:
  br label %child_selected2

child_is_left2:
  br label %child_selected2

child_selected2:
  %j2 = phi i64 [ %right2, %child_is_right2 ], [ %left2, %child_is_left_from_compare2 ], [ %left2, %child_is_left2 ]
  %val_j2 = phi i32 [ %val_right2, %child_is_right2 ], [ %val_left2, %child_is_left_from_compare2 ], [ %val_left2, %child_is_left2 ]
  %ptr_cur2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_cur2 = load i32, i32* %ptr_cur2, align 4
  %cmp_cur_child2 = icmp sge i32 %val_cur2, %val_j2
  br i1 %cmp_cur_child2, label %sort_after_sift, label %sift2_swapped

sift2_swapped:
  store i32 %val_j2, i32* %ptr_cur2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  store i32 %val_cur2, i32* %ptr_j2, align 4
  br label %sift2_loop_cond

sort_after_sift:
  %m_dec = add i64 %m, -1
  br label %sort_loop_cond

ret:
  ret void
}