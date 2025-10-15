; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp_small = icmp ule i64 %n, 1
  br i1 %cmp_small, label %exit, label %build_init

build_init:
  %i0 = lshr i64 %n, 1
  br label %build_cond

build_cond:
  %i = phi i64 [ %i0, %build_init ], [ %i_next, %build_after_sift ]
  %cond_i = icmp ne i64 %i, 0
  br i1 %cond_i, label %build_body, label %after_build

build_body:
  %cur0 = add i64 %i, -1
  br label %build_sift_cond

build_sift_cond:
  %k = phi i64 [ %cur0, %build_body ], [ %k_next, %build_swap ]
  %two_k = shl i64 %k, 1
  %left = add i64 %two_k, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %build_right_check, label %build_after_sift

build_right_check:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %build_compare_children, label %build_choose_left

build_compare_children:
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %j_idx_sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %build_after_choose

build_choose_left:
  br label %build_after_choose

build_after_choose:
  %j = phi i64 [ %left, %build_choose_left ], [ %j_idx_sel, %build_compare_children ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_lt_j = icmp slt i32 %k_val, %j_val
  br i1 %k_lt_j, label %build_swap, label %build_after_sift

build_swap:
  store i32 %j_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %j_ptr, align 4
  %k_next = add i64 %j, 0
  br label %build_sift_cond

build_after_sift:
  %i_next = add i64 %i, -1
  br label %build_cond

after_build:
  %m0_tmp = add i64 %n, -1
  br label %extract_cond

extract_cond:
  %m = phi i64 [ %m0_tmp, %after_build ], [ %m_next, %extract_after_sift ]
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %exit, label %extract_body

extract_body:
  %first_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %first_val = load i32, i32* %first_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %first_ptr, align 4
  store i32 %first_val, i32* %m_ptr, align 4
  br label %extract_sift_cond

extract_sift_cond:
  %k2 = phi i64 [ 0, %extract_body ], [ %k2_next, %extract_swap ]
  %two_k2 = shl i64 %k2, 1
  %left2 = add i64 %two_k2, 1
  %left2_in = icmp ult i64 %left2, %m
  br i1 %left2_in, label %extract_right_check, label %extract_after_sift

extract_right_check:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %m
  br i1 %right2_in, label %extract_compare_children, label %extract_choose_left

extract_compare_children:
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %j2_idx_sel = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %extract_after_choose

extract_choose_left:
  br label %extract_after_choose

extract_after_choose:
  %j2 = phi i64 [ %left2, %extract_choose_left ], [ %j2_idx_sel, %extract_compare_children ]
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_lt_j2 = icmp slt i32 %k2_val, %j2_val
  br i1 %k2_lt_j2, label %extract_swap, label %extract_after_sift

extract_swap:
  store i32 %j2_val, i32* %k2_ptr, align 4
  store i32 %k2_val, i32* %j2_ptr, align 4
  %k2_next = add i64 %j2, 0
  br label %extract_sift_cond

extract_after_sift:
  %m_next = add i64 %m, -1
  br label %extract_cond

exit:
  ret void
}