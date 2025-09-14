; target triple is optional; adjust if needed
; target triple = "x86_64-pc-linux-gnu"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

; Build max-heap phase
build_init:
  %halfn = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:                                ; i_prev loop
  %i_prev = phi i64 [ %halfn, %build_init ], [ %i_prev_next, %build_iter_end ]
  %i_prev_ne_0 = icmp ne i64 %i_prev, 0
  br i1 %i_prev_ne_0, label %prep_iter, label %build_done

prep_iter:
  %i_cur = add i64 %i_prev, -1
  br label %sift_heapify

sift_heapify:                                      ; percolate down within [0..n)
  %k = phi i64 [ %i_cur, %prep_iter ], [ %k_next, %do_swap ]
  %k2 = add i64 %k, %k
  %left = add i64 %k2, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %check_right, label %build_iter_end

check_right:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %has_right, label %compare_children, label %child_is_left

compare_children:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %child_index_sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %child_selected

child_is_left:
  br label %child_selected

child_selected:
  %child_idx = phi i64 [ %child_index_sel, %compare_children ], [ %left, %child_is_left ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  %child_val = load i32, i32* %child_ptr, align 4
  %k_ge_child = icmp sge i32 %k_val, %child_val
  br i1 %k_ge_child, label %build_iter_end, label %do_swap

do_swap:
  store i32 %child_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %child_ptr, align 4
  %k_next = add i64 %child_idx, 0
  br label %sift_heapify

build_iter_end:
  %i_prev_next = add i64 %i_prev, -1
  br label %build_loop_header

build_done:
  %end_init = add i64 %n, -1
  br label %extract_loop_header

; Extraction phase
extract_loop_header:
  %end = phi i64 [ %end_init, %build_done ], [ %end_next, %extraction_after_sift ]
  %end_ne_0 = icmp ne i64 %end, 0
  br i1 %end_ne_0, label %extract_swap, label %ret

extract_swap:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %extract_sift

extract_sift:
  %k2_ex = phi i64 [ 0, %extract_swap ], [ %k2_next, %do_swap_ex ]
  %k2_dbl = add i64 %k2_ex, %k2_ex
  %left_ex = add i64 %k2_dbl, 1
  %has_left_ex = icmp ult i64 %left_ex, %end
  br i1 %has_left_ex, label %check_right_ex, label %extraction_after_sift

check_right_ex:
  %right_ex = add i64 %left_ex, 1
  %has_right_ex = icmp ult i64 %right_ex, %end
  %left_ptr_ex = getelementptr inbounds i32, i32* %arr, i64 %left_ex
  %left_val_ex = load i32, i32* %left_ptr_ex, align 4
  br i1 %has_right_ex, label %compare_children_ex, label %child_is_left_ex

compare_children_ex:
  %right_ptr_ex = getelementptr inbounds i32, i32* %arr, i64 %right_ex
  %right_val_ex = load i32, i32* %right_ptr_ex, align 4
  %right_gt_left_ex = icmp sgt i32 %right_val_ex, %left_val_ex
  %child_index_sel_ex = select i1 %right_gt_left_ex, i64 %right_ex, i64 %left_ex
  br label %child_selected_ex

child_is_left_ex:
  br label %child_selected_ex

child_selected_ex:
  %child_idx_ex = phi i64 [ %child_index_sel_ex, %compare_children_ex ], [ %left_ex, %child_is_left_ex ]
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2_ex
  %k2_val = load i32, i32* %k2_ptr, align 4
  %child_ptr_ex = getelementptr inbounds i32, i32* %arr, i64 %child_idx_ex
  %child_val_ex = load i32, i32* %child_ptr_ex, align 4
  %k_ge_child_ex = icmp sge i32 %k2_val, %child_val_ex
  br i1 %k_ge_child_ex, label %extraction_after_sift, label %do_swap_ex

do_swap_ex:
  store i32 %child_val_ex, i32* %k2_ptr, align 4
  store i32 %k2_val, i32* %child_ptr_ex, align 4
  %k2_next = add i64 %child_idx_ex, 0
  br label %extract_sift

extraction_after_sift:
  %end_next = add i64 %end, -1
  br label %extract_loop_header

ret:
  ret void
}