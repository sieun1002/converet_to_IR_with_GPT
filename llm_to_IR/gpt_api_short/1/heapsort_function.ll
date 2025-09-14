; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heapsort of a 32-bit int array in ascending order (confidence=0.98). Evidence: max-heap build with left=2*i+1, right=2*i+2 and extraction phase swapping root with end and sifting down using signed comparisons.
; Preconditions: arr is a valid pointer to at least n 32-bit integers.
; Postconditions: arr[0..n-1] is sorted in non-decreasing (ascending) order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %exit, label %build_start

build_start:                                      ; build max-heap
  %half = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i = phi i64 [ %half, %build_start ], [ %i_next, %build_loop_latch ]
  %i_ne_0 = icmp ne i64 %i, 0
  br i1 %i_ne_0, label %sift_from_i, label %build_done

sift_from_i:
  %i0 = add i64 %i, -1
  br label %sift_loop

sift_loop:
  %cur = phi i64 [ %i0, %sift_from_i ], [ %cur_next, %sift_swapped ]
  %cur_x2 = shl i64 %cur, 1
  %left = add i64 %cur_x2, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %check_right, label %build_loop_latch

check_right:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %has_right, label %choose_child_with_right, label %choose_left_only

choose_child_with_right:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %child_index_sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %have_child

choose_left_only:
  br label %have_child

have_child:
  %child_index = phi i64 [ %child_index_sel, %choose_child_with_right ], [ %left, %choose_left_only ]
  %parent_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur
  %parent_val = load i32, i32* %parent_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_index
  %child_val = load i32, i32* %child_ptr, align 4
  %parent_ge_child = icmp sge i32 %parent_val, %child_val
  br i1 %parent_ge_child, label %build_loop_latch, label %sift_swapped

sift_swapped:
  store i32 %child_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %child_ptr, align 4
  %cur_next = %child_index
  br label %sift_loop

build_loop_latch:
  %i_next = add i64 %i, -1
  br label %build_loop_header

build_done:                                        ; extraction phase
  %heap_end_init = add i64 %n, -1
  br label %extract_loop_header

extract_loop_header:
  %heap_end = phi i64 [ %heap_end_init, %build_done ], [ %heap_end_dec, %extract_after_sift ]
  %heap_not_zero = icmp ne i64 %heap_end, 0
  br i1 %heap_not_zero, label %extract_swap, label %exit

extract_swap:
  %root_val = load i32, i32* %arr, align 4
  %last_ptr = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %last_val = load i32, i32* %last_ptr, align 4
  store i32 %last_val, i32* %arr, align 4
  store i32 %root_val, i32* %last_ptr, align 4
  br label %extract_sift_loop

extract_sift_loop:
  %cur2 = phi i64 [ 0, %extract_swap ], [ %cur2_next, %extract_swapped ]
  %cur2_x2 = shl i64 %cur2, 1
  %left2 = add i64 %cur2_x2, 1
  %left_in2 = icmp ult i64 %left2, %heap_end
  br i1 %left_in2, label %check_right2, label %extract_after_sift

check_right2:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %heap_end
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %has_right2, label %choose_child_with_right2, label %choose_left_only2

choose_child_with_right2:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %child2_idx_sel = select i1 %right_gt_left2, i64 %right2, i64 %left2
  br label %have_child2

choose_left_only2:
  br label %have_child2

have_child2:
  %child2_idx = phi i64 [ %child2_idx_sel, %choose_child_with_right2 ], [ %left2, %choose_left_only2 ]
  %parent2_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %parent2_val = load i32, i32* %parent2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  %child2_val = load i32, i32* %child2_ptr, align 4
  %parent_ge_child2 = icmp sge i32 %parent2_val, %child2_val
  br i1 %parent_ge_child2, label %extract_after_sift, label %extract_swapped

extract_swapped:
  store i32 %child2_val, i32* %parent2_ptr, align 4
  store i32 %parent2_val, i32* %child2_ptr, align 4
  %cur2_next = %child2_idx
  br label %extract_sift_loop

extract_after_sift:
  %heap_end_dec = add i64 %heap_end, -1
  br label %extract_loop_header

exit:
  ret void
}