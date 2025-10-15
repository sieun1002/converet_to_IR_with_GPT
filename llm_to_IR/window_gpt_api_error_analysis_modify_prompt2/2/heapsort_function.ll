; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_outer

build_outer:
  %cur = phi i64 [ %half, %build_init ], [ %dec, %after_sift ]
  %iszero = icmp eq i64 %cur, 0
  br i1 %iszero, label %after_build, label %sift_entry

sift_entry:
  br label %sift_loop

sift_loop:
  %i = phi i64 [ %cur, %sift_entry ], [ %larger_idx, %swap_and_continue ]
  %tmp1 = shl i64 %i, 1
  %left = add i64 %tmp1, 1
  %left_inbound = icmp ult i64 %left, %n
  br i1 %left_inbound, label %have_left, label %after_sift

have_left:
  %right = add i64 %left, 1
  %right_inbound = icmp ult i64 %right, %n
  br i1 %right_inbound, label %compare_children, label %choose_left

compare_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:
  br label %after_choose

choose_left:
  br label %after_choose

after_choose:
  %larger_idx = phi i64 [ %left, %choose_left ], [ %right, %choose_right ]
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_larger = getelementptr inbounds i32, i32* %arr, i64 %larger_idx
  %val_larger = load i32, i32* %ptr_larger, align 4
  %i_lt_larger = icmp slt i32 %val_i, %val_larger
  br i1 %i_lt_larger, label %swap_and_continue, label %after_sift

swap_and_continue:
  store i32 %val_larger, i32* %ptr_i, align 4
  store i32 %val_i, i32* %ptr_larger, align 4
  br label %sift_loop

after_sift:
  %dec = add i64 %cur, -1
  br label %build_outer

after_build:
  %n_minus1 = add i64 %n, -1
  br label %sort_outer

sort_outer:
  %end = phi i64 [ %n_minus1, %after_build ], [ %end_dec, %after_sift2_end ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract_max

extract_max:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %sift2_entry

sift2_entry:
  %root = phi i64 [ 0, %extract_max ], [ %larger2_idx, %swap_and_continue2 ]
  %tmp2 = shl i64 %root, 1
  %left2 = add i64 %tmp2, 1
  %left2_in = icmp ult i64 %left2, %end
  br i1 %left2_in, label %have_left2, label %sift2_end

have_left2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  br i1 %right2_in, label %compare_children2, label %choose_left2

compare_children2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %right2_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %right2_gt_left2, label %choose_right2, label %choose_left2

choose_right2:
  br label %after_choose2

choose_left2:
  br label %after_choose2

after_choose2:
  %larger2_idx = phi i64 [ %left2, %choose_left2 ], [ %right2, %choose_right2 ]
  %ptr_root = getelementptr inbounds i32, i32* %arr, i64 %root
  %val_root = load i32, i32* %ptr_root, align 4
  %ptr_larger2 = getelementptr inbounds i32, i32* %arr, i64 %larger2_idx
  %val_larger2 = load i32, i32* %ptr_larger2, align 4
  %root_lt = icmp slt i32 %val_root, %val_larger2
  br i1 %root_lt, label %swap_and_continue2, label %sift2_end

swap_and_continue2:
  store i32 %val_larger2, i32* %ptr_root, align 4
  store i32 %val_root, i32* %ptr_larger2, align 4
  br label %sift2_entry

sift2_end:
  %end_dec = add i64 %end, -1
  br label %after_sift2_end

after_sift2_end:
  br label %sort_outer

ret:
  ret void
}