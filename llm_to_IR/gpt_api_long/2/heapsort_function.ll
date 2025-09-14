; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place ascending heapsort on 32-bit integer array (confidence=0.98). Evidence: 4-byte indexing with heapify (2*i+1 children) and repeated root swap/end-shrink loops.
; Preconditions: a points to at least n i32 elements
; Postconditions: a[0..n-1] is sorted in nondecreasing order

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_start

build_start:
  %i0 = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i.phi = phi i64 [ %i0, %build_start ], [ %i.next, %after_sift_build ]
  %i.iszero = icmp eq i64 %i.phi, 0
  br i1 %i.iszero, label %phase2_start, label %build_prepare

build_prepare:
  %i.dec = add i64 %i.phi, -1
  br label %sift_build_header

sift_build_header:
  %idx.phi = phi i64 [ %i.dec, %build_prepare ], [ %child_sel, %sift_build_swap_done ]
  %i.const = phi i64 [ %i.dec, %build_prepare ], [ %i.const, %sift_build_swap_done ]
  %idx2 = shl i64 %idx.phi, 1
  %left = add i64 %idx2, 1
  %left_in = icmp ult i64 %left, %n
  br i1 %left_in, label %child_check_build, label %after_sift_build

child_check_build:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %a_left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %a_left = load i32, i32* %a_left_ptr, align 4
  br i1 %right_in, label %have_right_build, label %child_selected_build

have_right_build:
  %a_right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %a_right = load i32, i32* %a_right_ptr, align 4
  %right_gt_left = icmp sgt i32 %a_right, %a_left
  %child_sel_right = select i1 %right_gt_left, i64 %right, i64 %left
  br label %child_selected_build

child_selected_build:
  %child_sel.phi = phi i64 [ %left, %child_check_build ], [ %child_sel_right, %have_right_build ]
  %a_idx_ptr = getelementptr inbounds i32, i32* %a, i64 %idx.phi
  %a_idx = load i32, i32* %a_idx_ptr, align 4
  %a_child_ptr = getelementptr inbounds i32, i32* %a, i64 %child_sel.phi
  %a_child = load i32, i32* %a_child_ptr, align 4
  %idx_ge_child = icmp sge i32 %a_idx, %a_child
  br i1 %idx_ge_child, label %after_sift_build, label %sift_build_swap

sift_build_swap:
  store i32 %a_child, i32* %a_idx_ptr, align 4
  store i32 %a_idx, i32* %a_child_ptr, align 4
  br label %sift_build_swap_done

sift_build_swap_done:
  %child_sel = phi i64 [ %child_sel.phi, %sift_build_swap ]
  br label %sift_build_header

after_sift_build:
  %i.next = phi i64 [ %i.const, %sift_build_header ], [ %i.const, %child_selected_build ]
  br label %build_loop_header

phase2_start:
  %end0 = add i64 %n, -1
  br label %outer2_header

outer2_header:
  %end.phi = phi i64 [ %end0, %phase2_start ], [ %end.next, %after_sift2 ]
  %end_is_zero = icmp eq i64 %end.phi, 0
  br i1 %end_is_zero, label %ret, label %outer2_body

outer2_body:
  %a0ptr = getelementptr inbounds i32, i32* %a, i64 0
  %v0 = load i32, i32* %a0ptr, align 4
  %a_end_ptr = getelementptr inbounds i32, i32* %a, i64 %end.phi
  %v_end = load i32, i32* %a_end_ptr, align 4
  store i32 %v_end, i32* %a0ptr, align 4
  store i32 %v0, i32* %a_end_ptr, align 4
  br label %sift2_header

sift2_header:
  %idx2.phi = phi i64 [ 0, %outer2_body ], [ %child_sel2, %sift2_swap_done ]
  %end.const = phi i64 [ %end.phi, %outer2_body ], [ %end.const, %sift2_swap_done ]
  %idx2_shl = shl i64 %idx2.phi, 1
  %left2 = add i64 %idx2_shl, 1
  %left2_in = icmp ult i64 %left2, %end.const
  br i1 %left2_in, label %child_check2, label %after_sift2

child_check2:
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %end.const
  %a_left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %a_left2 = load i32, i32* %a_left2_ptr, align 4
  br i1 %right2_in, label %have_right2, label %child_selected2

have_right2:
  %a_right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %a_right2 = load i32, i32* %a_right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %a_right2, %a_left2
  %child_sel_right2 = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %child_selected2

child_selected2:
  %child2 = phi i64 [ %left2, %child_check2 ], [ %child_sel_right2, %have_right2 ]
  %a_idx2_ptr = getelementptr inbounds i32, i32* %a, i64 %idx2.phi
  %a_idx2 = load i32, i32* %a_idx2_ptr, align 4
  %a_child2_ptr = getelementptr inbounds i32, i32* %a, i64 %child2
  %a_child2 = load i32, i32* %a_child2_ptr, align 4
  %idx_ge_child2 = icmp sge i32 %a_idx2, %a_child2
  br i1 %idx_ge_child2, label %after_sift2, label %sift2_swap

sift2_swap:
  store i32 %a_child2, i32* %a_idx2_ptr, align 4
  store i32 %a_idx2, i32* %a_child2_ptr, align 4
  br label %sift2_swap_done

sift2_swap_done:
  %child_sel2 = phi i64 [ %child2, %sift2_swap ]
  br label %sift2_header

after_sift2:
  %end.next = add i64 %end.phi, -1
  br label %outer2_header

ret:
  ret void
}