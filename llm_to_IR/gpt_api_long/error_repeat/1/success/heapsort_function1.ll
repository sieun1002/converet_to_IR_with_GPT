; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place ascending heapsort of i32 array (confidence=0.95). Evidence: sift-down using 2*i+1 child index, swap root with last element per pass
; Preconditions: %a points to at least %n i32 elements; if %n <= 1, no effect
; Postconditions: %a[0..%n-1] sorted in nondecreasing (signed) order

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_cond

build_cond:
  %i_rem = phi i64 [ %half, %build_init ], [ %i_dec, %build_loop_latch ]
  %i_not_zero = icmp ne i64 %i_rem, 0
  br i1 %i_not_zero, label %build_body, label %heap_init

build_body:
  %i_dec = add i64 %i_rem, -1
  br label %sd1_head

sd1_head:
  %j = phi i64 [ %i_dec, %build_body ], [ %j_next, %sd1_swap ]
  %j_twice = add i64 %j, %j
  %child = add i64 %j_twice, 1
  %child_lt_n = icmp ult i64 %child, %n
  br i1 %child_lt_n, label %sd1_child_ok, label %sd1_exit

sd1_child_ok:
  %k = add i64 %child, 1
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %sd1_compare_children, label %sd1_choose_child

sd1_compare_children:
  %p_k = getelementptr inbounds i32, i32* %a, i64 %k
  %val_k = load i32, i32* %p_k, align 4
  %p_child = getelementptr inbounds i32, i32* %a, i64 %child
  %val_child = load i32, i32* %p_child, align 4
  %k_gt_child = icmp sgt i32 %val_k, %val_child
  %best_idx_sel = select i1 %k_gt_child, i64 %k, i64 %child
  br label %sd1_choose_child

sd1_choose_child:
  %best_idx = phi i64 [ %best_idx_sel, %sd1_compare_children ], [ %child, %sd1_child_ok ]
  %p_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %p_j, align 4
  %p_best = getelementptr inbounds i32, i32* %a, i64 %best_idx
  %val_best = load i32, i32* %p_best, align 4
  %j_lt_best = icmp slt i32 %val_j, %val_best
  br i1 %j_lt_best, label %sd1_swap, label %sd1_exit

sd1_swap:
  store i32 %val_best, i32* %p_j, align 4
  store i32 %val_j, i32* %p_best, align 4
  %j_next = add i64 %best_idx, 0
  br label %sd1_head

sd1_exit:
  br label %build_loop_latch

build_loop_latch:
  br label %build_cond

heap_init:
  %heap = add i64 %n, -1
  br label %heap_cond

heap_cond:
  %h = phi i64 [ %heap, %heap_init ], [ %heap_dec, %heap_latch ]
  %h_not_zero = icmp ne i64 %h, 0
  br i1 %h_not_zero, label %heap_body, label %ret

heap_body:
  %p0 = getelementptr inbounds i32, i32* %a, i64 0
  %v0 = load i32, i32* %p0, align 4
  %ph = getelementptr inbounds i32, i32* %a, i64 %h
  %vh = load i32, i32* %ph, align 4
  store i32 %vh, i32* %p0, align 4
  store i32 %v0, i32* %ph, align 4
  br label %sd2_head

sd2_head:
  %j2 = phi i64 [ 0, %heap_body ], [ %j2_next, %sd2_swap ]
  %j2_twice = add i64 %j2, %j2
  %child2 = add i64 %j2_twice, 1
  %child2_lt_h = icmp ult i64 %child2, %h
  br i1 %child2_lt_h, label %sd2_child_ok, label %heap_latch

sd2_child_ok:
  %k2 = add i64 %child2, 1
  %k2_lt_h = icmp ult i64 %k2, %h
  br i1 %k2_lt_h, label %sd2_compare_children, label %sd2_choose_child

sd2_compare_children:
  %p_k2 = getelementptr inbounds i32, i32* %a, i64 %k2
  %val_k2 = load i32, i32* %p_k2, align 4
  %p_child2 = getelementptr inbounds i32, i32* %a, i64 %child2
  %val_child2 = load i32, i32* %p_child2, align 4
  %k2_gt_child = icmp sgt i32 %val_k2, %val_child2
  %best2_sel = select i1 %k2_gt_child, i64 %k2, i64 %child2
  br label %sd2_choose_child

sd2_choose_child:
  %best2 = phi i64 [ %best2_sel, %sd2_compare_children ], [ %child2, %sd2_child_ok ]
  %p_j2 = getelementptr inbounds i32, i32* %a, i64 %j2
  %vj2 = load i32, i32* %p_j2, align 4
  %p_best2 = getelementptr inbounds i32, i32* %a, i64 %best2
  %vbest2 = load i32, i32* %p_best2, align 4
  %j2_lt_best2 = icmp slt i32 %vj2, %vbest2
  br i1 %j2_lt_best2, label %sd2_swap, label %heap_latch

sd2_swap:
  store i32 %vbest2, i32* %p_j2, align 4
  store i32 %vj2, i32* %p_best2, align 4
  %j2_next = add i64 %best2, 0
  br label %sd2_head

heap_latch:
  %heap_dec = add i64 %h, -1
  br label %heap_cond

ret:
  ret void
}