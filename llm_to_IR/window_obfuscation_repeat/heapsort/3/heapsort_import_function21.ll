; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %exit, label %heapify_init

heapify_init:
  %half = lshr i64 %n, 1
  br label %heapify_loop_check

heapify_loop_check:
  %i_phi = phi i64 [ %half, %heapify_init ], [ %i_dec, %after_sift ]
  %rax_notzero = icmp ne i64 %i_phi, 0
  %i_dec = add i64 %i_phi, -1
  br i1 %rax_notzero, label %sift_start, label %extraction_init

sift_start:
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %i_dec, %sift_start ], [ %child_idx, %do_swap ]
  %j_mul2 = shl i64 %j, 1
  %left = add i64 %j_mul2, 1
  %left_cmp = icmp uge i64 %left, %n
  br i1 %left_cmp, label %after_sift, label %choose_child

choose_child:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  br i1 %right_in, label %compare_children, label %child_is_left

compare_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %gt = icmp sgt i32 %val_right, %val_left
  br i1 %gt, label %child_right, label %child_left

child_right:
  br label %child_chosen

child_left:
  br label %child_chosen

child_is_left:
  br label %child_chosen

child_chosen:
  %child_idx = phi i64 [ %left, %child_is_left ], [ %left, %child_left ], [ %right, %child_right ]
  %child_val = phi i32 [ %val_left, %child_is_left ], [ %val_left, %child_left ], [ %val_right, %child_right ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %lt = icmp slt i32 %val_j, %child_val
  br i1 %lt, label %do_swap, label %after_sift

do_swap:
  %ptr_child = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  store i32 %child_val, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_child, align 4
  br label %sift_loop

after_sift:
  br label %heapify_loop_check

extraction_init:
  %end0 = add i64 %n, -1
  br label %extraction_check

extraction_check:
  %end = phi i64 [ %end0, %extraction_init ], [ %end_next, %extraction_after ]
  %cond = icmp ne i64 %end, 0
  br i1 %cond, label %extraction_body, label %exit

extraction_body:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %ex_sift_loop

ex_sift_loop:
  %j2 = phi i64 [ 0, %extraction_body ], [ %child_idx2, %ex_do_swap ]
  %j2mul2 = shl i64 %j2, 1
  %left2 = add i64 %j2mul2, 1
  %left2_cmp = icmp uge i64 %left2, %end
  br i1 %left2_cmp, label %extraction_after, label %ex_choose_child

ex_choose_child:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  br i1 %right2_in, label %ex_compare_children, label %ex_child_is_left

ex_compare_children:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %gt2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %gt2, label %ex_child_right, label %ex_child_left

ex_child_right:
  br label %ex_child_chosen

ex_child_left:
  br label %ex_child_chosen

ex_child_is_left:
  br label %ex_child_chosen

ex_child_chosen:
  %child_idx2 = phi i64 [ %left2, %ex_child_is_left ], [ %left2, %ex_child_left ], [ %right2, %ex_child_right ]
  %child_val2 = phi i32 [ %val_left2, %ex_child_is_left ], [ %val_left2, %ex_child_left ], [ %val_right2, %ex_child_right ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %lt2 = icmp slt i32 %val_j2, %child_val2
  br i1 %lt2, label %ex_do_swap, label %extraction_after

ex_do_swap:
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %child_idx2
  store i32 %child_val2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_child2, align 4
  br label %ex_sift_loop

extraction_after:
  %end_next = add i64 %end, -1
  br label %extraction_check

exit:
  ret void
}