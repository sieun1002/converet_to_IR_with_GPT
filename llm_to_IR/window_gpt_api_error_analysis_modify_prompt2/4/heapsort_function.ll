; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %heapify_init

heapify_init:
  %half = lshr i64 %n, 1
  br label %heapify_dec

heapify_dec:
  %ibefore = phi i64 [ %half, %heapify_init ], [ %i_exit, %heapify_exit ]
  %idec = add i64 %ibefore, -1
  %test = icmp ne i64 %ibefore, 0
  br i1 %test, label %heapify_iter_start, label %build_done

heapify_iter_start:
  %i0 = add i64 %ibefore, -1
  br label %heapify_loop

heapify_loop:
  %i = phi i64 [ %i0, %heapify_iter_start ], [ %child, %heapify_swap_continue ]
  %left_double = shl i64 %i, 1
  %left = add i64 %left_double, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %choose_child_pre, label %heapify_exit

choose_child_pre:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %compare_lr, label %child_is_left

compare_lr:
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %gep_right, align 4
  %gep_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %gep_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  br i1 %right_gt_left, label %child_is_right, label %child_is_left

child_is_right:
  br label %after_choose_child

child_is_left:
  br label %after_choose_child

after_choose_child:
  %child = phi i64 [ %right, %child_is_right ], [ %left, %child_is_left ]
  %gep_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %gep_i, align 4
  %gep_child = getelementptr inbounds i32, i32* %arr, i64 %child
  %val_child = load i32, i32* %gep_child, align 4
  %i_lt_child = icmp slt i32 %val_i, %val_child
  br i1 %i_lt_child, label %heapify_swap, label %heapify_exit

heapify_swap:
  store i32 %val_child, i32* %gep_i, align 4
  store i32 %val_i, i32* %gep_child, align 4
  br label %heapify_swap_continue

heapify_swap_continue:
  br label %heapify_loop

heapify_exit:
  %i_exit = phi i64 [ %i, %heapify_loop ], [ %i, %after_choose_child ]
  br label %heapify_dec

build_done:
  %k0 = add i64 %n, -1
  br label %sort_outer_check

sort_outer_check:
  %k = phi i64 [ %k0, %build_done ], [ %k_next, %after_sift ]
  %cond_k = icmp ne i64 %k, 0
  br i1 %cond_k, label %sort_outer_body, label %ret

sort_outer_body:
  %gep0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %gep0, align 4
  %gep_k = getelementptr inbounds i32, i32* %arr, i64 %k
  %vk = load i32, i32* %gep_k, align 4
  store i32 %vk, i32* %gep0, align 4
  store i32 %v0, i32* %gep_k, align 4
  br label %sort_hloop_header

sort_hloop_header:
  %i2 = phi i64 [ 0, %sort_outer_body ], [ %i2_next, %sort_swap ]
  %left2_d = shl i64 %i2, 1
  %left2 = add i64 %left2_d, 1
  %has_left2 = icmp ult i64 %left2, %k
  br i1 %has_left2, label %sort_choose_child_pre, label %after_sift

sort_choose_child_pre:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %k
  br i1 %has_right2, label %sort_compare_lr, label %sort_child_is_left

sort_compare_lr:
  %gep_r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_r2 = load i32, i32* %gep_r2, align 4
  %gep_l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_l2 = load i32, i32* %gep_l2, align 4
  %right_gt_left2 = icmp sgt i32 %val_r2, %val_l2
  br i1 %right_gt_left2, label %sort_child_is_right, label %sort_child_is_left

sort_child_is_right:
  br label %sort_after_choose_child

sort_child_is_left:
  br label %sort_after_choose_child

sort_after_choose_child:
  %child2 = phi i64 [ %right2, %sort_child_is_right ], [ %left2, %sort_child_is_left ]
  %gep_i2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %val_i2 = load i32, i32* %gep_i2, align 4
  %gep_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val_child2 = load i32, i32* %gep_child2, align 4
  %i2_ge_child2 = icmp sge i32 %val_i2, %val_child2
  br i1 %i2_ge_child2, label %after_sift, label %sort_swap

sort_swap:
  store i32 %val_child2, i32* %gep_i2, align 4
  store i32 %val_i2, i32* %gep_child2, align 4
  %i2_next = add i64 %child2, 0
  br label %sort_hloop_header

after_sift:
  %k_next = add i64 %k, -1
  br label %sort_outer_check

ret:
  ret void
}