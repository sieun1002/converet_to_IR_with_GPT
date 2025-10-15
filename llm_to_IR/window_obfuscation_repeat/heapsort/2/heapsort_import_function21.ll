; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %build_pre

build_pre:
  %half = lshr i64 %n, 1
  br label %build_outer_check

build_outer_check:
  %build_i = phi i64 [ %half, %build_pre ], [ %i_dec, %build_next ]
  %build_i_ne0 = icmp ne i64 %build_i, 0
  br i1 %build_i_ne0, label %build_body_init, label %after_build

build_body_init:
  %i_dec = add i64 %build_i, -1
  br label %sift_loop

sift_loop:
  %pos = phi i64 [ %i_dec, %build_body_init ], [ %pos_new, %sift_swap ]
  %pos_dbl = shl i64 %pos, 1
  %left = add i64 %pos_dbl, 1
  %left_in_n = icmp ult i64 %left, %n
  br i1 %left_in_n, label %compute_right, label %build_next

compute_right:
  %right = add i64 %left, 1
  %right_in_n = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in_n, label %cmp_children, label %choose_child_left

cmp_children:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %child_idx_sel = select i1 %right_gt_left, i64 %right, i64 %left
  %child_val_sel = select i1 %right_gt_left, i32 %right_val, i32 %left_val
  br label %have_child

choose_child_left:
  br label %have_child

have_child:
  %sel_idx = phi i64 [ %child_idx_sel, %cmp_children ], [ %left, %choose_child_left ]
  %sel_val = phi i32 [ %child_val_sel, %cmp_children ], [ %left_val, %choose_child_left ]
  %pos_ptr = getelementptr inbounds i32, i32* %arr, i64 %pos
  %pos_val = load i32, i32* %pos_ptr, align 4
  %pos_lt_sel = icmp slt i32 %pos_val, %sel_val
  br i1 %pos_lt_sel, label %sift_swap, label %build_next

sift_swap:
  %sel_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %sel_idx
  store i32 %sel_val, i32* %pos_ptr, align 4
  store i32 %pos_val, i32* %sel_ptr2, align 4
  %pos_new = %sel_idx
  br label %sift_loop

build_next:
  br label %build_outer_check

after_build:
  %heapN_init = add i64 %n, -1
  br label %extract_check

extract_check:
  %heapN = phi i64 [ %heapN_init, %after_build ], [ %heapN_dec, %extract_decrement ]
  %heapN_ne0 = icmp ne i64 %heapN, 0
  br i1 %heapN_ne0, label %extract_body, label %exit

extract_body:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val2 = load i32, i32* %root_ptr, align 4
  %heap_ptr = getelementptr inbounds i32, i32* %arr, i64 %heapN
  %end_val2 = load i32, i32* %heap_ptr, align 4
  store i32 %end_val2, i32* %root_ptr, align 4
  store i32 %root_val2, i32* %heap_ptr, align 4
  br label %sift2_loop

sift2_loop:
  %pos2 = phi i64 [ 0, %extract_body ], [ %pos2_new, %sift2_swap ]
  %pos2_dbl = shl i64 %pos2, 1
  %left2 = add i64 %pos2_dbl, 1
  %left2_in_heap = icmp ult i64 %left2, %heapN
  br i1 %left2_in_heap, label %sift2_compute_right, label %extract_decrement

sift2_compute_right:
  %right2 = add i64 %left2, 1
  %right2_in_heap = icmp ult i64 %right2, %heapN
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_in_heap, label %sift2_cmp_children, label %sift2_choose_left

sift2_cmp_children:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %child2_idx_sel = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  %child2_val_sel = select i1 %right2_gt_left2, i32 %right2_val, i32 %left2_val
  br label %sift2_have_child

sift2_choose_left:
  br label %sift2_have_child

sift2_have_child:
  %child2_idx = phi i64 [ %child2_idx_sel, %sift2_cmp_children ], [ %left2, %sift2_choose_left ]
  %child2_val = phi i32 [ %child2_val_sel, %sift2_cmp_children ], [ %left2_val, %sift2_choose_left ]
  %pos2_ptr = getelementptr inbounds i32, i32* %arr, i64 %pos2
  %pos2_val = load i32, i32* %pos2_ptr, align 4
  %pos2_lt_child2 = icmp slt i32 %pos2_val, %child2_val
  br i1 %pos2_lt_child2, label %sift2_swap, label %extract_decrement

sift2_swap:
  %child2_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  store i32 %child2_val, i32* %pos2_ptr, align 4
  store i32 %pos2_val, i32* %child2_ptr2, align 4
  %pos2_new = %child2_idx
  br label %sift2_loop

extract_decrement:
  %heapN_dec = add i64 %heapN, -1
  br label %extract_check

exit:
  ret void
}