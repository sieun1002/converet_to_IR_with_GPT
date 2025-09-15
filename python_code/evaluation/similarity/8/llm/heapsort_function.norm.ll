; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/heapsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %build_start

build_start:                                      ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_header

build_header:                                     ; preds = %build_latch, %build_start
  %i = phi i64 [ %half, %build_start ], [ %i_dec, %build_latch ]
  %cond_b.not = icmp eq i64 %i, 0
  br i1 %cond_b.not, label %outer_header, label %build_body

build_body:                                       ; preds = %build_header
  %i_dec = add i64 %i, -1
  br label %sift1_head

sift1_head:                                       ; preds = %sift1_swap, %build_body
  %s1 = phi i64 [ %i_dec, %build_body ], [ %child1_idx, %sift1_swap ]
  %tmp2 = shl i64 %s1, 1
  %left1 = or i64 %tmp2, 1
  %cmp_left1.not = icmp ult i64 %left1, %n
  br i1 %cmp_left1.not, label %sift1_have_left, label %build_latch

sift1_have_left:                                  ; preds = %sift1_head
  %right1 = add i64 %tmp2, 2
  %cmp_right_in = icmp ult i64 %right1, %n
  br i1 %cmp_right_in, label %sift1_check_right, label %sift1_have_left.sift1_choose_left_crit_edge

sift1_have_left.sift1_choose_left_crit_edge:      ; preds = %sift1_have_left
  %gep_c1.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %left1
  %val_c1.pre.pre = load i32, i32* %gep_c1.phi.trans.insert.phi.trans.insert, align 4
  br label %sift1_choose_left

sift1_check_right:                                ; preds = %sift1_have_left
  %gep_r1 = getelementptr inbounds i32, i32* %arr, i64 %right1
  %val_r1 = load i32, i32* %gep_r1, align 4
  %gep_l1 = getelementptr inbounds i32, i32* %arr, i64 %left1
  %val_l1 = load i32, i32* %gep_l1, align 4
  %cmp_gt = icmp sgt i32 %val_r1, %val_l1
  br i1 %cmp_gt, label %sift1_chosen, label %sift1_choose_left

sift1_choose_left:                                ; preds = %sift1_have_left.sift1_choose_left_crit_edge, %sift1_check_right
  %val_c1.pre = phi i32 [ %val_c1.pre.pre, %sift1_have_left.sift1_choose_left_crit_edge ], [ %val_l1, %sift1_check_right ]
  br label %sift1_chosen

sift1_chosen:                                     ; preds = %sift1_check_right, %sift1_choose_left
  %val_c1 = phi i32 [ %val_c1.pre, %sift1_choose_left ], [ %val_r1, %sift1_check_right ]
  %child1_idx = phi i64 [ %left1, %sift1_choose_left ], [ %right1, %sift1_check_right ]
  %gep_s1 = getelementptr inbounds i32, i32* %arr, i64 %s1
  %val_s1 = load i32, i32* %gep_s1, align 4
  %gep_c1 = getelementptr inbounds i32, i32* %arr, i64 %child1_idx
  %cmp_ge.not = icmp slt i32 %val_s1, %val_c1
  br i1 %cmp_ge.not, label %sift1_swap, label %build_latch

sift1_swap:                                       ; preds = %sift1_chosen
  store i32 %val_c1, i32* %gep_s1, align 4
  store i32 %val_s1, i32* %gep_c1, align 4
  br label %sift1_head

build_latch:                                      ; preds = %sift1_chosen, %sift1_head
  br label %build_header

outer_header:                                     ; preds = %build_header, %outer_latch
  %m.in = phi i64 [ %m, %outer_latch ], [ %n, %build_header ]
  %m = add i64 %m.in, -1
  %cond_m.not = icmp eq i64 %m, 0
  br i1 %cond_m.not, label %ret, label %outer_body

outer_body:                                       ; preds = %outer_header
  %a0 = load i32, i32* %arr, align 4
  %gep_am = getelementptr inbounds i32, i32* %arr, i64 %m
  %am = load i32, i32* %gep_am, align 4
  store i32 %am, i32* %arr, align 4
  store i32 %a0, i32* %gep_am, align 4
  br label %sift2_head

sift2_head:                                       ; preds = %sift2_swap, %outer_body
  %s2 = phi i64 [ 0, %outer_body ], [ %child2_idx, %sift2_swap ]
  %tmp2a = shl i64 %s2, 1
  %left2 = or i64 %tmp2a, 1
  %cmp_left2.not = icmp ult i64 %left2, %m
  br i1 %cmp_left2.not, label %sift2_have_left, label %outer_latch

sift2_have_left:                                  ; preds = %sift2_head
  %right2 = add i64 %tmp2a, 2
  %cmp_right2_in = icmp ult i64 %right2, %m
  br i1 %cmp_right2_in, label %sift2_check_right, label %sift2_have_left.sift2_choose_left_crit_edge

sift2_have_left.sift2_choose_left_crit_edge:      ; preds = %sift2_have_left
  %gep_c2.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_c2.pre.pre = load i32, i32* %gep_c2.phi.trans.insert.phi.trans.insert, align 4
  br label %sift2_choose_left

sift2_check_right:                                ; preds = %sift2_have_left
  %gep_r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_r2 = load i32, i32* %gep_r2, align 4
  %gep_l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_l2 = load i32, i32* %gep_l2, align 4
  %cmp_gt2 = icmp sgt i32 %val_r2, %val_l2
  br i1 %cmp_gt2, label %sift2_chosen, label %sift2_choose_left

sift2_choose_left:                                ; preds = %sift2_have_left.sift2_choose_left_crit_edge, %sift2_check_right
  %val_c2.pre = phi i32 [ %val_c2.pre.pre, %sift2_have_left.sift2_choose_left_crit_edge ], [ %val_l2, %sift2_check_right ]
  br label %sift2_chosen

sift2_chosen:                                     ; preds = %sift2_check_right, %sift2_choose_left
  %val_c2 = phi i32 [ %val_c2.pre, %sift2_choose_left ], [ %val_r2, %sift2_check_right ]
  %child2_idx = phi i64 [ %left2, %sift2_choose_left ], [ %right2, %sift2_check_right ]
  %gep_s2 = getelementptr inbounds i32, i32* %arr, i64 %s2
  %val_s2 = load i32, i32* %gep_s2, align 4
  %gep_c2 = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  %cmp_ge2.not = icmp slt i32 %val_s2, %val_c2
  br i1 %cmp_ge2.not, label %sift2_swap, label %outer_latch

sift2_swap:                                       ; preds = %sift2_chosen
  store i32 %val_c2, i32* %gep_s2, align 4
  store i32 %val_s2, i32* %gep_c2, align 4
  br label %sift2_head

outer_latch:                                      ; preds = %sift2_chosen, %sift2_head
  br label %outer_header

ret:                                              ; preds = %outer_header, %entry
  ret void
}
