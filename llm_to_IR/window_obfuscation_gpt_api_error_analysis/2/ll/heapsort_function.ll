; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %heapify_cond

heapify_cond:
  %i_tmp = phi i64 [ %half, %build_init ], [ %i_for_next, %percolate_done ]
  %is_zero = icmp eq i64 %i_tmp, 0
  br i1 %is_zero, label %sort_init, label %heapify_begin

heapify_begin:
  %i = add i64 %i_tmp, -1
  br label %percolate_check

percolate_check:
  %k = phi i64 [ %i, %heapify_begin ], [ %m, %percolate_swap ]
  %k_2 = shl i64 %k, 1
  %left = add i64 %k_2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %percolate_have_left, label %percolate_done

percolate_have_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %compare_children, label %choose_left

compare_children:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_left:
  br label %child_chosen

choose_right:
  br label %child_chosen

child_chosen:
  %m = phi i64 [ %left, %choose_left ], [ %right, %choose_right ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  %cmp_k_lt_m = icmp slt i32 %k_val, %m_val
  br i1 %cmp_k_lt_m, label %percolate_swap, label %percolate_done

percolate_swap:
  store i32 %m_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %m_ptr, align 4
  br label %percolate_check

percolate_done:
  %i_for_next = phi i64 [ %i, %percolate_check ], [ %i, %child_chosen ]
  br label %heapify_cond

sort_init:
  %limit = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %m2 = phi i64 [ %limit, %sort_init ], [ %m2_dec, %sort_decrement ]
  %cmp_m2_nonzero = icmp ne i64 %m2, 0
  br i1 %cmp_m2_nonzero, label %sort_body, label %ret

sort_body:
  %root_val = load i32, i32* %arr, align 4
  %m2_ptr = getelementptr inbounds i32, i32* %arr, i64 %m2
  %m2_val = load i32, i32* %m2_ptr, align 4
  store i32 %m2_val, i32* %arr, align 4
  store i32 %root_val, i32* %m2_ptr, align 4
  br label %inner_check

inner_check:
  %j = phi i64 [ 0, %sort_body ], [ %mindex2, %inner_swap ]
  %j2 = shl i64 %j, 1
  %left2 = add i64 %j2, 1
  %left_lt_m2 = icmp ult i64 %left2, %m2
  br i1 %left_lt_m2, label %inner_have_left, label %inner_done

inner_have_left:
  %right2 = add i64 %left2, 1
  %right_in2 = icmp ult i64 %right2, %m2
  br i1 %right_in2, label %inner_compare_children, label %inner_choose_left

inner_compare_children:
  %rptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %rval2 = load i32, i32* %rptr2, align 4
  %lptr2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %lval2 = load i32, i32* %lptr2, align 4
  %right_gt_left2 = icmp sgt i32 %rval2, %lval2
  br i1 %right_gt_left2, label %inner_choose_right, label %inner_choose_left

inner_choose_left:
  br label %inner_child_chosen

inner_choose_right:
  br label %inner_child_chosen

inner_child_chosen:
  %mindex2 = phi i64 [ %left2, %inner_choose_left ], [ %right2, %inner_choose_right ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %jval = load i32, i32* %jptr, align 4
  %mptr2 = getelementptr inbounds i32, i32* %arr, i64 %mindex2
  %mval2 = load i32, i32* %mptr2, align 4
  %cmp_j_ge_m = icmp sge i32 %jval, %mval2
  br i1 %cmp_j_ge_m, label %inner_done, label %inner_swap

inner_swap:
  store i32 %mval2, i32* %jptr, align 4
  store i32 %jval, i32* %mptr2, align 4
  br label %inner_check

inner_done:
  br label %sort_decrement

sort_decrement:
  %m2_dec = add i64 %m2, -1
  br label %sort_cond

ret:
  ret void
}