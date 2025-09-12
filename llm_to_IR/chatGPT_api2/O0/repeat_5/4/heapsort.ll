; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of a 32-bit integer array (ascending) (confidence=0.95). Evidence: max-heap build via sift-down and repeated root/end swaps with shrinking bound.
; Preconditions: %a points to at least %n contiguous i32 elements.

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_head

build_loop_head:
  %i.ph = phi i64 [ %half, %build_init ], [ %i.next, %build_iter_end ]
  %i_is_zero = icmp eq i64 %i.ph, 0
  br i1 %i_is_zero, label %build_done, label %build_predec

build_predec:
  %cur = add i64 %i.ph, -1
  br label %build_sift_head

build_sift_head:
  %idx = phi i64 [ %cur, %build_predec ], [ %idx.next, %build_sift_iter_end ]
  %cur.ph = phi i64 [ %cur, %build_predec ], [ %cur.ph, %build_sift_iter_end ]
  %twice = shl i64 %idx, 1
  %child = add i64 %twice, 1
  %child_ge_n = icmp uge i64 %child, %n
  br i1 %child_ge_n, label %build_iter_end, label %build_has_left

build_has_left:
  %right = add i64 %child, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %build_compare_children, label %build_choose_left

build_compare_children:
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %child
  %left_val = load i32, i32* %left_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %max_child_idx = select i1 %right_gt_left, i64 %right, i64 %child
  br label %build_after_choose_child

build_choose_left:
  br label %build_after_choose_child

build_after_choose_child:
  %max_child = phi i64 [ %max_child_idx, %build_compare_children ], [ %child, %build_choose_left ]
  %idx_ptr = getelementptr inbounds i32, i32* %a, i64 %idx
  %idx_val = load i32, i32* %idx_ptr, align 4
  %mc_ptr = getelementptr inbounds i32, i32* %a, i64 %max_child
  %mc_val = load i32, i32* %mc_ptr, align 4
  %idx_ge_mc = icmp sge i32 %idx_val, %mc_val
  br i1 %idx_ge_mc, label %build_iter_end, label %build_swap

build_swap:
  store i32 %mc_val, i32* %idx_ptr, align 4
  store i32 %idx_val, i32* %mc_ptr, align 4
  %idx.next = %max_child
  br label %build_sift_iter_end

build_sift_iter_end:
  br label %build_sift_head

build_iter_end:
  %i.next = phi i64 [ %cur.ph, %build_sift_head ], [ %cur.ph, %build_after_choose_child ]
  br label %build_loop_head

build_done:
  %end.init = add i64 %n, -1
  br label %sort_head

sort_head:
  %end = phi i64 [ %end.init, %build_done ], [ %end.next, %sort_iter_end ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %sort_swap

sort_swap:
  %a0ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %aendptr = getelementptr inbounds i32, i32* %a, i64 %end
  %aend = load i32, i32* %aendptr, align 4
  store i32 %aend, i32* %a0ptr, align 4
  store i32 %a0, i32* %aendptr, align 4
  br label %sort_sift_head

sort_sift_head:
  %idx2 = phi i64 [ 0, %sort_swap ], [ %idx2.next, %sort_sift_iter_end ]
  %bound = phi i64 [ %end, %sort_swap ], [ %bound, %sort_sift_iter_end ]
  %twice2 = shl i64 %idx2, 1
  %child2 = add i64 %twice2, 1
  %child_ge_bound = icmp uge i64 %child2, %bound
  br i1 %child_ge_bound, label %sort_iter_end, label %sort_has_left

sort_has_left:
  %right2 = add i64 %child2, 1
  %right_lt_bound = icmp ult i64 %right2, %bound
  br i1 %right_lt_bound, label %sort_compare_children, label %sort_choose_left

sort_compare_children:
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %child2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %max_child2_idx = select i1 %right_gt_left2, i64 %right2, i64 %child2
  br label %sort_after_choose_child

sort_choose_left:
  br label %sort_after_choose_child

sort_after_choose_child:
  %max_child2 = phi i64 [ %max_child2_idx, %sort_compare_children ], [ %child2, %sort_choose_left ]
  %idx2_ptr = getelementptr inbounds i32, i32* %a, i64 %idx2
  %idx2_val = load i32, i32* %idx2_ptr, align 4
  %mc2_ptr = getelementptr inbounds i32, i32* %a, i64 %max_child2
  %mc2_val = load i32, i32* %mc2_ptr, align 4
  %idx2_ge_mc2 = icmp sge i32 %idx2_val, %mc2_val
  br i1 %idx2_ge_mc2, label %sort_iter_end, label %sort_swap2

sort_swap2:
  store i32 %mc2_val, i32* %idx2_ptr, align 4
  store i32 %idx2_val, i32* %mc2_ptr, align 4
  %idx2.next = %max_child2
  br label %sort_sift_iter_end

sort_sift_iter_end:
  br label %sort_sift_head

sort_iter_end:
  %end.next = add i64 %bound, -1
  br label %sort_head

ret:
  ret void
}