; target: Windows x64, MSVC-style
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %exit, label %build_entry

build_entry:
  %i0 = lshr i64 %n, 1
  br label %build_dec

build_dec:
  %i_cur = phi i64 [ %i0, %build_entry ], [ %i_next, %build_iter_end ]
  %i_nonzero = icmp ne i64 %i_cur, 0
  %i_dec = add i64 %i_cur, -1
  br i1 %i_nonzero, label %build_enter, label %build_done

build_enter:
  br label %build_inner_header

build_inner_header:
  %j_build = phi i64 [ %i_dec, %build_enter ], [ %j_next, %build_swapped ]
  %j2x = shl i64 %j_build, 1
  %left = add i64 %j2x, 1
  %left_in_n = icmp ult i64 %left, %n
  br i1 %left_in_n, label %build_have_left, label %build_iter_end

build_have_left:
  %right = add i64 %left, 1
  %right_in_n = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in_n, label %build_check_right, label %build_select

build_check_right:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %r_gt_l = icmp sgt i32 %right_val, %left_val
  br label %build_select

build_select:
  %largest_idx = phi i64 [ %right, %build_check_right ], [ %left, %build_have_left ]
  %largest_val = phi i32 [ %right_val, %build_check_right ], [ %left_val, %build_have_left ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_build
  %j_val = load i32, i32* %j_ptr, align 4
  %j_lt_largest = icmp slt i32 %j_val, %largest_val
  br i1 %j_lt_largest, label %build_do_swap, label %build_iter_end

build_do_swap:
  %largest_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest_idx
  store i32 %largest_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %largest_ptr, align 4
  br label %build_swapped

build_swapped:
  %j_next = phi i64 [ %largest_idx, %build_do_swap ]
  br label %build_inner_header

build_iter_end:
  %i_next = add i64 %i_dec, 0
  br label %build_dec

build_done:
  %heap_end0 = add i64 %n, -1
  br label %extract_loop_header

extract_loop_header:
  %heap_end = phi i64 [ %heap_end0, %build_done ], [ %heap_end_next, %extract_after_sift ]
  %heap_nonzero = icmp ne i64 %heap_end, 0
  br i1 %heap_nonzero, label %extract_swap_root, label %exit

extract_swap_root:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %extract_sift_header

extract_sift_header:
  %j_ext = phi i64 [ 0, %extract_swap_root ], [ %j_ext_next, %extract_swapped ]
  %j_ext_shl = shl i64 %j_ext, 1
  %left_ext = add i64 %j_ext_shl, 1
  %left_in_heap = icmp ult i64 %left_ext, %heap_end
  br i1 %left_in_heap, label %extract_have_left, label %extract_after_sift

extract_have_left:
  %right_ext = add i64 %left_ext, 1
  %right_in_heap = icmp ult i64 %right_ext, %heap_end
  %left_ext_ptr = getelementptr inbounds i32, i32* %arr, i64 %left_ext
  %left_ext_val = load i32, i32* %left_ext_ptr, align 4
  br i1 %right_in_heap, label %extract_check_right, label %extract_select

extract_check_right:
  %right_ext_ptr = getelementptr inbounds i32, i32* %arr, i64 %right_ext
  %right_ext_val = load i32, i32* %right_ext_ptr, align 4
  %r_gt_l_ext = icmp sgt i32 %right_ext_val, %left_ext_val
  br label %extract_select

extract_select:
  %largest_idx_ext = phi i64 [ %right_ext, %extract_check_right ], [ %left_ext, %extract_have_left ]
  %largest_val_ext = phi i32 [ %right_ext_val, %extract_check_right ], [ %left_ext_val, %extract_have_left ]
  %j_ext_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_ext
  %j_ext_val = load i32, i32* %j_ext_ptr, align 4
  %j_ge_largest = icmp sge i32 %j_ext_val, %largest_val_ext
  br i1 %j_ge_largest, label %extract_after_sift, label %extract_do_swap

extract_do_swap:
  %largest_ext_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest_idx_ext
  store i32 %largest_val_ext, i32* %j_ext_ptr, align 4
  store i32 %j_ext_val, i32* %largest_ext_ptr, align 4
  br label %extract_swapped

extract_swapped:
  %j_ext_next = phi i64 [ %largest_idx_ext, %extract_do_swap ]
  br label %extract_sift_header

extract_after_sift:
  %heap_end_next = add i64 %heap_end, -1
  br label %extract_loop_header

exit:
  ret void
}