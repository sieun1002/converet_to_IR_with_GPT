; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arg0, i64 %arg8) {
entry:
  %cmp_n_le1 = icmp ule i64 %arg8, 1
  br i1 %cmp_n_le1, label %end, label %heapify_init

heapify_init:                                     ; preds = %entry
  %i0 = lshr i64 %arg8, 1
  br label %heapify_loop

heapify_loop:                                     ; preds = %heapify_after_inner, %heapify_init
  %i_phi = phi i64 [ %i0, %heapify_init ], [ %i_next, %heapify_after_inner ]
  %i_is_zero = icmp eq i64 %i_phi, 0
  br i1 %i_is_zero, label %sortdown_init, label %heapify_body

heapify_body:                                     ; preds = %heapify_loop
  %j0 = add i64 %i_phi, -1
  br label %sift_loop

sift_loop:                                        ; preds = %do_swap, %heapify_body
  %j = phi i64 [ %j0, %heapify_body ], [ %j_next_from_sift, %do_swap ]
  %j2 = add i64 %j, %j
  %left = add i64 %j2, 1
  %left_lt_n = icmp ult i64 %left, %arg8
  br i1 %left_lt_n, label %maybe_right, label %heapify_after_inner

maybe_right:                                      ; preds = %sift_loop
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %arg8
  br i1 %right_lt_n, label %compare_children, label %choose_left

compare_children:                                 ; preds = %maybe_right
  %ptr_right = getelementptr inbounds i32, i32* %arg0, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arg0, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %cmp_rl = icmp sle i32 %val_right, %val_left
  br i1 %cmp_rl, label %choose_left, label %choose_right

choose_left:                                      ; preds = %compare_children, %maybe_right
  %m_left = phi i64 [ %left, %maybe_right ], [ %left, %compare_children ]
  br label %have_m

choose_right:                                     ; preds = %compare_children
  br label %have_m

have_m:                                           ; preds = %choose_right, %choose_left
  %m = phi i64 [ %m_left, %choose_left ], [ %right, %choose_right ]
  %ptr_j = getelementptr inbounds i32, i32* %arg0, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_m = getelementptr inbounds i32, i32* %arg0, i64 %m
  %val_m = load i32, i32* %ptr_m, align 4
  %cmp_jm = icmp slt i32 %val_j, %val_m
  br i1 %cmp_jm, label %do_swap, label %heapify_after_inner

do_swap:                                          ; preds = %have_m
  store i32 %val_m, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_m, align 4
  %j_next_from_sift = add i64 %m, 0
  br label %sift_loop

heapify_after_inner:                              ; preds = %have_m, %sift_loop
  %i_next = add i64 %i_phi, -1
  br label %heapify_loop

sortdown_init:                                    ; preds = %heapify_loop
  %k0 = add i64 %arg8, -1
  br label %sortdown_loop

sortdown_loop:                                    ; preds = %after_sift2, %sortdown_init
  %k = phi i64 [ %k0, %sortdown_init ], [ %k_next, %after_sift2 ]
  %k_is_zero = icmp eq i64 %k, 0
  br i1 %k_is_zero, label %end, label %swap_root_with_k

swap_root_with_k:                                 ; preds = %sortdown_loop
  %ptr0 = getelementptr inbounds i32, i32* %arg0, i64 0
  %root = load i32, i32* %ptr0, align 4
  %ptrk = getelementptr inbounds i32, i32* %arg0, i64 %k
  %valk = load i32, i32* %ptrk, align 4
  store i32 %valk, i32* %ptr0, align 4
  store i32 %root, i32* %ptrk, align 4
  br label %sift2_loop

sift2_loop:                                       ; preds = %do_swap2, %swap_root_with_k
  %j2_phi = phi i64 [ 0, %swap_root_with_k ], [ %j2_next, %do_swap2 ]
  %j2_twice = add i64 %j2_phi, %j2_phi
  %left2 = add i64 %j2_twice, 1
  %left2_lt_k = icmp ult i64 %left2, %k
  br i1 %left2_lt_k, label %maybe_right2, label %after_sift2

maybe_right2:                                     ; preds = %sift2_loop
  %right2 = add i64 %left2, 1
  %right2_lt_k = icmp ult i64 %right2, %k
  br i1 %right2_lt_k, label %compare_children2, label %choose_left2

compare_children2:                                ; preds = %maybe_right2
  %ptr_right2 = getelementptr inbounds i32, i32* %arg0, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arg0, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %cmp_rl2 = icmp sle i32 %val_right2, %val_left2
  br i1 %cmp_rl2, label %choose_left2, label %choose_right2

choose_left2:                                     ; preds = %compare_children2, %maybe_right2
  %m2_left = phi i64 [ %left2, %maybe_right2 ], [ %left2, %compare_children2 ]
  br label %have_m2

choose_right2:                                    ; preds = %compare_children2
  br label %have_m2

have_m2:                                          ; preds = %choose_right2, %choose_left2
  %m2 = phi i64 [ %m2_left, %choose_left2 ], [ %right2, %choose_right2 ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arg0, i64 %j2_phi
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_m2 = getelementptr inbounds i32, i32* %arg0, i64 %m2
  %val_m2 = load i32, i32* %ptr_m2, align 4
  %cmp_break = icmp sge i32 %val_j2, %val_m2
  br i1 %cmp_break, label %after_sift2, label %do_swap2

do_swap2:                                         ; preds = %have_m2
  store i32 %val_m2, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_m2, align 4
  %j2_next = add i64 %m2, 0
  br label %sift2_loop

after_sift2:                                      ; preds = %have_m2, %sift2_loop
  %k_next = add i64 %k, -1
  br label %sortdown_loop

end:                                              ; preds = %sortdown_loop, %entry
  ret void
}