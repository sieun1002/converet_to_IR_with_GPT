; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %exit, label %build_init

build_init:                                          ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_body

build_body:                                          ; preds = %build_init, %build_latch
  %i_phi = phi i64 [ %half, %build_init ], [ %i_dec, %build_latch ]
  br label %siftdown_build_header

siftdown_build_header:                               ; preds = %build_body, %siftdown_build_latch
  %j0 = phi i64 [ %i_phi, %build_body ], [ %j_next, %siftdown_build_latch ]
  %twoj = shl i64 %j0, 1
  %c0 = add i64 %twoj, 1
  %cmp_c_n = icmp ult i64 %c0, %n
  br i1 %cmp_c_n, label %siftdown_build_has_child, label %siftdown_build_done

siftdown_build_has_child:                            ; preds = %siftdown_build_header
  %c_plus_1 = add i64 %c0, 1
  %has_right = icmp ult i64 %c_plus_1, %n
  br i1 %has_right, label %with_right, label %no_right

with_right:                                          ; preds = %siftdown_build_has_child
  %ptr_r = getelementptr inbounds i32, i32* %arr, i64 %c_plus_1
  %val_r = load i32, i32* %ptr_r, align 4
  %ptr_l = getelementptr inbounds i32, i32* %arr, i64 %c0
  %val_l = load i32, i32* %ptr_l, align 4
  %right_gt_left = icmp sgt i32 %val_r, %val_l
  %mCand1 = select i1 %right_gt_left, i64 %c_plus_1, i64 %c0
  br label %compare_build

no_right:                                            ; preds = %siftdown_build_has_child
  br label %compare_build

compare_build:                                       ; preds = %with_right, %no_right
  %m_phi = phi i64 [ %mCand1, %with_right ], [ %c0, %no_right ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j0
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_m = getelementptr inbounds i32, i32* %arr, i64 %m_phi
  %val_m = load i32, i32* %ptr_m, align 4
  %cmp_j_lt_m = icmp slt i32 %val_j, %val_m
  br i1 %cmp_j_lt_m, label %do_swap_build, label %siftdown_build_done

do_swap_build:                                       ; preds = %compare_build
  %tmp_save = load i32, i32* %ptr_j, align 4
  store i32 %val_m, i32* %ptr_j, align 4
  store i32 %tmp_save, i32* %ptr_m, align 4
  br label %siftdown_build_latch

siftdown_build_latch:                                ; preds = %do_swap_build
  %j_next = phi i64 [ %m_phi, %do_swap_build ]
  br label %siftdown_build_header

siftdown_build_done:                                 ; preds = %siftdown_build_header, %compare_build
  br label %build_latch

build_latch:                                         ; preds = %siftdown_build_done
  %i_dec = sub i64 %i_phi, 1
  %cond_do = icmp ne i64 %i_phi, 0
  br i1 %cond_do, label %build_body, label %sort_init

sort_init:                                           ; preds = %build_latch
  %last = sub i64 %n, 1
  br label %sort_loop_header

sort_loop_header:                                    ; preds = %sort_init, %sort_latch
  %k_phi = phi i64 [ %last, %sort_init ], [ %k_dec, %sort_latch ]
  %cond_k = icmp ne i64 %k_phi, 0
  br i1 %cond_k, label %sort_body, label %exit

sort_body:                                           ; preds = %sort_loop_header
  %ptr_root = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %ptr_root, align 4
  %ptr_k = getelementptr inbounds i32, i32* %arr, i64 %k_phi
  %val_k = load i32, i32* %ptr_k, align 4
  store i32 %val_k, i32* %ptr_root, align 4
  store i32 %root_val, i32* %ptr_k, align 4
  br label %siftdown_sort_header

siftdown_sort_header:                                ; preds = %sort_body, %siftdown_sort_latch
  %j2 = phi i64 [ 0, %sort_body ], [ %j2_next, %siftdown_sort_latch ]
  %twoj2 = shl i64 %j2, 1
  %c2 = add i64 %twoj2, 1
  %has_child2 = icmp ult i64 %c2, %k_phi
  br i1 %has_child2, label %siftdown_sort_has_child, label %siftdown_sort_done

siftdown_sort_has_child:                             ; preds = %siftdown_sort_header
  %c2p1 = add i64 %c2, 1
  %has_right2 = icmp ult i64 %c2p1, %k_phi
  br i1 %has_right2, label %with_right2, label %no_right2

with_right2:                                         ; preds = %siftdown_sort_has_child
  %ptr_r2 = getelementptr inbounds i32, i32* %arr, i64 %c2p1
  %val_r2 = load i32, i32* %ptr_r2, align 4
  %ptr_l2 = getelementptr inbounds i32, i32* %arr, i64 %c2
  %val_l2 = load i32, i32* %ptr_l2, align 4
  %right_gt_left2 = icmp sgt i32 %val_r2, %val_l2
  %mCand2 = select i1 %right_gt_left2, i64 %c2p1, i64 %c2
  br label %compare_sort

no_right2:                                           ; preds = %siftdown_sort_has_child
  br label %compare_sort

compare_sort:                                        ; preds = %with_right2, %no_right2
  %m2 = phi i64 [ %mCand2, %with_right2 ], [ %c2, %no_right2 ]
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %ptr_m2 = getelementptr inbounds i32, i32* %arr, i64 %m2
  %val_m2 = load i32, i32* %ptr_m2, align 4
  %cmp_j_ge_m = icmp sge i32 %val_j2, %val_m2
  br i1 %cmp_j_ge_m, label %siftdown_sort_done, label %do_swap_sort

do_swap_sort:                                        ; preds = %compare_sort
  %save_j2 = load i32, i32* %ptr_j2, align 4
  store i32 %val_m2, i32* %ptr_j2, align 4
  store i32 %save_j2, i32* %ptr_m2, align 4
  br label %siftdown_sort_latch

siftdown_sort_latch:                                 ; preds = %do_swap_sort
  %j2_next = phi i64 [ %m2, %do_swap_sort ]
  br label %siftdown_sort_header

siftdown_sort_done:                                  ; preds = %siftdown_sort_header, %compare_sort
  br label %sort_latch

sort_latch:                                          ; preds = %siftdown_sort_done
  %k_dec = add i64 %k_phi, -1
  br label %sort_loop_header

exit:                                                ; preds = %sort_loop_header, %entry
  ret void
}