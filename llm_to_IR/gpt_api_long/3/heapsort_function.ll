; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of i32 array in ascending order (confidence=0.98). Evidence: 0-based heap (child=2*i+1), bottom-up heapify and sift-down with swaps.
; Preconditions: %a points to at least %n contiguous i32 elements.
; Postconditions: %a[0..%n-1] sorted nondecreasing.

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:                                        ; preds = %entry
  %i0 = lshr i64 %n, 1
  %i0_is_zero = icmp eq i64 %i0, 0
  %i_start = add i64 %i0, -1
  br i1 %i0_is_zero, label %build_done, label %build_outer_header

build_outer_header:                                ; preds = %build_init, %build_outer_latch
  %i_phi = phi i64 [ %i_start, %build_init ], [ %i_next, %build_outer_latch ]
  br label %sift_header

sift_header:                                       ; preds = %do_swap, %build_outer_header
  %j = phi i64 [ %i_phi, %build_outer_header ], [ %k, %do_swap ]
  %j_dbl = shl i64 %j, 1
  %child = add i64 %j_dbl, 1
  %child_lt_n = icmp ult i64 %child, %n
  br i1 %child_lt_n, label %choose_child, label %sift_break

choose_child:                                      ; preds = %sift_header
  %rchild = add i64 %child, 1
  %rchild_lt_n = icmp ult i64 %rchild, %n
  br i1 %rchild_lt_n, label %have_both, label %pick_child_result

have_both:                                         ; preds = %choose_child
  %ptr_rchild = getelementptr inbounds i32, i32* %a, i64 %rchild
  %val_rchild = load i32, i32* %ptr_rchild, align 4
  %ptr_child = getelementptr inbounds i32, i32* %a, i64 %child
  %val_child = load i32, i32* %ptr_child, align 4
  %cmp_rc_gt_c = icmp sgt i32 %val_rchild, %val_child
  br i1 %cmp_rc_gt_c, label %choose_right, label %choose_left

choose_right:                                      ; preds = %have_both
  br label %pick_child_result

choose_left:                                       ; preds = %have_both
  br label %pick_child_result

pick_child_result:                                 ; preds = %choose_left, %choose_right, %choose_child
  %k = phi i64 [ %rchild, %choose_right ], [ %child, %choose_left ], [ %child, %choose_child ]
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_k = getelementptr inbounds i32, i32* %a, i64 %k
  %val_k = load i32, i32* %ptr_k, align 4
  %cmp_j_ge_k = icmp sge i32 %val_j, %val_k
  br i1 %cmp_j_ge_k, label %sift_break, label %do_swap

do_swap:                                           ; preds = %pick_child_result
  store i32 %val_k, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_k, align 4
  br label %sift_header

sift_break:                                        ; preds = %pick_child_result, %sift_header
  br label %build_outer_latch

build_outer_latch:                                 ; preds = %sift_break
  %i_is_zero = icmp eq i64 %i_phi, 0
  %i_next = add i64 %i_phi, -1
  br i1 %i_is_zero, label %build_done, label %build_outer_header

build_done:                                        ; preds = %build_outer_latch, %build_init
  %end0 = add i64 %n, -1
  br label %sort_check

sort_check:                                        ; preds = %sort_after_inner, %build_done
  %end = phi i64 [ %end0, %build_done ], [ %end_dec, %sort_after_inner ]
  %end_ne_zero = icmp ne i64 %end, 0
  br i1 %end_ne_zero, label %sort_body, label %ret

sort_body:                                         ; preds = %sort_check
  %a0ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %aendptr = getelementptr inbounds i32, i32* %a, i64 %end
  %aend = load i32, i32* %aendptr, align 4
  store i32 %aend, i32* %a0ptr, align 4
  store i32 %a0, i32* %aendptr, align 4
  br label %sift2_header

sift2_header:                                      ; preds = %do_swap2, %sort_body
  %root = phi i64 [ 0, %sort_body ], [ %k2, %do_swap2 ]
  %root_dbl = shl i64 %root, 1
  %child2 = add i64 %root_dbl, 1
  %child2_lt_end = icmp ult i64 %child2, %end
  br i1 %child2_lt_end, label %choose_child2, label %sort_after_inner

choose_child2:                                     ; preds = %sift2_header
  %rchild2 = add i64 %child2, 1
  %rchild2_lt_end = icmp ult i64 %rchild2, %end
  br i1 %rchild2_lt_end, label %have_both2, label %pick_child2

have_both2:                                        ; preds = %choose_child2
  %ptr_rchild2 = getelementptr inbounds i32, i32* %a, i64 %rchild2
  %val_rchild2 = load i32, i32* %ptr_rchild2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %a, i64 %child2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %cmp_rc_gt_c2 = icmp sgt i32 %val_rchild2, %val_child2
  br i1 %cmp_rc_gt_c2, label %choose_right2, label %choose_left2

choose_right2:                                     ; preds = %have_both2
  br label %pick_child2

choose_left2:                                      ; preds = %have_both2
  br label %pick_child2

pick_child2:                                       ; preds = %choose_left2, %choose_right2, %choose_child2
  %k2 = phi i64 [ %rchild2, %choose_right2 ], [ %child2, %choose_left2 ], [ %child2, %choose_child2 ]
  %ptr_root = getelementptr inbounds i32, i32* %a, i64 %root
  %val_root = load i32, i32* %ptr_root, align 4
  %ptr_k2 = getelementptr inbounds i32, i32* %a, i64 %k2
  %val_k2 = load i32, i32* %ptr_k2, align 4
  %cmp_root_ge_k2 = icmp sge i32 %val_root, %val_k2
  br i1 %cmp_root_ge_k2, label %sort_after_inner, label %do_swap2

do_swap2:                                          ; preds = %pick_child2
  store i32 %val_k2, i32* %ptr_root, align 4
  store i32 %val_root, i32* %ptr_k2, align 4
  br label %sift2_header

sort_after_inner:                                  ; preds = %pick_child2, %sift2_header
  %end_dec = add i64 %end, -1
  br label %sort_check

ret:                                               ; preds = %sort_check, %entry
  ret void
}