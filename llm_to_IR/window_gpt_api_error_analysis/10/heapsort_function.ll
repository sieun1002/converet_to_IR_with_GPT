; ModuleID = 'heapsort'
source_filename = "heapsort.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %build_init

build_init:
  %i0 = lshr i64 %n, 1
  br label %build_outer

build_outer:
  %i = phi i64 [ %i0, %build_init ], [ %i_dec, %build_after_inner ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %sort_init, label %percolate_setup

percolate_setup:
  %j0 = add i64 %i, 0
  br label %percolate

percolate:
  %j = phi i64 [ %j0, %percolate_setup ], [ %j_next, %do_swap ]
  %mul = shl i64 %j, 1
  %left = add i64 %mul, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %have_left, label %build_after_inner

have_left:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_children, label %choose_left

cmp_children:
  %l_left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %l_left = load i32, i32* %l_left_ptr, align 4
  %l_right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %l_right = load i32, i32* %l_right_ptr, align 4
  %right_gt_left = icmp sgt i32 %l_right, %l_left
  br i1 %right_gt_left, label %select_right, label %choose_left

select_right:
  br label %child_selected

choose_left:
  br label %child_selected

child_selected:
  %k = phi i64 [ %right, %select_right ], [ %left, %choose_left ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %lt = icmp slt i32 %j_val, %k_val
  br i1 %lt, label %do_swap, label %build_after_inner

do_swap:
  store i32 %k_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %k_ptr, align 4
  %j_next = add i64 %k, 0
  br label %percolate

build_after_inner:
  %i_dec = add i64 %i, -1
  br label %build_outer

sort_init:
  %n_minus1 = add i64 %n, -1
  br label %sort_loop

sort_loop:
  %end = phi i64 [ %n_minus1, %sort_init ], [ %end_dec, %after_sift ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %pre_swap

pre_swap:
  %first_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %first_val = load i32, i32* %first_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %first_ptr, align 4
  store i32 %first_val, i32* %end_ptr, align 4
  br label %sift

sift:
  %j2 = phi i64 [ 0, %pre_swap ], [ %j2_next, %do_swap2 ]
  %mul2 = shl i64 %j2, 1
  %left2 = add i64 %mul2, 1
  %has_left2 = icmp ult i64 %left2, %end
  br i1 %has_left2, label %have_left2, label %after_sift

have_left2:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %end
  br i1 %has_right2, label %cmp_children2, label %choose_left2

cmp_children2:
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right_gt_left2, label %select_right2, label %choose_left2

select_right2:
  br label %child_selected2

choose_left2:
  br label %child_selected2

child_selected2:
  %k2 = phi i64 [ %right2, %select_right2 ], [ %left2, %choose_left2 ]
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %lt2 = icmp slt i32 %j2_val, %k2_val
  br i1 %lt2, label %do_swap2, label %after_sift

do_swap2:
  store i32 %k2_val, i32* %j2_ptr, align 4
  store i32 %j2_val, i32* %k2_ptr, align 4
  %j2_next = add i64 %k2, 0
  br label %sift

after_sift:
  %end_dec = add i64 %end, -1
  br label %sort_loop

ret:
  ret void
}