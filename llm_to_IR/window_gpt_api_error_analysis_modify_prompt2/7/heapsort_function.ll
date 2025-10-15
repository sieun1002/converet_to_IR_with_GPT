; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %exit, label %heapify_init

heapify_init:
  %half = lshr i64 %n, 1
  br label %heapify_dec

heapify_dec:
  %i = phi i64 [ %half, %heapify_init ], [ %i_next, %heapify_cont ]
  %i_old = add i64 %i, 0
  %i_next = add i64 %i, -1
  %i_old_ne_0 = icmp ne i64 %i_old, 0
  br i1 %i_old_ne_0, label %sift_down_heapify, label %sort_init

sift_down_heapify:
  br label %hd_loop

hd_loop:
  %j = phi i64 [ %i_next, %sift_down_heapify ], [ %j_next, %hd_swap_cont ]
  %j_twice = shl i64 %j, 1
  %lch = add i64 %j_twice, 1
  %lch_lt_n = icmp ult i64 %lch, %n
  br i1 %lch_lt_n, label %hd_has_child, label %hd_break

hd_has_child:
  %rch = add i64 %lch, 1
  %rch_lt_n = icmp ult i64 %rch, %n
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %lch
  %lval = load i32, i32* %lptr, align 4
  br i1 %rch_lt_n, label %hd_compare_children, label %hd_use_left

hd_compare_children:
  %rptr = getelementptr inbounds i32, i32* %arr, i64 %rch
  %rval = load i32, i32* %rptr, align 4
  %r_gt_l = icmp sgt i32 %rval, %lval
  br i1 %r_gt_l, label %hd_choose_right, label %hd_use_left

hd_choose_right:
  br label %hd_child_chosen

hd_use_left:
  br label %hd_child_chosen

hd_child_chosen:
  %child_idx = phi i64 [ %rch, %hd_choose_right ], [ %lch, %hd_use_left ]
  %child_val = phi i32 [ %rval, %hd_choose_right ], [ %lval, %hd_use_left ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %jval = load i32, i32* %jptr, align 4
  %j_lt_child = icmp slt i32 %jval, %child_val
  br i1 %j_lt_child, label %hd_do_swap, label %hd_break

hd_do_swap:
  %cptr = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  store i32 %child_val, i32* %jptr, align 4
  store i32 %jval, i32* %cptr, align 4
  br label %hd_swap_cont

hd_swap_cont:
  %j_next = phi i64 [ %child_idx, %hd_do_swap ]
  br label %hd_loop

hd_break:
  br label %heapify_cont

heapify_cont:
  br label %heapify_dec

sort_init:
  %last = add i64 %n, -1
  br label %sort_loop

sort_loop:
  %end = phi i64 [ %last, %sort_init ], [ %end_next, %after_inner ]
  %end_ne_zero = icmp ne i64 %end, 0
  br i1 %end_ne_zero, label %sort_body, label %exit

sort_body:
  %first_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %first_val = load i32, i32* %first_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %first_ptr, align 4
  store i32 %first_val, i32* %end_ptr, align 4
  br label %inner_loop

inner_loop:
  %j2 = phi i64 [ 0, %sort_body ], [ %j2_next, %inner_swap_cont ]
  %j2_twice = shl i64 %j2, 1
  %lch2 = add i64 %j2_twice, 1
  %lch2_lt_end = icmp ult i64 %lch2, %end
  br i1 %lch2_lt_end, label %inner_has_child, label %after_inner

inner_has_child:
  %rch2 = add i64 %lch2, 1
  %rch2_lt_end = icmp ult i64 %rch2, %end
  %lptr2 = getelementptr inbounds i32, i32* %arr, i64 %lch2
  %lval2 = load i32, i32* %lptr2, align 4
  br i1 %rch2_lt_end, label %inner_compare_children, label %inner_use_left

inner_compare_children:
  %rptr2 = getelementptr inbounds i32, i32* %arr, i64 %rch2
  %rval2 = load i32, i32* %rptr2, align 4
  %r_gt_l2 = icmp sgt i32 %rval2, %lval2
  br i1 %r_gt_l2, label %inner_choose_right, label %inner_use_left

inner_choose_right:
  br label %inner_child_chosen

inner_use_left:
  br label %inner_child_chosen

inner_child_chosen:
  %child_idx2 = phi i64 [ %rch2, %inner_choose_right ], [ %lch2, %inner_use_left ]
  %child_val2 = phi i32 [ %rval2, %inner_choose_right ], [ %lval2, %inner_use_left ]
  %jptr2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %jval2 = load i32, i32* %jptr2, align 4
  %j_ge_child = icmp sge i32 %jval2, %child_val2
  br i1 %j_ge_child, label %after_inner, label %inner_do_swap

inner_do_swap:
  %cptr2 = getelementptr inbounds i32, i32* %arr, i64 %child_idx2
  store i32 %child_val2, i32* %jptr2, align 4
  store i32 %jval2, i32* %cptr2, align 4
  br label %inner_swap_cont

inner_swap_cont:
  %j2_next = phi i64 [ %child_idx2, %inner_do_swap ]
  br label %inner_loop

after_inner:
  %end_next = add i64 %end, -1
  br label %sort_loop

exit:
  ret void
}