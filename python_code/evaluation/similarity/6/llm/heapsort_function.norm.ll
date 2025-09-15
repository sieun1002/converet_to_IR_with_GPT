; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/heapsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_init = icmp ult i64 %n, 2
  br i1 %cmp_init, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_cond

build_cond:                                       ; preds = %build_body_end, %build_init
  %var50 = phi i64 [ %half, %build_init ], [ %i_decr, %build_body_end ]
  %var50_is_zero = icmp eq i64 %var50, 0
  br i1 %var50_is_zero, label %extract_loop_cond, label %build_set_i

build_set_i:                                      ; preds = %build_cond
  %i_decr = add i64 %var50, -1
  br label %sift_check

sift_check:                                       ; preds = %sift_do_swap, %build_set_i
  %cur = phi i64 [ %i_decr, %build_set_i ], [ %max_child, %sift_do_swap ]
  %left_mul = shl i64 %cur, 1
  %left = or i64 %left_mul, 1
  %left_ge_n.not = icmp ult i64 %left, %n
  br i1 %left_ge_n.not, label %choose_right, label %build_body_end

choose_right:                                     ; preds = %sift_check
  %right = add i64 %left_mul, 2
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %have_right, label %choose_done

have_right:                                       ; preds = %choose_right
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %max_child_idx1 = select i1 %right_gt_left, i64 %right, i64 %left
  br label %choose_done

choose_done:                                      ; preds = %choose_right, %have_right
  %max_child = phi i64 [ %max_child_idx1, %have_right ], [ %left, %choose_right ]
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_cur = load i32, i32* %ptr_cur, align 4
  %ptr_max = getelementptr inbounds i32, i32* %arr, i64 %max_child
  %val_max = load i32, i32* %ptr_max, align 4
  %cur_ge_max.not = icmp slt i32 %val_cur, %val_max
  br i1 %cur_ge_max.not, label %sift_do_swap, label %build_body_end

sift_do_swap:                                     ; preds = %choose_done
  store i32 %val_max, i32* %ptr_cur, align 4
  store i32 %val_cur, i32* %ptr_max, align 4
  br label %sift_check

build_body_end:                                   ; preds = %choose_done, %sift_check
  br label %build_cond

extract_loop_cond:                                ; preds = %build_cond, %extract_after_sift
  %k.in = phi i64 [ %k, %extract_after_sift ], [ %n, %build_cond ]
  %k = add i64 %k.in, -1
  %k_ne_zero.not = icmp eq i64 %k, 0
  br i1 %k_ne_zero.not, label %ret, label %extract_body

extract_body:                                     ; preds = %extract_loop_cond
  %val0 = load i32, i32* %arr, align 4
  %ptrk = getelementptr inbounds i32, i32* %arr, i64 %k
  %valk = load i32, i32* %ptrk, align 4
  store i32 %valk, i32* %arr, align 4
  store i32 %val0, i32* %ptrk, align 4
  br label %sift2_check

sift2_check:                                      ; preds = %sift2_do_swap, %extract_body
  %cur2 = phi i64 [ 0, %extract_body ], [ %max_child2, %sift2_do_swap ]
  %left2_mul = shl i64 %cur2, 1
  %left2 = or i64 %left2_mul, 1
  %left2_ge_k.not = icmp ult i64 %left2, %k
  br i1 %left2_ge_k.not, label %choose_right2, label %extract_after_sift

choose_right2:                                    ; preds = %sift2_check
  %right2 = add i64 %left2_mul, 2
  %right2_in = icmp ult i64 %right2, %k
  br i1 %right2_in, label %have_right2, label %choose_done2

have_right2:                                      ; preds = %choose_right2
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %right2_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %max_child2_idx1 = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %choose_done2

choose_done2:                                     ; preds = %choose_right2, %have_right2
  %max_child2 = phi i64 [ %max_child2_idx1, %have_right2 ], [ %left2, %choose_right2 ]
  %ptr_cur2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_cur2 = load i32, i32* %ptr_cur2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %max_child2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %cur2_ge_max2.not = icmp slt i32 %val_cur2, %val_max2
  br i1 %cur2_ge_max2.not, label %sift2_do_swap, label %extract_after_sift

sift2_do_swap:                                    ; preds = %choose_done2
  store i32 %val_max2, i32* %ptr_cur2, align 4
  store i32 %val_cur2, i32* %ptr_max2, align 4
  br label %sift2_check

extract_after_sift:                               ; preds = %choose_done2, %sift2_check
  br label %extract_loop_cond

ret:                                              ; preds = %extract_loop_cond, %entry
  ret void
}
