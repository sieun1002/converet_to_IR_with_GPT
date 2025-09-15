; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/heapsort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %exit, label %build.init

build.init:                                       ; preds = %entry
  %half0 = lshr i64 %n, 1
  br label %build.top

build.top:                                        ; preds = %build.end, %build.init
  %i_old1 = phi i64 [ %half0, %build.init ], [ %i_dec3, %build.end ]
  %cond2.not = icmp eq i64 %i_old1, 0
  br i1 %cond2.not, label %sort.loop.cond, label %build.body

build.body:                                       ; preds = %build.top
  %i_dec3 = add i64 %i_old1, -1
  br label %sift1.head

sift1.head:                                       ; preds = %sift1.swap, %build.body
  %k4 = phi i64 [ %i_dec3, %build.body ], [ %m_idx15, %sift1.swap ]
  %k2mul5 = shl i64 %k4, 1
  %left6 = or i64 %k2mul5, 1
  %left_ge_n7.not = icmp ult i64 %left6, %n
  br i1 %left_ge_n7.not, label %sift1.hasleft, label %build.end

sift1.hasleft:                                    ; preds = %sift1.head
  %right8 = add i64 %k2mul5, 2
  %right_in_range9 = icmp ult i64 %right8, %n
  br i1 %right_in_range9, label %s1.cmp.right, label %sift1.hasleft.s1.choose.left_crit_edge

sift1.hasleft.s1.choose.left_crit_edge:           ; preds = %sift1.hasleft
  %m_ptr18.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %left6
  %m_val19.pre.pre = load i32, i32* %m_ptr18.phi.trans.insert.phi.trans.insert, align 4
  br label %s1.choose.left

s1.cmp.right:                                     ; preds = %sift1.hasleft
  %left_ptr10 = getelementptr inbounds i32, i32* %arr, i64 %left6
  %left_val11 = load i32, i32* %left_ptr10, align 4
  %right_ptr12 = getelementptr inbounds i32, i32* %arr, i64 %right8
  %right_val13 = load i32, i32* %right_ptr12, align 4
  %gt14 = icmp sgt i32 %right_val13, %left_val11
  br i1 %gt14, label %s1.m.chosen, label %s1.choose.left

s1.choose.left:                                   ; preds = %sift1.hasleft.s1.choose.left_crit_edge, %s1.cmp.right
  %m_val19.pre = phi i32 [ %m_val19.pre.pre, %sift1.hasleft.s1.choose.left_crit_edge ], [ %left_val11, %s1.cmp.right ]
  br label %s1.m.chosen

s1.m.chosen:                                      ; preds = %s1.cmp.right, %s1.choose.left
  %m_val19 = phi i32 [ %m_val19.pre, %s1.choose.left ], [ %right_val13, %s1.cmp.right ]
  %m_idx15 = phi i64 [ %left6, %s1.choose.left ], [ %right8, %s1.cmp.right ]
  %k_ptr16 = getelementptr inbounds i32, i32* %arr, i64 %k4
  %k_val17 = load i32, i32* %k_ptr16, align 4
  %m_ptr18 = getelementptr inbounds i32, i32* %arr, i64 %m_idx15
  %ge20.not = icmp slt i32 %k_val17, %m_val19
  br i1 %ge20.not, label %sift1.swap, label %build.end

sift1.swap:                                       ; preds = %s1.m.chosen
  store i32 %m_val19, i32* %k_ptr16, align 4
  store i32 %k_val17, i32* %m_ptr18, align 4
  br label %sift1.head

build.end:                                        ; preds = %sift1.head, %s1.m.chosen
  br label %build.top

sort.loop.cond:                                   ; preds = %build.top, %after_sift2
  %end_cur22.in = phi i64 [ %end_cur22, %after_sift2 ], [ %n, %build.top ]
  %end_cur22 = add i64 %end_cur22.in, -1
  %nz23.not = icmp eq i64 %end_cur22, 0
  br i1 %nz23.not, label %exit, label %sort.body

sort.body:                                        ; preds = %sort.loop.cond
  %root_val25 = load i32, i32* %arr, align 4
  %end_ptr26 = getelementptr inbounds i32, i32* %arr, i64 %end_cur22
  %end_val27 = load i32, i32* %end_ptr26, align 4
  store i32 %end_val27, i32* %arr, align 4
  store i32 %root_val25, i32* %end_ptr26, align 4
  br label %sift2.head

sift2.head:                                       ; preds = %sift2.swap, %sort.body
  %k2_28 = phi i64 [ 0, %sort.body ], [ %m2_idx39, %sift2.swap ]
  %twok29 = shl i64 %k2_28, 1
  %left2_30 = or i64 %twok29, 1
  %left_ge_end31.not = icmp ult i64 %left2_30, %end_cur22
  br i1 %left_ge_end31.not, label %sift2.hasleft, label %after_sift2

sift2.hasleft:                                    ; preds = %sift2.head
  %right2_32 = add i64 %twok29, 2
  %right_in_range2_33 = icmp ult i64 %right2_32, %end_cur22
  br i1 %right_in_range2_33, label %s2.cmp.right, label %sift2.hasleft.s2.choose.left_crit_edge

sift2.hasleft.s2.choose.left_crit_edge:           ; preds = %sift2.hasleft
  %m2_ptr42.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %left2_30
  %m2_val43.pre.pre = load i32, i32* %m2_ptr42.phi.trans.insert.phi.trans.insert, align 4
  br label %s2.choose.left

s2.cmp.right:                                     ; preds = %sift2.hasleft
  %left_ptr2_34 = getelementptr inbounds i32, i32* %arr, i64 %left2_30
  %left_val2_35 = load i32, i32* %left_ptr2_34, align 4
  %right_ptr2_36 = getelementptr inbounds i32, i32* %arr, i64 %right2_32
  %right_val2_37 = load i32, i32* %right_ptr2_36, align 4
  %gt2_38 = icmp sgt i32 %right_val2_37, %left_val2_35
  br i1 %gt2_38, label %s2.m.chosen, label %s2.choose.left

s2.choose.left:                                   ; preds = %sift2.hasleft.s2.choose.left_crit_edge, %s2.cmp.right
  %m2_val43.pre = phi i32 [ %m2_val43.pre.pre, %sift2.hasleft.s2.choose.left_crit_edge ], [ %left_val2_35, %s2.cmp.right ]
  br label %s2.m.chosen

s2.m.chosen:                                      ; preds = %s2.cmp.right, %s2.choose.left
  %m2_val43 = phi i32 [ %m2_val43.pre, %s2.choose.left ], [ %right_val2_37, %s2.cmp.right ]
  %m2_idx39 = phi i64 [ %left2_30, %s2.choose.left ], [ %right2_32, %s2.cmp.right ]
  %k2_ptr40 = getelementptr inbounds i32, i32* %arr, i64 %k2_28
  %k2_val41 = load i32, i32* %k2_ptr40, align 4
  %m2_ptr42 = getelementptr inbounds i32, i32* %arr, i64 %m2_idx39
  %ge2_44.not = icmp slt i32 %k2_val41, %m2_val43
  br i1 %ge2_44.not, label %sift2.swap, label %after_sift2

sift2.swap:                                       ; preds = %s2.m.chosen
  store i32 %m2_val43, i32* %k2_ptr40, align 4
  store i32 %k2_val41, i32* %m2_ptr42, align 4
  br label %sift2.head

after_sift2:                                      ; preds = %s2.m.chosen, %sift2.head
  br label %sort.loop.cond

exit:                                             ; preds = %sort.loop.cond, %entry
  ret void
}
