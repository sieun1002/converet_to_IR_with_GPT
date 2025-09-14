; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of 32-bit integers (confidence=0.98). Evidence: 4-byte element indexing, heapify and sift-down loops

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i_phi = phi i64 [ %half, %build_init ], [ %i_next, %build_sift_done ]
  %is_zero = icmp eq i64 %i_phi, 0
  br i1 %is_zero, label %build_done, label %build_iter_enter

build_iter_enter:
  %idx0 = add i64 %i_phi, -1
  br label %sift1_header

sift1_header:
  %curr = phi i64 [ %idx0, %build_iter_enter ], [ %child_idx, %sift1_swap ]
  %curr_x2 = shl i64 %curr, 1
  %left = add i64 %curr_x2, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build_sift_done, label %sift1_has_left

sift1_has_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in, label %sift1_both, label %sift1_choose_left

sift1_both:
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %child_idx_sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %sift1_child_sel

sift1_choose_left:
  br label %sift1_child_sel

sift1_child_sel:
  %child_idx = phi i64 [ %child_idx_sel, %sift1_both ], [ %left, %sift1_has_left ]
  %curr_ptr = getelementptr inbounds i32, i32* %a, i64 %curr
  %curr_val = load i32, i32* %curr_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %a, i64 %child_idx
  %child_val = load i32, i32* %child_ptr, align 4
  %curr_ge_child = icmp sge i32 %curr_val, %child_val
  br i1 %curr_ge_child, label %build_sift_done, label %sift1_swap

sift1_swap:
  store i32 %child_val, i32* %curr_ptr, align 4
  store i32 %curr_val, i32* %child_ptr, align 4
  br label %sift1_header

build_sift_done:
  %i_next = add i64 %i_phi, -1
  br label %build_loop_header

build_done:
  %end_init = add i64 %n, -1
  br label %outer_header

outer_header:
  %end = phi i64 [ %end_init, %build_done ], [ %end_dec, %outer_after_sift ]
  %cond_end_zero = icmp eq i64 %end, 0
  br i1 %cond_end_zero, label %ret, label %outer_body

outer_body:
  %zero_ptr = getelementptr inbounds i32, i32* %a, i64 0
  %root_val = load i32, i32* %zero_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %a, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %zero_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %sift2_header

sift2_header:
  %curr2 = phi i64 [ 0, %outer_body ], [ %child2_idx, %sift2_swap ]
  %curr2_x2 = shl i64 %curr2, 1
  %left2 = add i64 %curr2_x2, 1
  %left2_ge_end = icmp uge i64 %left2, %end
  br i1 %left2_ge_end, label %outer_after_sift, label %sift2_has_left

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_in, label %sift2_both, label %sift2_choose_left

sift2_both:
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %child2_sel = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %sift2_child_sel

sift2_choose_left:
  br label %sift2_child_sel

sift2_child_sel:
  %child2_idx = phi i64 [ %child2_sel, %sift2_both ], [ %left2, %sift2_has_left ]
  %curr2_ptr = getelementptr inbounds i32, i32* %a, i64 %curr2
  %curr2_val = load i32, i32* %curr2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %a, i64 %child2_idx
  %child2_val = load i32, i32* %child2_ptr, align 4
  %curr2_ge_child2 = icmp sge i32 %curr2_val, %child2_val
  br i1 %curr2_ge_child2, label %outer_after_sift, label %sift2_swap

sift2_swap:
  store i32 %child2_val, i32* %curr2_ptr, align 4
  store i32 %curr2_val, i32* %child2_ptr, align 4
  br label %sift2_header

outer_after_sift:
  %end_dec = add i64 %end, -1
  br label %outer_header

ret:
  ret void
}