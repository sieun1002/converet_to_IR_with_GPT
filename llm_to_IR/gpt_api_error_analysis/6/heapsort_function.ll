target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_cond

build_cond:
  %var50 = phi i64 [ %half, %build_init ], [ %i_next, %build_body_end ]
  %var50_is_zero = icmp eq i64 %var50, 0
  br i1 %var50_is_zero, label %extract_init, label %build_set_i

build_set_i:
  %i_decr = add i64 %var50, -1
  br label %sift_check

sift_check:
  %cur = phi i64 [ %i_decr, %build_set_i ], [ %new_cur, %sift_swap_done ]
  %left_mul = shl i64 %cur, 1
  %left = add i64 %left_mul, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build_body_end, label %choose_right

choose_right:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %have_right, label %no_right

have_right:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %max_child_idx1 = select i1 %right_gt_left, i64 %right, i64 %left
  br label %choose_done

no_right:
  br label %choose_done

choose_done:
  %max_child = phi i64 [ %max_child_idx1, %have_right ], [ %left, %no_right ]
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_cur = load i32, i32* %ptr_cur, align 4
  %ptr_max = getelementptr inbounds i32, i32* %arr, i64 %max_child
  %val_max = load i32, i32* %ptr_max, align 4
  %cur_ge_max = icmp sge i32 %val_cur, %val_max
  br i1 %cur_ge_max, label %build_body_end, label %sift_do_swap

sift_do_swap:
  store i32 %val_max, i32* %ptr_cur, align 4
  store i32 %val_cur, i32* %ptr_max, align 4
  br label %sift_swap_done

sift_swap_done:
  %new_cur = phi i64 [ %max_child, %sift_do_swap ]
  br label %sift_check

build_body_end:
  %i_next = phi i64 [ %i_decr, %sift_check ], [ %i_decr, %choose_done ]
  br label %build_cond

extract_init:
  %last = add i64 %n, -1
  br label %extract_loop_cond

extract_loop_cond:
  %k = phi i64 [ %last, %extract_init ], [ %k_next, %extract_after_sift ]
  %k_ne_zero = icmp ne i64 %k, 0
  br i1 %k_ne_zero, label %extract_body, label %ret

extract_body:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptrk = getelementptr inbounds i32, i32* %arr, i64 %k
  %valk = load i32, i32* %ptrk, align 4
  store i32 %valk, i32* %ptr0, align 4
  store i32 %val0, i32* %ptrk, align 4
  br label %sift2_check

sift2_check:
  %cur2 = phi i64 [ 0, %extract_body ], [ %new_cur2, %sift2_swap_done ]
  %left2_mul = shl i64 %cur2, 1
  %left2 = add i64 %left2_mul, 1
  %left2_ge_k = icmp uge i64 %left2, %k
  br i1 %left2_ge_k, label %extract_after_sift, label %choose_right2

choose_right2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %k
  br i1 %right2_in, label %have_right2, label %no_right2

have_right2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %right2_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %max_child2_idx1 = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %choose_done2

no_right2:
  br label %choose_done2

choose_done2:
  %max_child2 = phi i64 [ %max_child2_idx1, %have_right2 ], [ %left2, %no_right2 ]
  %ptr_cur2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_cur2 = load i32, i32* %ptr_cur2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %max_child2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %cur2_ge_max2 = icmp sge i32 %val_cur2, %val_max2
  br i1 %cur2_ge_max2, label %extract_after_sift, label %sift2_do_swap

sift2_do_swap:
  store i32 %val_max2, i32* %ptr_cur2, align 4
  store i32 %val_cur2, i32* %ptr_max2, align 4
  br label %sift2_swap_done

sift2_swap_done:
  %new_cur2 = phi i64 [ %max_child2, %sift2_do_swap ]
  br label %sift2_check

extract_after_sift:
  %k_next = add i64 %k, -1
  br label %extract_loop_cond

ret:
  ret void
}