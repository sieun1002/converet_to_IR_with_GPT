; ModuleID = 'heap_sort'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %heapify_init

heapify_init:
  %half = lshr i64 %n, 1
  br label %heapify_check

heapify_check:
  %i = phi i64 [ %half, %heapify_init ], [ %i_next, %heapify_after_sift ]
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %build_done, label %heapify_iter

heapify_iter:
  %i_dec = add i64 %i, -1
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %i_dec, %heapify_iter ], [ %j_next, %sift_swapped ]
  %twj = add i64 %j, %j
  %left = add i64 %twj, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %has_left, label %heapify_after_sift

has_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %cmp_children, label %largest_left

cmp_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %gt_rl = icmp sgt i32 %val_right, %val_left
  br i1 %gt_rl, label %largest_right, label %largest_left

largest_right:
  %largest_r = phi i64 [ %right, %cmp_children ]
  br label %after_largest_select

largest_left:
  %largest_l = phi i64 [ %left, %has_left ], [ %left, %cmp_children ]
  br label %after_largest_select

after_largest_select:
  %largest = phi i64 [ %largest_r, %largest_right ], [ %largest_l, %largest_left ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_largest = getelementptr inbounds i32, i32* %arr, i64 %largest
  %val_largest = load i32, i32* %ptr_largest, align 4
  %lt = icmp slt i32 %val_j, %val_largest
  br i1 %lt, label %sift_swapped, label %heapify_after_sift

sift_swapped:
  store i32 %val_largest, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_largest, align 4
  %j_next = add i64 %largest, 0
  br label %sift_loop

heapify_after_sift:
  %i_next = add i64 %i, 0
  br label %heapify_check

build_done:
  %end_init = add i64 %n, -1
  br label %extract_check

extract_check:
  %end = phi i64 [ %end_init, %build_done ], [ %end_next, %after_inner_loop_advance ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract_body

extract_body:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %ptr_end, align 4
  store i32 %vend, i32* %ptr0, align 4
  store i32 %v0, i32* %ptr_end, align 4
  br label %inner_sift_loop

inner_sift_loop:
  %j2 = phi i64 [ 0, %extract_body ], [ %j2_next, %inner_swapped ]
  %twj2 = add i64 %j2, %j2
  %left2 = add i64 %twj2, 1
  %left2_in = icmp ult i64 %left2, %end
  br i1 %left2_in, label %has_left2, label %after_inner_loop

has_left2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  br i1 %right2_in, label %cmp_children2, label %largest_left2

cmp_children2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %gt_rl2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %gt_rl2, label %largest_right2, label %largest_left2

largest_right2:
  %largest_r2 = phi i64 [ %right2, %cmp_children2 ]
  br label %after_largest_select2

largest_left2:
  %largest_l2 = phi i64 [ %left2, %has_left2 ], [ %left2, %cmp_children2 ]
  br label %after_largest_select2

after_largest_select2:
  %largest2 = phi i64 [ %largest_r2, %largest_right2 ], [ %largest_l2, %largest_left2 ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_largest2 = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %val_largest2 = load i32, i32* %ptr_largest2, align 4
  %lt2 = icmp slt i32 %val_j2, %val_largest2
  br i1 %lt2, label %inner_swapped, label %after_inner_loop

inner_swapped:
  store i32 %val_largest2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_largest2, align 4
  %j2_next = add i64 %largest2, 0
  br label %inner_sift_loop

after_inner_loop:
  br label %after_inner_loop_advance

after_inner_loop_advance:
  %end_next_pre = add i64 %end, -1
  %end_next = add i64 %end_next_pre, 0
  br label %extract_check

ret:
  ret void
}