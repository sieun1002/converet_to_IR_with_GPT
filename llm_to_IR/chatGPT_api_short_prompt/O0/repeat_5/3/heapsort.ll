; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place ascending heap sort of 32-bit integers (confidence=0.98). Evidence: heapify and sift-down using 2*i+1/2*i+2 children, swapping, and shrinking heap.
; Preconditions: arr points to at least n i32 elements.
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

build_init:                                         ; build max-heap
  %half = lshr i64 %n, 1
  br label %build_loop

build_loop:
  %cur = phi i64 [ %half, %build_init ], [ %cur_next, %build_after_sift ]
  %cur_ne_0 = icmp ne i64 %cur, 0
  br i1 %cur_ne_0, label %build_body, label %build_done

build_body:
  %idx = add i64 %cur, -1
  br label %sift_loop

sift_loop:
  %parent = phi i64 [ %idx, %build_body ], [ %new_parent, %after_swap ]
  %parent_x2 = shl i64 %parent, 1
  %left = add i64 %parent_x2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %have_left, label %build_after_sift

have_left:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp_children, label %choose_left

cmp_children:
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:
  br label %largest_chosen

choose_left:
  br label %largest_chosen

largest_chosen:
  %largest = phi i64 [ %right, %choose_right ], [ %left, %choose_left ]
  %parent_ptr = getelementptr inbounds i32, i32* %arr, i64 %parent
  %parent_val = load i32, i32* %parent_ptr, align 4
  %largest_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest
  %largest_val = load i32, i32* %largest_ptr, align 4
  %parent_ge_largest = icmp sge i32 %parent_val, %largest_val
  br i1 %parent_ge_largest, label %build_after_sift, label %do_swap

do_swap:
  store i32 %largest_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %largest_ptr, align 4
  %new_parent = %largest
  br label %after_swap

after_swap:
  br label %sift_loop

build_after_sift:
  %cur_next = add i64 %cur, -1
  br label %build_loop

build_done:
  %end_init = add i64 %n, -1
  br label %outer_loop

outer_loop:                                         ; sortdown
  %end = phi i64 [ %end_init, %build_done ], [ %end_next, %after_outer_sift ]
  %end_ne_zero = icmp ne i64 %end, 0
  br i1 %end_ne_zero, label %outer_body, label %ret

outer_body:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %outer_sift

outer_sift:
  %p2 = phi i64 [ 0, %outer_body ], [ %new_p2, %outer_after_swap ]
  %p2_x2 = shl i64 %p2, 1
  %l2 = add i64 %p2_x2, 1
  %l2_lt_end = icmp ult i64 %l2, %end
  br i1 %l2_lt_end, label %have_left2, label %after_outer_sift

have_left2:
  %r2 = add i64 %l2, 1
  %r2_lt_end = icmp ult i64 %r2, %end
  br i1 %r2_lt_end, label %cmp_children2, label %choose_left2

cmp_children2:
  %l2_ptr = getelementptr inbounds i32, i32* %arr, i64 %l2
  %l2_val = load i32, i32* %l2_ptr, align 4
  %r2_ptr = getelementptr inbounds i32, i32* %arr, i64 %r2
  %r2_val = load i32, i32* %r2_ptr, align 4
  %r2_gt_l2 = icmp sgt i32 %r2_val, %l2_val
  br i1 %r2_gt_l2, label %choose_right2, label %choose_left2

choose_right2:
  br label %largest_chosen2

choose_left2:
  br label %largest_chosen2

largest_chosen2:
  %largest2 = phi i64 [ %r2, %choose_right2 ], [ %l2, %choose_left2 ]
  %p2_ptr = getelementptr inbounds i32, i32* %arr, i64 %p2
  %p2_val = load i32, i32* %p2_ptr, align 4
  %largest2_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %largest2_val = load i32, i32* %largest2_ptr, align 4
  %p2_ge = icmp sge i32 %p2_val, %largest2_val
  br i1 %p2_ge, label %after_outer_sift, label %outer_do_swap

outer_do_swap:
  store i32 %largest2_val, i32* %p2_ptr, align 4
  store i32 %p2_val, i32* %largest2_ptr, align 4
  %new_p2 = %largest2
  br label %outer_after_swap

outer_after_swap:
  br label %outer_sift

after_outer_sift:
  %end_next = add i64 %end, -1
  br label %outer_loop

ret:
  ret void
}