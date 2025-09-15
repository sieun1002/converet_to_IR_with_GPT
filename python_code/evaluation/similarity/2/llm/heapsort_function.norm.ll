; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/heapsort_function.ll"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %half0 = lshr i64 %n, 1
  br label %build_loop_cond

build_loop_cond:                                  ; preds = %build_after_sift, %build_init
  %r = phi i64 [ %half0, %build_init ], [ %idx0, %build_after_sift ]
  %r_is_zero = icmp eq i64 %r, 0
  br i1 %r_is_zero, label %sort_loop_cond, label %build_body_prep

build_body_prep:                                  ; preds = %build_loop_cond
  %idx0 = add i64 %r, -1
  br label %sift1_loop_cond

sift1_loop_cond:                                  ; preds = %sift1_swapped, %build_body_prep
  %cur = phi i64 [ %idx0, %build_body_prep ], [ %j, %sift1_swapped ]
  %cur_shl = shl i64 %cur, 1
  %left = or i64 %cur_shl, 1
  %cmp_left_n.not = icmp ult i64 %left, %n
  br i1 %cmp_left_n.not, label %choose_right, label %build_after_sift

choose_right:                                     ; preds = %sift1_loop_cond
  %right = add i64 %cur_shl, 2
  %right_in = icmp ult i64 %right, %n
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  br i1 %right_in, label %compare_right, label %child_selected

compare_right:                                    ; preds = %choose_right
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %cmp_right_left = icmp sgt i32 %val_right, %val_left
  %right.left = select i1 %cmp_right_left, i64 %right, i64 %left
  %val_right.val_left = select i1 %cmp_right_left, i32 %val_right, i32 %val_left
  br label %child_selected

child_selected:                                   ; preds = %choose_right, %compare_right
  %j = phi i64 [ %right.left, %compare_right ], [ %left, %choose_right ]
  %val_j = phi i32 [ %val_right.val_left, %compare_right ], [ %val_left, %choose_right ]
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_cur = load i32, i32* %ptr_cur, align 4
  %cmp_cur_child.not = icmp slt i32 %val_cur, %val_j
  br i1 %cmp_cur_child.not, label %sift1_swapped, label %build_after_sift

sift1_swapped:                                    ; preds = %child_selected
  store i32 %val_j, i32* %ptr_cur, align 4
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_cur, i32* %ptr_j, align 4
  br label %sift1_loop_cond

build_after_sift:                                 ; preds = %child_selected, %sift1_loop_cond
  br label %build_loop_cond

sort_loop_cond:                                   ; preds = %build_loop_cond, %sort_after_sift
  %m.in = phi i64 [ %m, %sort_after_sift ], [ %n, %build_loop_cond ]
  %m = add i64 %m.in, -1
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %ret, label %sort_swap_root

sort_swap_root:                                   ; preds = %sort_loop_cond
  %v0 = load i32, i32* %arr, align 4
  %pm = getelementptr inbounds i32, i32* %arr, i64 %m
  %vm = load i32, i32* %pm, align 4
  store i32 %vm, i32* %arr, align 4
  store i32 %v0, i32* %pm, align 4
  br label %sift2_loop_cond

sift2_loop_cond:                                  ; preds = %sift2_swapped, %sort_swap_root
  %cur2 = phi i64 [ 0, %sort_swap_root ], [ %j2, %sift2_swapped ]
  %cur2_shl = shl i64 %cur2, 1
  %left2 = or i64 %cur2_shl, 1
  %cmp_left2_m.not = icmp ult i64 %left2, %m
  br i1 %cmp_left2_m.not, label %choose_right2, label %sort_after_sift

choose_right2:                                    ; preds = %sift2_loop_cond
  %right2 = add i64 %cur2_shl, 2
  %right2_in = icmp ult i64 %right2, %m
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  br i1 %right2_in, label %compare_right2, label %child_selected2

compare_right2:                                   ; preds = %choose_right2
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %cmp_right_left2 = icmp sgt i32 %val_right2, %val_left2
  %right2.left2 = select i1 %cmp_right_left2, i64 %right2, i64 %left2
  %val_right2.val_left2 = select i1 %cmp_right_left2, i32 %val_right2, i32 %val_left2
  br label %child_selected2

child_selected2:                                  ; preds = %choose_right2, %compare_right2
  %j2 = phi i64 [ %right2.left2, %compare_right2 ], [ %left2, %choose_right2 ]
  %val_j2 = phi i32 [ %val_right2.val_left2, %compare_right2 ], [ %val_left2, %choose_right2 ]
  %ptr_cur2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_cur2 = load i32, i32* %ptr_cur2, align 4
  %cmp_cur_child2.not = icmp slt i32 %val_cur2, %val_j2
  br i1 %cmp_cur_child2.not, label %sift2_swapped, label %sort_after_sift

sift2_swapped:                                    ; preds = %child_selected2
  store i32 %val_j2, i32* %ptr_cur2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  store i32 %val_cur2, i32* %ptr_j2, align 4
  br label %sift2_loop_cond

sort_after_sift:                                  ; preds = %child_selected2, %sift2_loop_cond
  br label %sort_loop_cond

ret:                                              ; preds = %sort_loop_cond, %entry
  ret void
}
