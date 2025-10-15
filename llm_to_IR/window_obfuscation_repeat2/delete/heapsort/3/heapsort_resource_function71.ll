; ModuleID = 'module'
source_filename = "sub_140001450.ll"
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %done, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop

build_loop:
  %i = phi i64 [ %half, %build_init ], [ %i1, %build_cont ]
  %i1 = add i64 %i, -1
  br label %sift1_head

sift1_head:
  %j = phi i64 [ %i1, %build_loop ], [ %m, %sift1_swap ]
  %j2 = shl i64 %j, 1
  %left = add i64 %j2, 1
  %cond_left = icmp ult i64 %left, %n
  br i1 %cond_left, label %sift1_has_left, label %build_cont

sift1_has_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %cmp_children, label %choose_left

cmp_children:
  %gep_r = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_r = load i32, i32* %gep_r, align 4
  %gep_l = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_l = load i32, i32* %gep_l, align 4
  %r_gt_l = icmp sgt i32 %val_r, %val_l
  br i1 %r_gt_l, label %choose_right, label %choose_left

choose_right:
  %m_right = phi i64 [ %right, %cmp_children ]
  br label %after_choose

choose_left:
  %m_left = phi i64 [ %left, %cmp_children ], [ %left, %sift1_has_left ]
  br label %after_choose

after_choose:
  %m = phi i64 [ %m_right, %choose_right ], [ %m_left, %choose_left ]
  %gep_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val_j = load i32, i32* %gep_j, align 4
  %gep_m = getelementptr inbounds i32, i32* %arr, i64 %m
  %val_m = load i32, i32* %gep_m, align 4
  %j_lt_m = icmp slt i32 %val_j, %val_m
  br i1 %j_lt_m, label %sift1_swap, label %build_cont

sift1_swap:
  store i32 %val_m, i32* %gep_j, align 4
  store i32 %val_j, i32* %gep_m, align 4
  br label %sift1_head

build_cont:
  %i1_is_zero = icmp eq i64 %i1, 0
  br i1 %i1_is_zero, label %extract_init, label %build_loop

extract_init:
  %k = add i64 %n, -1
  br label %extract_cond

extract_cond:
  %heap_k = phi i64 [ %k, %extract_init ], [ %k_next, %extract_iter_end ]
  %cond_k_zero = icmp eq i64 %heap_k, 0
  br i1 %cond_k_zero, label %done, label %extract_body

extract_body:
  %gep0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %gep0, align 4
  %gep_k = getelementptr inbounds i32, i32* %arr, i64 %heap_k
  %vk = load i32, i32* %gep_k, align 4
  store i32 %vk, i32* %gep0, align 4
  store i32 %v0, i32* %gep_k, align 4
  br label %sift2_head

sift2_head:
  %j2_ = phi i64 [ 0, %extract_body ], [ %m2, %sift2_swap ]
  %j2_times2 = shl i64 %j2_, 1
  %left2 = add i64 %j2_times2, 1
  %left2_in = icmp ult i64 %left2, %heap_k
  br i1 %left2_in, label %sift2_has_left, label %extract_iter_end

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %heap_k
  br i1 %right2_in, label %cmp_children2, label %choose_left2

cmp_children2:
  %gep_r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_r2 = load i32, i32* %gep_r2, align 4
  %gep_l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_l2 = load i32, i32* %gep_l2, align 4
  %r_gt_l2 = icmp sgt i32 %val_r2, %val_l2
  br i1 %r_gt_l2, label %choose_right2, label %choose_left2

choose_right2:
  %m_right2 = phi i64 [ %right2, %cmp_children2 ]
  br label %after_choose2

choose_left2:
  %m_left2 = phi i64 [ %left2, %cmp_children2 ], [ %left2, %sift2_has_left ]
  br label %after_choose2

after_choose2:
  %m2 = phi i64 [ %m_right2, %choose_right2 ], [ %m_left2, %choose_left2 ]
  %gep_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2_
  %val_j2 = load i32, i32* %gep_j2, align 4
  %gep_m2 = getelementptr inbounds i32, i32* %arr, i64 %m2
  %val_m2 = load i32, i32* %gep_m2, align 4
  %j_ge_m = icmp sge i32 %val_j2, %val_m2
  br i1 %j_ge_m, label %extract_iter_end, label %sift2_swap

sift2_swap:
  store i32 %val_m2, i32* %gep_j2, align 4
  store i32 %val_j2, i32* %gep_m2, align 4
  br label %sift2_head

extract_iter_end:
  %k_next = add i64 %heap_k, -1
  br label %extract_cond

done:
  ret void
}