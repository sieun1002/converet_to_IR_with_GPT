; target triple must match your build environment; this is a common default for Linux x86-64
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %build_setup

build_setup:
  %half = lshr i64 %n, 1
  br label %build_header

build_header:
  %i_prev = phi i64 [ %half, %build_setup ], [ %i_dec, %build_latch ]
  %i_dec = add i64 %i_prev, -1
  %cont_build = icmp ne i64 %i_prev, 0
  br i1 %cont_build, label %sift_entry, label %after_build

sift_entry:
  br label %sift_head

sift_head:
  %curr = phi i64 [ %i_dec, %sift_entry ], [ %child, %sift_swap ]
  %mul = shl i64 %curr, 1
  %left = add i64 %mul, 1
  %left_in_range = icmp ult i64 %left, %n
  br i1 %left_in_range, label %check_right, label %build_latch

check_right:
  %right = add i64 %left, 1
  %right_in_range = icmp ult i64 %right, %n
  br i1 %right_in_range, label %cmp_children, label %choose_left

choose_left:
  br label %child_chosen

cmp_children:
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %gep_right, align 4
  %gep_left_c = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %gep_left_c, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:
  br label %child_chosen

child_chosen:
  %child = phi i64 [ %left, %choose_left ], [ %right, %choose_right ]
  %gep_curr = getelementptr inbounds i32, i32* %arr, i64 %curr
  %val_curr = load i32, i32* %gep_curr, align 4
  %gep_child = getelementptr inbounds i32, i32* %arr, i64 %child
  %val_child = load i32, i32* %gep_child, align 4
  %curr_ge_child = icmp sge i32 %val_curr, %val_child
  br i1 %curr_ge_child, label %build_latch, label %sift_swap

sift_swap:
  store i32 %val_child, i32* %gep_curr, align 4
  store i32 %val_curr, i32* %gep_child, align 4
  br label %sift_head

build_latch:
  br label %build_header

after_build:
  %end_init = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %end = phi i64 [ %end_init, %after_build ], [ %end_next, %sort_after_sift ]
  %end_nonzero = icmp ne i64 %end, 0
  br i1 %end_nonzero, label %sort_body, label %exit

sort_body:
  %gep_zero = getelementptr inbounds i32, i32* %arr, i64 0
  %val_zero = load i32, i32* %gep_zero, align 4
  %gep_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %val_end = load i32, i32* %gep_end, align 4
  store i32 %val_end, i32* %gep_zero, align 4
  store i32 %val_zero, i32* %gep_end, align 4
  br label %sort_sift_head

sort_sift_head:
  %sc_curr = phi i64 [ 0, %sort_body ], [ %sc_child, %sc_swap ]
  %sc_mul = shl i64 %sc_curr, 1
  %sc_left = add i64 %sc_mul, 1
  %sc_left_in = icmp ult i64 %sc_left, %end
  br i1 %sc_left_in, label %sc_check_right, label %sort_after_sift

sc_check_right:
  %sc_right = add i64 %sc_left, 1
  %sc_right_in = icmp ult i64 %sc_right, %end
  br i1 %sc_right_in, label %sc_cmp_children, label %sc_choose_left

sc_choose_left:
  br label %sc_child_chosen

sc_cmp_children:
  %sc_gep_right = getelementptr inbounds i32, i32* %arr, i64 %sc_right
  %sc_val_right = load i32, i32* %sc_gep_right, align 4
  %sc_gep_left = getelementptr inbounds i32, i32* %arr, i64 %sc_left
  %sc_val_left = load i32, i32* %sc_gep_left, align 4
  %sc_right_gt_left = icmp sgt i32 %sc_val_right, %sc_val_left
  br i1 %sc_right_gt_left, label %sc_choose_right, label %sc_choose_left

sc_choose_right:
  br label %sc_child_chosen

sc_child_chosen:
  %sc_child = phi i64 [ %sc_left, %sc_choose_left ], [ %sc_right, %sc_choose_right ]
  %sc_gep_curr = getelementptr inbounds i32, i32* %arr, i64 %sc_curr
  %sc_val_curr = load i32, i32* %sc_gep_curr, align 4
  %sc_gep_child = getelementptr inbounds i32, i32* %arr, i64 %sc_child
  %sc_val_child = load i32, i32* %sc_gep_child, align 4
  %sc_curr_ge_child = icmp sge i32 %sc_val_curr, %sc_val_child
  br i1 %sc_curr_ge_child, label %sort_after_sift, label %sc_swap

sc_swap:
  store i32 %sc_val_child, i32* %sc_gep_curr, align 4
  store i32 %sc_val_curr, i32* %sc_gep_child, align 4
  br label %sort_sift_head

sort_after_sift:
  %end_next = add i64 %end, -1
  br label %sort_cond

exit:
  ret void
}