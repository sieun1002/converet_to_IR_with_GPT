; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/heapsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le1, label %exit, label %build_setup

build_setup:                                      ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_header

build_header:                                     ; preds = %build_latch, %build_setup
  %i_prev = phi i64 [ %half, %build_setup ], [ %i_dec, %build_latch ]
  %i_dec = add i64 %i_prev, -1
  %cont_build.not = icmp eq i64 %i_prev, 0
  br i1 %cont_build.not, label %sort_cond, label %sift_head

sift_head:                                        ; preds = %build_header, %sift_swap
  %curr = phi i64 [ %child, %sift_swap ], [ %i_dec, %build_header ]
  %mul = shl i64 %curr, 1
  %left = or i64 %mul, 1
  %left_in_range = icmp ult i64 %left, %n
  br i1 %left_in_range, label %check_right, label %build_latch

check_right:                                      ; preds = %sift_head
  %right = add i64 %mul, 2
  %right_in_range = icmp ult i64 %right, %n
  br i1 %right_in_range, label %cmp_children, label %child_chosen

cmp_children:                                     ; preds = %check_right
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %gep_right, align 4
  %gep_left_c = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %gep_left_c, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %spec.select = select i1 %right_gt_left, i64 %right, i64 %left
  br label %child_chosen

child_chosen:                                     ; preds = %cmp_children, %check_right
  %child = phi i64 [ %left, %check_right ], [ %spec.select, %cmp_children ]
  %gep_curr = getelementptr inbounds i32, i32* %arr, i64 %curr
  %val_curr = load i32, i32* %gep_curr, align 4
  %gep_child = getelementptr inbounds i32, i32* %arr, i64 %child
  %val_child = load i32, i32* %gep_child, align 4
  %curr_ge_child.not = icmp slt i32 %val_curr, %val_child
  br i1 %curr_ge_child.not, label %sift_swap, label %build_latch

sift_swap:                                        ; preds = %child_chosen
  store i32 %val_child, i32* %gep_curr, align 4
  store i32 %val_curr, i32* %gep_child, align 4
  br label %sift_head

build_latch:                                      ; preds = %child_chosen, %sift_head
  br label %build_header

sort_cond:                                        ; preds = %build_header, %sort_after_sift
  %end.in = phi i64 [ %end, %sort_after_sift ], [ %n, %build_header ]
  %end = add i64 %end.in, -1
  %end_nonzero.not = icmp eq i64 %end, 0
  br i1 %end_nonzero.not, label %exit, label %sort_body

sort_body:                                        ; preds = %sort_cond
  %val_zero = load i32, i32* %arr, align 4
  %gep_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %val_end = load i32, i32* %gep_end, align 4
  store i32 %val_end, i32* %arr, align 4
  store i32 %val_zero, i32* %gep_end, align 4
  br label %sort_sift_head

sort_sift_head:                                   ; preds = %sc_swap, %sort_body
  %sc_curr = phi i64 [ 0, %sort_body ], [ %sc_child, %sc_swap ]
  %sc_mul = shl i64 %sc_curr, 1
  %sc_left = or i64 %sc_mul, 1
  %sc_left_in = icmp ult i64 %sc_left, %end
  br i1 %sc_left_in, label %sc_check_right, label %sort_after_sift

sc_check_right:                                   ; preds = %sort_sift_head
  %sc_right = add i64 %sc_mul, 2
  %sc_right_in = icmp ult i64 %sc_right, %end
  br i1 %sc_right_in, label %sc_cmp_children, label %sc_child_chosen

sc_cmp_children:                                  ; preds = %sc_check_right
  %sc_gep_right = getelementptr inbounds i32, i32* %arr, i64 %sc_right
  %sc_val_right = load i32, i32* %sc_gep_right, align 4
  %sc_gep_left = getelementptr inbounds i32, i32* %arr, i64 %sc_left
  %sc_val_left = load i32, i32* %sc_gep_left, align 4
  %sc_right_gt_left = icmp sgt i32 %sc_val_right, %sc_val_left
  %spec.select1 = select i1 %sc_right_gt_left, i64 %sc_right, i64 %sc_left
  br label %sc_child_chosen

sc_child_chosen:                                  ; preds = %sc_cmp_children, %sc_check_right
  %sc_child = phi i64 [ %sc_left, %sc_check_right ], [ %spec.select1, %sc_cmp_children ]
  %sc_gep_curr = getelementptr inbounds i32, i32* %arr, i64 %sc_curr
  %sc_val_curr = load i32, i32* %sc_gep_curr, align 4
  %sc_gep_child = getelementptr inbounds i32, i32* %arr, i64 %sc_child
  %sc_val_child = load i32, i32* %sc_gep_child, align 4
  %sc_curr_ge_child.not = icmp slt i32 %sc_val_curr, %sc_val_child
  br i1 %sc_curr_ge_child.not, label %sc_swap, label %sort_after_sift

sc_swap:                                          ; preds = %sc_child_chosen
  store i32 %sc_val_child, i32* %sc_gep_curr, align 4
  store i32 %sc_val_curr, i32* %sc_gep_child, align 4
  br label %sort_sift_head

sort_after_sift:                                  ; preds = %sc_child_chosen, %sort_sift_head
  br label %sort_cond

exit:                                             ; preds = %sort_cond, %entry
  ret void
}
