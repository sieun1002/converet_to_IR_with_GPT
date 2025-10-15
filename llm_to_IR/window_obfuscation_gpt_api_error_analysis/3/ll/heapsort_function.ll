target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %done, label %build_start

build_start:
  %half = lshr i64 %n, 1
  br label %build_outer_check

build_outer_check:
  %i = phi i64 [ %half, %build_start ], [ %i_next, %build_after_inner ]
  %i_nonzero = icmp ne i64 %i, 0
  br i1 %i_nonzero, label %build_iter_prep, label %extract_init

build_iter_prep:
  %j_init = add i64 %i, -1
  br label %build_inner_head

build_inner_head:
  %j = phi i64 [ %j_init, %build_iter_prep ], [ %j_next, %build_do_swap ]
  %child_tmp = shl i64 %j, 1
  %child = add i64 %child_tmp, 1
  %child_lt_n = icmp ult i64 %child, %n
  br i1 %child_lt_n, label %build_compare_children, label %build_after_inner

build_compare_children:
  %k = add i64 %child, 1
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %build_load_two, label %build_set_m_child

build_load_two:
  %ptr_k = getelementptr inbounds i32, i32* %a, i64 %k
  %val_k = load i32, i32* %ptr_k, align 4
  %ptr_child = getelementptr inbounds i32, i32* %a, i64 %child
  %val_child = load i32, i32* %ptr_child, align 4
  %k_gt_child = icmp sgt i32 %val_k, %val_child
  br i1 %k_gt_child, label %build_set_m_k, label %build_set_m_child

build_set_m_k:
  br label %build_m_ready

build_set_m_child:
  br label %build_m_ready

build_m_ready:
  %m = phi i64 [ %k, %build_set_m_k ], [ %child, %build_set_m_child ]
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_m = getelementptr inbounds i32, i32* %a, i64 %m
  %val_m = load i32, i32* %ptr_m, align 4
  %j_lt_m = icmp slt i32 %val_j, %val_m
  br i1 %j_lt_m, label %build_do_swap, label %build_after_inner

build_do_swap:
  store i32 %val_m, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_m, align 4
  br label %build_inner_head

build_after_inner:
  %i_next = add i64 %i, -1
  br label %build_outer_check

extract_init:
  %k_ex = add i64 %n, -1
  br label %extract_outer_header

extract_outer_header:
  %k_phi = phi i64 [ %k_ex, %extract_init ], [ %k_next, %after_sift_loop ]
  %k_nonzero = icmp ne i64 %k_phi, 0
  br i1 %k_nonzero, label %extract_body, label %done

extract_body:
  %root_ptr = getelementptr inbounds i32, i32* %a, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %a, i64 %k_phi
  %k_val = load i32, i32* %k_ptr, align 4
  store i32 %k_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %k_ptr, align 4
  br label %sift2_head

sift2_head:
  %j2 = phi i64 [ 0, %extract_body ], [ %j2_next, %sift2_do_swap ]
  %child2_tmp = shl i64 %j2, 1
  %child2 = add i64 %child2_tmp, 1
  %child2_lt_k = icmp ult i64 %child2, %k_phi
  br i1 %child2_lt_k, label %sift2_compare_children, label %after_sift_loop

sift2_compare_children:
  %k2 = add i64 %child2, 1
  %k2_lt_k = icmp ult i64 %k2, %k_phi
  br i1 %k2_lt_k, label %sift2_load_two, label %sift2_set_m_child

sift2_load_two:
  %ptr_k2 = getelementptr inbounds i32, i32* %a, i64 %k2
  %val_k2 = load i32, i32* %ptr_k2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %a, i64 %child2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %k2_gt_child2 = icmp sgt i32 %val_k2, %val_child2
  br i1 %k2_gt_child2, label %sift2_set_m_k2, label %sift2_set_m_child

sift2_set_m_k2:
  br label %sift2_m_ready

sift2_set_m_child:
  br label %sift2_m_ready

sift2_m_ready:
  %m2 = phi i64 [ %k2, %sift2_set_m_k2 ], [ %child2, %sift2_set_m_child ]
  %ptr_j2 = getelementptr inbounds i32, i32* %a, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_m2 = getelementptr inbounds i32, i32* %a, i64 %m2
  %val_m2 = load i32, i32* %ptr_m2, align 4
  %j2_ge_m2 = icmp sge i32 %val_j2, %val_m2
  br i1 %j2_ge_m2, label %after_sift_loop, label %sift2_do_swap

sift2_do_swap:
  store i32 %val_m2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_m2, align 4
  %j2_next = add i64 %m2, 0
  br label %sift2_head

after_sift_loop:
  %k_next = add i64 %k_phi, -1
  br label %extract_outer_header

done:
  ret void
}