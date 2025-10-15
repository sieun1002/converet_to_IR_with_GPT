; Heapsort for signed 32-bit integers: void sub_140001450(i32* %arr, i64 %n)
define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp_small = icmp ule i64 %n, 1
  br i1 %cmp_small, label %exit, label %build_init

build_init:
  %k0 = lshr i64 %n, 1
  br label %build_latch

build_latch:
  %k = phi i64 [ %k0, %build_init ], [ %k_next, %build_body_end ]
  %cond0 = icmp eq i64 %k, 0
  br i1 %cond0, label %phase2_init, label %build_start

build_start:
  %i0 = add i64 %k, -1
  br label %sift1_header

sift1_header:
  %i1 = phi i64 [ %i0, %build_start ], [ %i_next, %sift1_swap ]
  %left_mul = mul i64 %i1, 2
  %left = add i64 %left_mul, 1
  %left_in_range = icmp ult i64 %left, %n
  br i1 %left_in_range, label %sift1_has_left, label %build_body_end

sift1_has_left:
  %right = add i64 %left, 1
  %right_in_range = icmp ult i64 %right, %n
  br i1 %right_in_range, label %sift1_both, label %sift1_only_left

sift1_both:
  %pleft_both = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left_both = load i32, i32* %pleft_both, align 4
  %pright_both = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right_both = load i32, i32* %pright_both, align 4
  %right_gt_left = icmp sgt i32 %val_right_both, %val_left_both
  %child_index_both = select i1 %right_gt_left, i64 %right, i64 %left
  br label %sift1_choose_child

sift1_only_left:
  br label %sift1_choose_child

sift1_choose_child:
  %child = phi i64 [ %child_index_both, %sift1_both ], [ %left, %sift1_only_left ]
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i1
  %vi = load i32, i32* %pi, align 4
  %pc = getelementptr inbounds i32, i32* %arr, i64 %child
  %vc = load i32, i32* %pc, align 4
  %cmp_i_lt_child = icmp slt i32 %vi, %vc
  br i1 %cmp_i_lt_child, label %sift1_swap, label %build_body_end

sift1_swap:
  store i32 %vc, i32* %pi, align 4
  store i32 %vi, i32* %pc, align 4
  %i_next = add i64 %child, 0
  br label %sift1_header

build_body_end:
  %k_next = add i64 %k, -1
  br label %build_latch

phase2_init:
  %end0 = add i64 %n, -1
  br label %outer2_header

outer2_header:
  %end = phi i64 [ %end0, %phase2_init ], [ %end_next, %outer2_latch ]
  %cmp_end_zero = icmp eq i64 %end, 0
  br i1 %cmp_end_zero, label %exit, label %outer2_swap

outer2_swap:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2_header

sift2_header:
  %i2 = phi i64 [ 0, %outer2_swap ], [ %i2_next, %sift2_swap ]
  %left2_mul = mul i64 %i2, 2
  %left2 = add i64 %left2_mul, 1
  %left2_in_range = icmp ult i64 %left2, %end
  br i1 %left2_in_range, label %sift2_has_left, label %outer2_latch

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2_in_range = icmp ult i64 %right2, %end
  br i1 %right2_in_range, label %sift2_both, label %sift2_only_left

sift2_both:
  %pleft2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %pleft2, align 4
  %pright2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %pright2, align 4
  %right_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %child2_idx_both = select i1 %right_gt_left2, i64 %right2, i64 %left2
  br label %sift2_choose

sift2_only_left:
  br label %sift2_choose

sift2_choose:
  %child2 = phi i64 [ %child2_idx_both, %sift2_both ], [ %left2, %sift2_only_left ]
  %pi2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %vi2 = load i32, i32* %pi2, align 4
  %pc2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %vc2 = load i32, i32* %pc2, align 4
  %cmp_i2_ge_child = icmp sge i32 %vi2, %vc2
  br i1 %cmp_i2_ge_child, label %outer2_latch, label %sift2_swap

sift2_swap:
  store i32 %vc2, i32* %pi2, align 4
  store i32 %vi2, i32* %pc2, align 4
  %i2_next = add i64 %child2, 0
  br label %sift2_header

outer2_latch:
  %end_next = add i64 %end, -1
  br label %outer2_header

exit:
  ret void
}