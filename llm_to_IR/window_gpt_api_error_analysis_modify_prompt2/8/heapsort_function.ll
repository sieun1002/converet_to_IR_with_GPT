; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_dec

build_dec:
  %v8 = phi i64 [ %half, %build_init ], [ %v8next, %build_body_continue ]
  %v8next = add i64 %v8, -1
  %cond_enter = icmp ne i64 %v8, 0
  br i1 %cond_enter, label %build_body_entry, label %after_build

build_body_entry:
  br label %sift_header

sift_header:
  %i = phi i64 [ %v8next, %build_body_entry ], [ %child_idx, %sift_do_swap ]
  %i_x2 = shl i64 %i, 1
  %left_add1 = add i64 %i_x2, 1
  %left_lt_n = icmp ult i64 %left_add1, %n
  br i1 %left_lt_n, label %choose_child, label %build_body_continue

choose_child:
  %right_idx = add i64 %left_add1, 1
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left_add1
  %left_val = load i32, i32* %left_ptr, align 4
  %right_lt_n = icmp ult i64 %right_idx, %n
  br i1 %right_lt_n, label %cmp_children, label %choose_left

cmp_children:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right_idx
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:
  br label %child_chosen

choose_left:
  br label %child_chosen

child_chosen:
  %child_idx = phi i64 [ %right_idx, %choose_right ], [ %left_add1, %choose_left ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %i_val = load i32, i32* %i_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  %child_val = load i32, i32* %child_ptr, align 4
  %parent_lt_child = icmp slt i32 %i_val, %child_val
  br i1 %parent_lt_child, label %sift_do_swap, label %build_body_continue

sift_do_swap:
  store i32 %child_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %child_ptr, align 4
  br label %sift_header

build_body_continue:
  br label %build_dec

after_build:
  %last = add i64 %n, -1
  br label %outer_loop_header

outer_loop_header:
  %heap_end = phi i64 [ %last, %after_build ], [ %heap_end_dec, %after_inner_break ]
  %heap_nonzero = icmp ne i64 %heap_end, 0
  br i1 %heap_nonzero, label %outer_iteration_start, label %exit

outer_iteration_start:
  %root_val = load i32, i32* %arr, align 4
  %heap_elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %heap_elem_val = load i32, i32* %heap_elem_ptr, align 4
  store i32 %heap_elem_val, i32* %arr, align 4
  store i32 %root_val, i32* %heap_elem_ptr, align 4
  br label %inner_sift_header

inner_sift_header:
  %i2 = phi i64 [ 0, %outer_iteration_start ], [ %child2_idx, %inner_do_swap ]
  %i2_x2 = shl i64 %i2, 1
  %left2 = add i64 %i2_x2, 1
  %left_in_heap = icmp ult i64 %left2, %heap_end
  br i1 %left_in_heap, label %inner_choose_child, label %after_inner_break

inner_choose_child:
  %right2 = add i64 %left2, 1
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right_in_heap = icmp ult i64 %right2, %heap_end
  br i1 %right_in_heap, label %inner_cmp_children, label %inner_choose_left

inner_cmp_children:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right_gt_left2, label %inner_choose_right, label %inner_choose_left

inner_choose_right:
  br label %inner_child_chosen

inner_choose_left:
  br label %inner_child_chosen

inner_child_chosen:
  %child2_idx = phi i64 [ %right2, %inner_choose_right ], [ %left2, %inner_choose_left ]
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2
  %i2_val = load i32, i32* %i2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  %child2_val = load i32, i32* %child2_ptr, align 4
  %parent_ge_child2 = icmp sge i32 %i2_val, %child2_val
  br i1 %parent_ge_child2, label %after_inner_break, label %inner_do_swap

inner_do_swap:
  store i32 %child2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %child2_ptr, align 4
  br label %inner_sift_header

after_inner_break:
  %heap_end_dec = add i64 %heap_end, -1
  br label %outer_loop_header

exit:
  ret void
}