; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of a 32-bit integer array (confidence=0.98). Evidence: sift-down loops with 2*i+1 children; swap max with end and reduce heap.
; Preconditions: %a points to at least %n contiguous i32 elements; %n is the number of elements to sort.
; Postconditions: Array [%a, %a+%n) is sorted in nondecreasing order.

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n1 = icmp ule i64 %n, 1
  br i1 %cmp_n1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  %start = add i64 %half, -1
  br label %build_loop_header

build_loop_header:
  %i = phi i64 [ %start, %build_init ], [ %i_dec, %build_iter_end ]
  %i_ge0 = icmp sge i64 %i, 0
  br i1 %i_ge0, label %build_iter, label %sort_init

build_iter:
  br label %sift1_check_child

sift1_check_child:
  %cur = phi i64 [ %i, %build_iter ], [ %new_cur, %sift1_swap ]
  %cur2 = shl i64 %cur, 1
  %left = add i64 %cur2, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %sift1_has_left, label %build_iter_end

sift1_has_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in, label %sift1_cmp_children, label %sift1_choose_left

sift1_cmp_children:
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %sift1_choose_right, label %sift1_choose_left

sift1_choose_right:
  br label %sift1_child_chosen

sift1_choose_left:
  br label %sift1_child_chosen

sift1_child_chosen:
  %child_idx = phi i64 [ %right, %sift1_choose_right ], [ %left, %sift1_choose_left ]
  %child_val = phi i32 [ %right_val, %sift1_choose_right ], [ %left_val, %sift1_choose_left ]
  %cur_ptr = getelementptr inbounds i32, i32* %a, i64 %cur
  %cur_val = load i32, i32* %cur_ptr, align 4
  %cur_ge_child = icmp sge i32 %cur_val, %child_val
  br i1 %cur_ge_child, label %build_iter_end, label %sift1_swap

sift1_swap:
  %child_ptr = getelementptr inbounds i32, i32* %a, i64 %child_idx
  store i32 %child_val, i32* %cur_ptr, align 4
  store i32 %cur_val, i32* %child_ptr, align 4
  %new_cur = add i64 %child_idx, 0
  br label %sift1_check_child

build_iter_end:
  %i_back = phi i64 [ %i, %sift1_check_child ], [ %i, %sift1_child_chosen ]
  %i_dec = add i64 %i_back, -1
  br label %build_loop_header

sort_init:
  %end0 = add i64 %n, -1
  br label %loop2_header

loop2_header:
  %end = phi i64 [ %end0, %sort_init ], [ %end_dec, %loop2_iter_end ]
  %cont = icmp ne i64 %end, 0
  br i1 %cont, label %loop2_iter, label %ret

loop2_iter:
  %a0 = load i32, i32* %a, align 4
  %end_ptr = getelementptr inbounds i32, i32* %a, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %a, align 4
  store i32 %a0, i32* %end_ptr, align 4
  br label %sift2_check

sift2_check:
  %cur2 = phi i64 [ 0, %loop2_iter ], [ %new_cur2, %sift2_swap ]
  %cur2_dbl = shl i64 %cur2, 1
  %left2 = add i64 %cur2_dbl, 1
  %has_left2 = icmp ult i64 %left2, %end
  br i1 %has_left2, label %sift2_has_left, label %loop2_iter_end

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  %left_ptr2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  br i1 %right2_in, label %sift2_cmp_children, label %sift2_choose_left

sift2_cmp_children:
  %right_ptr2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %right_gt_left2 = icmp sgt i32 %right_val2, %left_val2
  br i1 %right_gt_left2, label %sift2_choose_right, label %sift2_choose_left

sift2_choose_right:
  br label %sift2_child_chosen

sift2_choose_left:
  br label %sift2_child_chosen

sift2_child_chosen:
  %child_idx2 = phi i64 [ %right2, %sift2_choose_right ], [ %left2, %sift2_choose_left ]
  %child_val2 = phi i32 [ %right_val2, %sift2_choose_right ], [ %left_val2, %sift2_choose_left ]
  %cur_ptr2 = getelementptr inbounds i32, i32* %a, i64 %cur2
  %cur_val2 = load i32, i32* %cur_ptr2, align 4
  %cur_ge_child2 = icmp sge i32 %cur_val2, %child_val2
  br i1 %cur_ge_child2, label %loop2_iter_end, label %sift2_swap

sift2_swap:
  %child_ptr2 = getelementptr inbounds i32, i32* %a, i64 %child_idx2
  store i32 %child_val2, i32* %cur_ptr2, align 4
  store i32 %cur_val2, i32* %child_ptr2, align 4
  %new_cur2 = add i64 %child_idx2, 0
  br label %sift2_check

loop2_iter_end:
  %end_dec = add i64 %end, -1
  br label %loop2_header

ret:
  ret void
}