; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %build_start

build_start:
  %half = lshr i64 %n, 1
  br label %build_outer

build_outer:
  %i_cur = phi i64 [ %half, %build_start ], [ %i_next, %build_outer_continue ]
  br label %sift_header

sift_header:
  %i_sift = phi i64 [ %i_cur, %build_outer ], [ %largest2, %do_swap2 ]
  %i2 = shl i64 %i_sift, 1
  %left = add i64 %i2, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %choose_child, label %build_outer_exit2

choose_child:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  br i1 %has_right, label %cmp_siblings2, label %select_left

cmp_siblings2:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %largest2_tmp = select i1 %right_gt_left, i64 %right, i64 %left
  br label %after_choose2

select_left:
  br label %after_choose2

after_choose2:
  %largest2 = phi i64 [ %largest2_tmp, %cmp_siblings2 ], [ %left, %select_left ]
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i_sift
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_l = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %val_l = load i32, i32* %ptr_l, align 4
  %less = icmp slt i32 %val_i, %val_l
  br i1 %less, label %do_swap2, label %build_outer_exit2

do_swap2:
  store i32 %val_l, i32* %ptr_i, align 4
  store i32 %val_i, i32* %ptr_l, align 4
  br label %sift_header

build_outer_exit2:
  %is_zero = icmp eq i64 %i_cur, 0
  br i1 %is_zero, label %sort_phase_entry, label %build_outer_continue

build_outer_continue:
  %i_next = add i64 %i_cur, -1
  br label %build_outer

sort_phase_entry:
  %heap_end = add i64 %n, -1
  br label %sort_outer

sort_outer:
  %end_phi = phi i64 [ %heap_end, %sort_phase_entry ], [ %end_dec, %sort_outer_endcheck ]
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end_phi
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %sift2_header

sift2_header:
  %i2_cur = phi i64 [ 0, %sort_outer ], [ %largest3, %do_swap3 ]
  %left2_shl = shl i64 %i2_cur, 1
  %left2 = add i64 %left2_shl, 1
  %has_left2 = icmp ult i64 %left2, %end_phi
  br i1 %has_left2, label %choose_child2, label %sort_outer_end

choose_child2:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %end_phi
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  br i1 %has_right2, label %cmp_siblings3, label %select_left2

cmp_siblings3:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %right_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %largest3_tmp = select i1 %right_gt_left2, i64 %right2, i64 %left2
  br label %after_choose3

select_left2:
  br label %after_choose3

after_choose3:
  %largest3 = phi i64 [ %largest3_tmp, %cmp_siblings3 ], [ %left2, %select_left2 ]
  %ptr_i2 = getelementptr inbounds i32, i32* %arr, i64 %i2_cur
  %val_i2 = load i32, i32* %ptr_i2, align 4
  %ptr_l3 = getelementptr inbounds i32, i32* %arr, i64 %largest3
  %val_l3 = load i32, i32* %ptr_l3, align 4
  %less2 = icmp slt i32 %val_i2, %val_l3
  br i1 %less2, label %do_swap3, label %sort_outer_end

do_swap3:
  store i32 %val_l3, i32* %ptr_i2, align 4
  store i32 %val_i2, i32* %ptr_l3, align 4
  br label %sift2_header

sort_outer_end:
  br label %sort_outer_endcheck

sort_outer_endcheck:
  %end_dec = add i64 %end_phi, -1
  %cond2 = icmp ne i64 %end_dec, 0
  br i1 %cond2, label %sort_outer, label %ret

ret:
  ret void
}