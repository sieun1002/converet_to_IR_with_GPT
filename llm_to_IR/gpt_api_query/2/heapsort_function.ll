; ModuleID = 'heap_sort_module'
source_filename = "heap_sort.ll"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_head

build_loop_head:                                 ; preds = %build_init, %build_iter_end
  %i = phi i64 [ %half, %build_init ], [ %i_dec, %build_iter_end ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %after_build, label %build_iter

build_iter:                                      ; preds = %build_loop_head
  %root = add i64 %i, -1
  br label %sift_build_cond

sift_build_cond:                                 ; preds = %sift_build_continue, %build_iter
  %x = phi i64 [ %root, %build_iter ], [ %child, %sift_build_continue ]
  %x2 = shl i64 %x, 1
  %left = add i64 %x2, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %after_sift_build, label %have_left

have_left:                                       ; preds = %sift_build_cond
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp_children, label %choose_left

cmp_children:                                    ; preds = %have_left
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val2 = load i32, i32* %left_ptr2, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val2
  %child_from_cmp = select i1 %right_gt_left, i64 %right, i64 %left
  br label %child_selected

choose_left:                                     ; preds = %have_left
  br label %child_selected

child_selected:                                  ; preds = %choose_left, %cmp_children
  %child = phi i64 [ %child_from_cmp, %cmp_children ], [ %left, %choose_left ]
  %x_ptr = getelementptr inbounds i32, i32* %arr, i64 %x
  %x_val = load i32, i32* %x_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %x_ge_child = icmp sge i32 %x_val, %child_val
  br i1 %x_ge_child, label %after_sift_build, label %sift_build_swap

sift_build_swap:                                 ; preds = %child_selected
  store i32 %child_val, i32* %x_ptr, align 4
  store i32 %x_val, i32* %child_ptr, align 4
  br label %sift_build_continue

sift_build_continue:                             ; preds = %sift_build_swap
  br label %sift_build_cond

after_sift_build:                                ; preds = %child_selected, %sift_build_cond
  br label %build_iter_end

build_iter_end:                                  ; preds = %after_sift_build
  %i_dec = add i64 %i, -1
  br label %build_loop_head

after_build:                                     ; preds = %build_loop_head
  %end_init = add i64 %n, -1
  br label %sort_loop_head

sort_loop_head:                                  ; preds = %after_sift_sort, %after_build
  %end = phi i64 [ %end_init, %after_build ], [ %end_next, %after_sift_sort ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %sort_iter

sort_iter:                                       ; preds = %sort_loop_head
  %root0_val = load i32, i32* %arr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %arr, align 4
  store i32 %root0_val, i32* %end_ptr, align 4
  br label %sift_sort_cond

sift_sort_cond:                                  ; preds = %sift_sort_swap, %sort_iter
  %x2_phi = phi i64 [ 0, %sort_iter ], [ %child2, %sift_sort_swap ]
  %x2_shl = shl i64 %x2_phi, 1
  %left2 = add i64 %x2_shl, 1
  %left_ge_end = icmp uge i64 %left2, %end
  br i1 %left_ge_end, label %after_sift_sort, label %have_left2

have_left2:                                      ; preds = %sift_sort_cond
  %right2 = add i64 %left2, 1
  %right_lt_end = icmp ult i64 %right2, %end
  br i1 %right_lt_end, label %cmp_children2, label %choose_left2

cmp_children2:                                   ; preds = %have_left2
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %child2_sel = select i1 %right_gt_left2, i64 %right2, i64 %left2
  br label %child_selected2

choose_left2:                                    ; preds = %have_left2
  br label %child_selected2

child_selected2:                                 ; preds = %choose_left2, %cmp_children2
  %child2 = phi i64 [ %child2_sel, %cmp_children2 ], [ %left2, %choose_left2 ]
  %x2_ptr = getelementptr inbounds i32, i32* %arr, i64 %x2_phi
  %x2_val = load i32, i32* %x2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %x_ge_child2 = icmp sge i32 %x2_val, %child2_val
  br i1 %x_ge_child2, label %after_sift_sort, label %sift_sort_swap

sift_sort_swap:                                  ; preds = %child_selected2
  store i32 %child2_val, i32* %x2_ptr, align 4
  store i32 %x2_val, i32* %child2_ptr, align 4
  br label %sift_sort_cond

after_sift_sort:                                 ; preds = %child_selected2, %sift_sort_cond
  %end_next = add i64 %end, -1
  br label %sort_loop_head

ret:                                             ; preds = %sort_loop_head, %entry
  ret void
}