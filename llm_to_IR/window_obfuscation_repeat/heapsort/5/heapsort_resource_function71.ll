; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:                                           ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_loop_dec

build_loop_dec:                                       ; preds = %build_loop_dec_body_end, %build_init
  %i_prev_phi = phi i64 [ %half, %build_init ], [ %i_prev_next, %build_loop_dec_body_end ]
  %isZero = icmp eq i64 %i_prev_phi, 0
  br i1 %isZero, label %after_build, label %build_do

build_do:                                             ; preds = %build_loop_dec
  %i_start = add i64 %i_prev_phi, -1
  br label %sift_loop

sift_loop:                                            ; preds = %sift_swapped, %build_do
  %k = phi i64 [ %i_start, %build_do ], [ %k_next, %sift_swapped ]
  %k2 = shl i64 %k, 1
  %left = add i64 %k2, 1
  %lt_left = icmp ult i64 %left, %n
  br i1 %lt_left, label %sift_has_left, label %build_loop_dec_body_end

sift_has_left:                                        ; preds = %sift_loop
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_children, label %choose_left

cmp_children:                                         ; preds = %sift_has_left
  %left_val_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_val_ptr, align 4
  %right_val_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_val_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:                                         ; preds = %cmp_children
  %j_right = phi i64 [ %right, %cmp_children ]
  br label %j_chosen

choose_left:                                          ; preds = %cmp_children, %sift_has_left
  %j_left = phi i64 [ %left, %sift_has_left ], [ %left, %cmp_children ]
  br label %j_chosen

j_chosen:                                             ; preds = %choose_left, %choose_right
  %j = phi i64 [ %j_right, %choose_right ], [ %j_left, %choose_left ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %need_swap = icmp slt i32 %k_val, %j_val
  br i1 %need_swap, label %sift_do_swap, label %build_loop_dec_body_end

sift_do_swap:                                         ; preds = %j_chosen
  store i32 %j_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %j_ptr, align 4
  %k_next = add i64 %j, 0
  br label %sift_swapped

sift_swapped:                                         ; preds = %sift_do_swap
  br label %sift_loop

build_loop_dec_body_end:                              ; preds = %j_chosen, %sift_loop
  %i_prev_next = add i64 %i_prev_phi, -1
  br label %build_loop_dec

after_build:                                          ; preds = %build_loop_dec
  %end_init = add i64 %n, -1
  br label %outer_loop

outer_loop:                                           ; preds = %outer_body_end, %after_build
  %end_phi = phi i64 [ %end_init, %after_build ], [ %end_next, %outer_body_end ]
  %end_is_zero = icmp eq i64 %end_phi, 0
  br i1 %end_is_zero, label %ret, label %outer_body_swap

outer_body_swap:                                      ; preds = %outer_loop
  %a0ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %aendptr = getelementptr inbounds i32, i32* %arr, i64 %end_phi
  %aend = load i32, i32* %aendptr, align 4
  store i32 %aend, i32* %a0ptr, align 4
  store i32 %a0, i32* %aendptr, align 4
  br label %sift2_loop

sift2_loop:                                           ; preds = %sift2_swapped, %outer_body_swap
  %k2_phi = phi i64 [ 0, %outer_body_swap ], [ %k2_next, %sift2_swapped ]
  %k2_dbl = shl i64 %k2_phi, 1
  %left2 = add i64 %k2_dbl, 1
  %has_left2 = icmp ult i64 %left2, %end_phi
  br i1 %has_left2, label %sift2_has_left, label %outer_body_end

sift2_has_left:                                       ; preds = %sift2_loop
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %end_phi
  br i1 %has_right2, label %cmp_children2, label %choose_left2

cmp_children2:                                        ; preds = %sift2_has_left
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right2_gt_left2, label %choose_right2, label %choose_left2

choose_right2:                                        ; preds = %cmp_children2
  %j2_right = phi i64 [ %right2, %cmp_children2 ]
  br label %j2_chosen

choose_left2:                                         ; preds = %cmp_children2, %sift2_has_left
  %j2_left = phi i64 [ %left2, %sift2_has_left ], [ %left2, %cmp_children2 ]
  br label %j2_chosen

j2_chosen:                                            ; preds = %choose_left2, %choose_right2
  %j2 = phi i64 [ %j2_right, %choose_right2 ], [ %j2_left, %choose_left2 ]
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2_phi
  %k2_val = load i32, i32* %k2_ptr, align 4
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %need_swap2 = icmp slt i32 %k2_val, %j2_val
  br i1 %need_swap2, label %sift2_do_swap, label %outer_body_end

sift2_do_swap:                                        ; preds = %j2_chosen
  store i32 %j2_val, i32* %k2_ptr, align 4
  store i32 %k2_val, i32* %j2_ptr, align 4
  %k2_next = add i64 %j2, 0
  br label %sift2_swapped

sift2_swapped:                                        ; preds = %sift2_do_swap
  br label %sift2_loop

outer_body_end:                                       ; preds = %j2_chosen, %sift2_loop
  %end_next = add i64 %end_phi, -1
  br label %outer_loop

ret:                                                  ; preds = %outer_loop, %entry
  ret void
}