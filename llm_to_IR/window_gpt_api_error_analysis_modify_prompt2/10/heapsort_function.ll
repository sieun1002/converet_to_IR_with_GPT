target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %buildheap_entry

buildheap_entry:
  %half = lshr i64 %n, 1
  br label %bh_header

bh_header:
  %i = phi i64 [ %half, %buildheap_entry ], [ %j, %bh_after_sift ]
  %cond_bh = icmp ne i64 %i, 0
  %j = add i64 %i, -1
  br i1 %cond_bh, label %bh_sift_entry, label %after_buildheap

bh_sift_entry:
  %idx = phi i64 [ %j, %bh_header ], [ %new_idx, %bh_swap ]
  %mul = shl i64 %idx, 1
  %child = add i64 %mul, 1
  %child_in_range = icmp ult i64 %child, %n
  br i1 %child_in_range, label %bh_has_child, label %bh_after_sift

bh_has_child:
  %right = add i64 %child, 1
  %right_in_range = icmp ult i64 %right, %n
  br i1 %right_in_range, label %bh_compare_children, label %bh_choose_merge

bh_compare_children:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %child
  %val_left = load i32, i32* %ptr_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  %selected = select i1 %right_gt_left, i64 %right, i64 %child
  br label %bh_choose_merge

bh_choose_merge:
  %m = phi i64 [ %selected, %bh_compare_children ], [ %child, %bh_has_child ]
  %ptr_idx = getelementptr inbounds i32, i32* %arr, i64 %idx
  %val_idx = load i32, i32* %ptr_idx, align 4
  %ptr_m = getelementptr inbounds i32, i32* %arr, i64 %m
  %val_m = load i32, i32* %ptr_m, align 4
  %idx_lt_m = icmp slt i32 %val_idx, %val_m
  br i1 %idx_lt_m, label %bh_swap, label %bh_after_sift

bh_swap:
  store i32 %val_m, i32* %ptr_idx, align 4
  store i32 %val_idx, i32* %ptr_m, align 4
  %new_idx = add i64 %m, 0
  br label %bh_sift_entry

bh_after_sift:
  br label %bh_header

after_buildheap:
  %k_init = add i64 %n, -1
  br label %sort_header

sort_header:
  %k = phi i64 [ %k_init, %after_buildheap ], [ %k_dec, %sort_after_sift ]
  %cond_k = icmp ne i64 %k, 0
  br i1 %cond_k, label %sort_body, label %ret

sort_body:
  %head_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %head_val = load i32, i32* %head_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  store i32 %k_val, i32* %head_ptr, align 4
  store i32 %head_val, i32* %k_ptr, align 4
  br label %sort_sift_entry

sort_sift_entry:
  %idx2 = phi i64 [ 0, %sort_body ], [ %new_idx2, %sort_swap ]
  %mul2 = shl i64 %idx2, 1
  %child2 = add i64 %mul2, 1
  %child2_in_range = icmp ult i64 %child2, %k
  br i1 %child2_in_range, label %sort_has_child, label %sort_after_sift

sort_has_child:
  %right2 = add i64 %child2, 1
  %right2_in_range = icmp ult i64 %right2, %k
  br i1 %right2_in_range, label %sort_compare_children, label %sort_choose_merge

sort_compare_children:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %right2_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  %selected2 = select i1 %right2_gt_left2, i64 %right2, i64 %child2
  br label %sort_choose_merge

sort_choose_merge:
  %m2 = phi i64 [ %selected2, %sort_compare_children ], [ %child2, %sort_has_child ]
  %ptr_idx2 = getelementptr inbounds i32, i32* %arr, i64 %idx2
  %val_idx2 = load i32, i32* %ptr_idx2, align 4
  %ptr_m2 = getelementptr inbounds i32, i32* %arr, i64 %m2
  %val_m2 = load i32, i32* %ptr_m2, align 4
  %idx2_lt_m2 = icmp slt i32 %val_idx2, %val_m2
  br i1 %idx2_lt_m2, label %sort_swap, label %sort_after_sift_break

sort_swap:
  store i32 %val_m2, i32* %ptr_idx2, align 4
  store i32 %val_idx2, i32* %ptr_m2, align 4
  %new_idx2 = add i64 %m2, 0
  br label %sort_sift_entry

sort_after_sift_break:
  br label %sort_after_sift

sort_after_sift:
  %k_dec = add i64 %k, -1
  br label %sort_header

ret:
  ret void
}