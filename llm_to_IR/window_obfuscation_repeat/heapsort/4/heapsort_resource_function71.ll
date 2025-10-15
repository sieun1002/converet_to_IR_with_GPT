; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %build_init

build_init:
  %i0 = lshr i64 %n, 1
  br label %build_dec

build_dec:
  %i_phi = phi i64 [ %i0, %build_init ], [ %i_next, %build_after_sift ]
  %is_zero = icmp eq i64 %i_phi, 0
  br i1 %is_zero, label %sort_init, label %sift_prep

sift_prep:
  %j_start = add i64 %i_phi, -1
  br label %sift_loop

sift_loop:
  %j_phi = phi i64 [ %j_start, %sift_prep ], [ %j_new, %do_swap ]
  %mul = shl i64 %j_phi, 1
  %left = add i64 %mul, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %have_left, label %build_after_sift

have_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %cmp_children, label %choose_left

cmp_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %gt = icmp sgt i32 %val_right, %val_left
  br i1 %gt, label %choose_right, label %choose_left

choose_right:
  %maxidx_r = phi i64 [ %right, %cmp_children ]
  br label %have_max

choose_left:
  %maxidx_l = phi i64 [ %left, %have_left ], [ %left, %cmp_children ]
  br label %have_max

have_max:
  %max_index = phi i64 [ %maxidx_r, %choose_right ], [ %maxidx_l, %choose_left ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j_phi
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_max = getelementptr inbounds i32, i32* %arr, i64 %max_index
  %val_max = load i32, i32* %ptr_max, align 4
  %lt = icmp slt i32 %val_j, %val_max
  br i1 %lt, label %do_swap, label %build_after_sift

do_swap:
  store i32 %val_max, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_max, align 4
  %j_new = add i64 %max_index, 0
  br label %sift_loop

build_after_sift:
  %i_next = add i64 %i_phi, -1
  br label %build_dec

sort_init:
  %end_init = add i64 %n, -1
  br label %outer_sort

outer_sort:
  %end = phi i64 [ %end_init, %sort_init ], [ %end_dec, %after_inner ]
  %cont = icmp eq i64 %end, 0
  br i1 %cont, label %ret, label %swap_root

swap_root:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %ptr_end, align 4
  store i32 %vend, i32* %ptr0, align 4
  store i32 %v0, i32* %ptr_end, align 4
  br label %inner_loop

inner_loop:
  %j2 = phi i64 [ 0, %swap_root ], [ %j2_new, %inner_swap ]
  %mul2 = shl i64 %j2, 1
  %left2 = add i64 %mul2, 1
  %left_in2 = icmp ult i64 %left2, %end
  br i1 %left_in2, label %have_left2, label %after_inner

have_left2:
  %right2 = add i64 %left2, 1
  %right_in2 = icmp ult i64 %right2, %end
  br i1 %right_in2, label %cmp_children2, label %choose_left2

cmp_children2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %gt2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %gt2, label %choose_right2, label %choose_left2

choose_right2:
  %maxidx_r2 = phi i64 [ %right2, %cmp_children2 ]
  br label %have_max2

choose_left2:
  %maxidx_l2 = phi i64 [ %left2, %have_left2 ], [ %left2, %cmp_children2 ]
  br label %have_max2

have_max2:
  %max_index2 = phi i64 [ %maxidx_r2, %choose_right2 ], [ %maxidx_l2, %choose_left2 ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %max_index2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %ge = icmp sge i32 %val_j2, %val_max2
  br i1 %ge, label %after_inner, label %inner_swap

inner_swap:
  store i32 %val_max2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_max2, align 4
  %j2_new = add i64 %max_index2, 0
  br label %inner_loop

after_inner:
  %end_dec = add i64 %end, -1
  br label %outer_sort

ret:
  ret void
}