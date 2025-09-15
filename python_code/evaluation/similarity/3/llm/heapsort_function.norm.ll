; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/heapsort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le_1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.header

build.header:                                     ; preds = %sift.exit, %build.init
  %i_prev = phi i64 [ %half, %build.init ], [ %i_dec, %sift.exit ]
  %i_dec = add i64 %i_prev, -1
  %test_nonzero.not = icmp eq i64 %i_prev, 0
  br i1 %test_nonzero.not, label %extract.header, label %sift.loop

sift.loop:                                        ; preds = %build.header, %do_swap
  %i_cur = phi i64 [ %child, %do_swap ], [ %i_dec, %build.header ]
  %i_dbl = shl i64 %i_cur, 1
  %j = or i64 %i_dbl, 1
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %have_left, label %sift.exit

have_left:                                        ; preds = %sift.loop
  %k = add i64 %i_dbl, 2
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %cmp_right, label %have_left.choose_left_crit_edge

have_left.choose_left_crit_edge:                  ; preds = %have_left
  %child_ptr.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %j
  %child_val.pre.pre = load i32, i32* %child_ptr.phi.trans.insert.phi.trans.insert, align 4
  br label %choose_left

cmp_right:                                        ; preds = %have_left
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %k_gt_j = icmp sgt i32 %k_val, %j_val
  br i1 %k_gt_j, label %child_merge, label %choose_left

choose_left:                                      ; preds = %have_left.choose_left_crit_edge, %cmp_right
  %child_val.pre = phi i32 [ %child_val.pre.pre, %have_left.choose_left_crit_edge ], [ %j_val, %cmp_right ]
  br label %child_merge

child_merge:                                      ; preds = %cmp_right, %choose_left
  %child_val = phi i32 [ %child_val.pre, %choose_left ], [ %k_val, %cmp_right ]
  %child = phi i64 [ %j, %choose_left ], [ %k, %cmp_right ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %i_val = load i32, i32* %i_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %i_ge_child.not = icmp slt i32 %i_val, %child_val
  br i1 %i_ge_child.not, label %do_swap, label %sift.exit

do_swap:                                          ; preds = %child_merge
  store i32 %child_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %child_ptr, align 4
  br label %sift.loop

sift.exit:                                        ; preds = %child_merge, %sift.loop
  br label %build.header

extract.header:                                   ; preds = %build.header, %post.sift
  %m.in = phi i64 [ %m, %post.sift ], [ %n, %build.header ]
  %m = add i64 %m.in, -1
  %m_ne_zero.not = icmp eq i64 %m, 0
  br i1 %m_ne_zero.not, label %ret, label %extract.body

extract.body:                                     ; preds = %extract.header
  %root_val = load i32, i32* %arr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %arr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %post.sift.loop

post.sift.loop:                                   ; preds = %post.do.swap, %extract.body
  %i2_cur = phi i64 [ 0, %extract.body ], [ %child2, %post.do.swap ]
  %i2_dbl = shl i64 %i2_cur, 1
  %j2 = or i64 %i2_dbl, 1
  %j2_lt_m = icmp ult i64 %j2, %m
  br i1 %j2_lt_m, label %post.have_left, label %post.sift

post.have_left:                                   ; preds = %post.sift.loop
  %k2 = add i64 %i2_dbl, 2
  %k2_lt_m = icmp ult i64 %k2, %m
  br i1 %k2_lt_m, label %post.cmp.right, label %post.have_left.post.choose.left_crit_edge

post.have_left.post.choose.left_crit_edge:        ; preds = %post.have_left
  %child2_ptr.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %j2
  %child2_val.pre.pre = load i32, i32* %child2_ptr.phi.trans.insert.phi.trans.insert, align 4
  br label %post.choose.left

post.cmp.right:                                   ; preds = %post.have_left
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %k2_gt_j2 = icmp sgt i32 %k2_val, %j2_val
  br i1 %k2_gt_j2, label %post.child.merge, label %post.choose.left

post.choose.left:                                 ; preds = %post.have_left.post.choose.left_crit_edge, %post.cmp.right
  %child2_val.pre = phi i32 [ %child2_val.pre.pre, %post.have_left.post.choose.left_crit_edge ], [ %j2_val, %post.cmp.right ]
  br label %post.child.merge

post.child.merge:                                 ; preds = %post.cmp.right, %post.choose.left
  %child2_val = phi i32 [ %child2_val.pre, %post.choose.left ], [ %k2_val, %post.cmp.right ]
  %child2 = phi i64 [ %j2, %post.choose.left ], [ %k2, %post.cmp.right ]
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2_cur
  %i2_val = load i32, i32* %i2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %i2_ge_child2.not = icmp slt i32 %i2_val, %child2_val
  br i1 %i2_ge_child2.not, label %post.do.swap, label %post.sift

post.do.swap:                                     ; preds = %post.child.merge
  store i32 %child2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %child2_ptr, align 4
  br label %post.sift.loop

post.sift:                                        ; preds = %post.sift.loop, %post.child.merge
  br label %extract.header

ret:                                              ; preds = %extract.header, %entry
  ret void
}
