; ModuleID = 'heap_sort.ll'
define void @heap_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %heapify_init

heapify_init:
  %i_start = lshr i64 %n, 1
  br label %heapify_loop_test

heapify_loop_test:
  %i_phi = phi i64 [ %i_start, %heapify_init ], [ %i_dec, %heapify_after_sift ]
  %i_is_zero = icmp eq i64 %i_phi, 0
  br i1 %i_is_zero, label %after_heapify, label %heapify_body

heapify_body:
  %i_dec = add i64 %i_phi, -1
  br label %sift1_loop

sift1_loop:
  %k1 = phi i64 [ %i_dec, %heapify_body ], [ %k1_next, %sift1_swap ]
  %k1_x2 = shl i64 %k1, 1
  %left1 = add i64 %k1_x2, 1
  %cmp_left_n = icmp uge i64 %left1, %n
  br i1 %cmp_left_n, label %heapify_after_sift, label %sift1_check_right

sift1_check_right:
  %right1 = add i64 %left1, 1
  %right_lt_n = icmp ult i64 %right1, %n
  br i1 %right_lt_n, label %sift1_right_in, label %sift1_right_oob

sift1_right_in:
  %left_ptr1 = getelementptr inbounds i32, i32* %a, i64 %left1
  %left_val1 = load i32, i32* %left_ptr1, align 4
  %right_ptr1 = getelementptr inbounds i32, i32* %a, i64 %right1
  %right_val1 = load i32, i32* %right_ptr1, align 4
  %right_gt_left1 = icmp sgt i32 %right_val1, %left_val1
  %larger_idx1_in = select i1 %right_gt_left1, i64 %right1, i64 %left1
  br label %sift1_choose_done

sift1_right_oob:
  br label %sift1_choose_done

sift1_choose_done:
  %larger_idx1 = phi i64 [ %larger_idx1_in, %sift1_right_in ], [ %left1, %sift1_right_oob ]
  %k1_ptr = getelementptr inbounds i32, i32* %a, i64 %k1
  %k1_val = load i32, i32* %k1_ptr, align 4
  %larger_ptr1 = getelementptr inbounds i32, i32* %a, i64 %larger_idx1
  %larger_val1 = load i32, i32* %larger_ptr1, align 4
  %k_ge_larger1 = icmp sge i32 %k1_val, %larger_val1
  br i1 %k_ge_larger1, label %heapify_after_sift, label %sift1_swap

sift1_swap:
  store i32 %larger_val1, i32* %k1_ptr, align 4
  store i32 %k1_val, i32* %larger_ptr1, align 4
  %k1_next = %larger_idx1
  br label %sift1_loop

heapify_after_sift:
  br label %heapify_loop_test

after_heapify:
  %end_init = add i64 %n, -1
  br label %outer_loop_test

outer_loop_test:
  %end_phi = phi i64 [ %end_init, %after_heapify ], [ %end_next, %outer_after_sift ]
  %end_is_zero = icmp eq i64 %end_phi, 0
  br i1 %end_is_zero, label %ret, label %outer_body

outer_body:
  %a0 = load i32, i32* %a, align 4
  %end_ptr = getelementptr inbounds i32, i32* %a, i64 %end_phi
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %a, align 4
  store i32 %a0, i32* %end_ptr, align 4
  br label %sift2_loop

sift2_loop:
  %k2 = phi i64 [ 0, %outer_body ], [ %k2_next, %sift2_swap ]
  %k2_x2 = shl i64 %k2, 1
  %left2 = add i64 %k2_x2, 1
  %cmp_left_end = icmp uge i64 %left2, %end_phi
  br i1 %cmp_left_end, label %outer_after_sift, label %sift2_check_right

sift2_check_right:
  %right2 = add i64 %left2, 1
  %right_lt_end = icmp ult i64 %right2, %end_phi
  br i1 %right_lt_end, label %sift2_right_in, label %sift2_right_oob

sift2_right_in:
  %left_ptr2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  %right_ptr2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %right_gt_left2 = icmp sgt i32 %right_val2, %left_val2
  %larger_idx2_in = select i1 %right_gt_left2, i64 %right2, i64 %left2
  br label %sift2_choose_done

sift2_right_oob:
  br label %sift2_choose_done

sift2_choose_done:
  %larger_idx2 = phi i64 [ %larger_idx2_in, %sift2_right_in ], [ %left2, %sift2_right_oob ]
  %k2_ptr = getelementptr inbounds i32, i32* %a, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %larger_ptr2 = getelementptr inbounds i32, i32* %a, i64 %larger_idx2
  %larger_val2 = load i32, i32* %larger_ptr2, align 4
  %k_ge_larger2 = icmp sge i32 %k2_val, %larger_val2
  br i1 %k_ge_larger2, label %outer_after_sift, label %sift2_swap

sift2_swap:
  store i32 %larger_val2, i32* %k2_ptr, align 4
  store i32 %k2_val, i32* %larger_ptr2, align 4
  %k2_next = %larger_idx2
  br label %sift2_loop

outer_after_sift:
  %end_next = add i64 %end_phi, -1
  br label %outer_loop_test

ret:
  ret void
}