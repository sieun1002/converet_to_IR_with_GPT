; ModuleID = 'heap_sort'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build_start

build_start:
  %half = lshr i64 %n, 1
  br label %build_header

build_header:
  %i = phi i64 [ %half, %build_start ], [ %i_next, %build_latch ]
  %cond_b = icmp ne i64 %i, 0
  br i1 %cond_b, label %build_body, label %after_build

build_body:
  %i_dec = add i64 %i, -1
  br label %sift1_head

sift1_head:
  %s1 = phi i64 [ %i_dec, %build_body ], [ %child1_idx, %sift1_swap ]
  %i_dec_keep = phi i64 [ %i_dec, %build_body ], [ %i_dec_keep, %sift1_swap ]
  %tmp2 = shl i64 %s1, 1
  %left1 = add i64 %tmp2, 1
  %cmp_left1 = icmp uge i64 %left1, %n
  br i1 %cmp_left1, label %build_latch, label %sift1_have_left

sift1_have_left:
  %right1 = add i64 %left1, 1
  %cmp_right_in = icmp ult i64 %right1, %n
  br i1 %cmp_right_in, label %sift1_check_right, label %sift1_choose_left

sift1_check_right:
  %gep_r1 = getelementptr inbounds i32, i32* %arr, i64 %right1
  %val_r1 = load i32, i32* %gep_r1, align 4
  %gep_l1 = getelementptr inbounds i32, i32* %arr, i64 %left1
  %val_l1 = load i32, i32* %gep_l1, align 4
  %cmp_gt = icmp sgt i32 %val_r1, %val_l1
  br i1 %cmp_gt, label %sift1_choose_right, label %sift1_choose_left

sift1_choose_right:
  br label %sift1_chosen

sift1_choose_left:
  br label %sift1_chosen

sift1_chosen:
  %child1_idx = phi i64 [ %right1, %sift1_choose_right ], [ %left1, %sift1_choose_left ]
  %gep_s1 = getelementptr inbounds i32, i32* %arr, i64 %s1
  %val_s1 = load i32, i32* %gep_s1, align 4
  %gep_c1 = getelementptr inbounds i32, i32* %arr, i64 %child1_idx
  %val_c1 = load i32, i32* %gep_c1, align 4
  %cmp_ge = icmp sge i32 %val_s1, %val_c1
  br i1 %cmp_ge, label %build_latch, label %sift1_swap

sift1_swap:
  store i32 %val_c1, i32* %gep_s1, align 4
  store i32 %val_s1, i32* %gep_c1, align 4
  br label %sift1_head

build_latch:
  %i_next = phi i64 [ %i_dec_keep, %sift1_head ], [ %i_dec_keep, %sift1_chosen ]
  br label %build_header

after_build:
  %n_minus1 = add i64 %n, -1
  br label %outer_header

outer_header:
  %m = phi i64 [ %n_minus1, %after_build ], [ %m_next, %outer_latch ]
  %cond_m = icmp ne i64 %m, 0
  br i1 %cond_m, label %outer_body, label %ret

outer_body:
  %a0 = load i32, i32* %arr, align 4
  %gep_am = getelementptr inbounds i32, i32* %arr, i64 %m
  %am = load i32, i32* %gep_am, align 4
  store i32 %am, i32* %arr, align 4
  store i32 %a0, i32* %gep_am, align 4
  br label %sift2_head

sift2_head:
  %s2 = phi i64 [ 0, %outer_body ], [ %child2_idx, %sift2_swap ]
  %m_keep = phi i64 [ %m, %outer_body ], [ %m_keep, %sift2_swap ]
  %tmp2a = shl i64 %s2, 1
  %left2 = add i64 %tmp2a, 1
  %cmp_left2 = icmp uge i64 %left2, %m_keep
  br i1 %cmp_left2, label %outer_latch, label %sift2_have_left

sift2_have_left:
  %right2 = add i64 %left2, 1
  %cmp_right2_in = icmp ult i64 %right2, %m_keep
  br i1 %cmp_right2_in, label %sift2_check_right, label %sift2_choose_left

sift2_check_right:
  %gep_r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_r2 = load i32, i32* %gep_r2, align 4
  %gep_l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_l2 = load i32, i32* %gep_l2, align 4
  %cmp_gt2 = icmp sgt i32 %val_r2, %val_l2
  br i1 %cmp_gt2, label %sift2_choose_right, label %sift2_choose_left

sift2_choose_right:
  br label %sift2_chosen

sift2_choose_left:
  br label %sift2_chosen

sift2_chosen:
  %child2_idx = phi i64 [ %right2, %sift2_choose_right ], [ %left2, %sift2_choose_left ]
  %gep_s2 = getelementptr inbounds i32, i32* %arr, i64 %s2
  %val_s2 = load i32, i32* %gep_s2, align 4
  %gep_c2 = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  %val_c2 = load i32, i32* %gep_c2, align 4
  %cmp_ge2 = icmp sge i32 %val_s2, %val_c2
  br i1 %cmp_ge2, label %outer_latch, label %sift2_swap

sift2_swap:
  store i32 %val_c2, i32* %gep_s2, align 4
  store i32 %val_s2, i32* %gep_c2, align 4
  br label %sift2_head

outer_latch:
  %m_used = phi i64 [ %m_keep, %sift2_head ], [ %m_keep, %sift2_chosen ]
  %m_next = add i64 %m_used, -1
  br label %outer_header

ret:
  ret void
}