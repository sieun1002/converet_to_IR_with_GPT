; ModuleID = 'heapsort'
source_filename = "heapsort"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr #0 {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  %half_zero = icmp eq i64 %half, 0
  br i1 %half_zero, label %after_build, label %build_prep

build_prep:
  %i_start = add i64 %half, -1
  br label %build_loop

build_loop:
  %i = phi i64 [ %i_start, %build_prep ], [ %i_next, %build_after_heapify ]
  br label %heapify_b_entry

heapify_b_entry:
  %cur = phi i64 [ %i, %build_loop ], [ %cur_next, %heapify_b_swapped ]
  %cur_dbl = shl i64 %cur, 1
  %left = add i64 %cur_dbl, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %b_check_right, label %build_after_heapify

b_check_right:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in, label %b_cmp_lr, label %b_choose_left

b_cmp_lr:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %lr_gt = icmp sgt i32 %right_val, %left_val
  br i1 %lr_gt, label %b_largest_is_right, label %b_largest_is_left

b_largest_is_right:
  br label %b_have_largest

b_largest_is_left:
  br label %b_have_largest

b_choose_left:
  br label %b_have_largest

b_have_largest:
  %largest_idx = phi i64 [ %right, %b_largest_is_right ], [ %left, %b_largest_is_left ], [ %left, %b_choose_left ]
  %cur_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur
  %cur_val = load i32, i32* %cur_ptr, align 4
  %largest_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest_idx
  %largest_val = load i32, i32* %largest_ptr, align 4
  %need_swap = icmp slt i32 %cur_val, %largest_val
  br i1 %need_swap, label %heapify_b_swapped, label %build_after_heapify

heapify_b_swapped:
  store i32 %largest_val, i32* %cur_ptr, align 4
  store i32 %cur_val, i32* %largest_ptr, align 4
  %cur_next = phi i64 [ %largest_idx, %b_have_largest ]
  br label %heapify_b_entry

build_after_heapify:
  %done = icmp eq i64 %i, 0
  br i1 %done, label %after_build, label %build_dec

build_dec:
  %i_next = add i64 %i, -1
  br label %build_loop

after_build:
  %end_init = add i64 %n, -1
  br label %sort_loop

sort_loop:
  %end = phi i64 [ %end_init, %after_build ], [ %end_next, %post_heapify2 ]
  %check_end0 = icmp eq i64 %end, 0
  br i1 %check_end0, label %ret, label %do_swap

do_swap:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %heapify2_entry

heapify2_entry:
  %cur2 = phi i64 [ 0, %do_swap ], [ %cur2_next, %heapify2_swapped ]
  %cur2_dbl = shl i64 %cur2, 1
  %left2 = add i64 %cur2_dbl, 1
  %left2_in = icmp ult i64 %left2, %end
  br i1 %left2_in, label %check_right2, label %post_heapify2

check_right2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_in, label %cmp_lr2, label %choose_left2

cmp_lr2:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %lr_gt2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %lr_gt2, label %largest_right2, label %largest_left2

largest_right2:
  br label %have_largest2

largest_left2:
  br label %have_largest2

choose_left2:
  br label %have_largest2

have_largest2:
  %largest_idx2 = phi i64 [ %right2, %largest_right2 ], [ %left2, %largest_left2 ], [ %left2, %choose_left2 ]
  %cur2_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %cur2_val = load i32, i32* %cur2_ptr, align 4
  %largest2_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest_idx2
  %largest2_val = load i32, i32* %largest2_ptr, align 4
  %need_swap2 = icmp slt i32 %cur2_val, %largest2_val
  br i1 %need_swap2, label %heapify2_swapped, label %post_heapify2

heapify2_swapped:
  store i32 %largest2_val, i32* %cur2_ptr, align 4
  store i32 %cur2_val, i32* %largest2_ptr, align 4
  %cur2_next = phi i64 [ %largest_idx2, %have_largest2 ]
  br label %heapify2_entry

post_heapify2:
  %end_next = add i64 %end, -1
  br label %sort_loop

ret:
  ret void
}

attributes #0 = { nounwind }