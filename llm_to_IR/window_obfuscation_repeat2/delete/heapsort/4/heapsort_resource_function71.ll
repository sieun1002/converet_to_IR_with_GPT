; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %end, label %build_init

build_init:                                        ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_header

build_header:                                      ; preds = %build_continue, %build_init
  %i = phi i64 [ %half, %build_init ], [ %i_next, %build_continue ]
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %post_build_init, label %sift_entry

sift_entry:                                        ; preds = %build_header
  %var10_init = add i64 %i, -1
  br label %sift_check

sift_check:                                        ; preds = %sift_swap_cont, %sift_entry
  %var10 = phi i64 [ %var10_init, %sift_entry ], [ %var10_next, %sift_swap_cont ]
  %tmp1 = shl i64 %var10, 1
  %child = add i64 %tmp1, 1
  %have_child = icmp ult i64 %child, %n
  br i1 %have_child, label %maybe_choose_right, label %build_continue

maybe_choose_right:                                ; preds = %sift_check
  %right = add i64 %child, 1
  %has_right = icmp ult i64 %right, %n
  %gep_left = getelementptr inbounds i32, i32* %arr, i64 %child
  %left_val = load i32, i32* %gep_left, align 4
  br i1 %has_right, label %with_right, label %no_right

with_right:                                        ; preds = %maybe_choose_right
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %gep_right, align 4
  %cmp_rl = icmp sgt i32 %right_val, %left_val
  %best_idx_with = select i1 %cmp_rl, i64 %right, i64 %child
  br label %choose_done

no_right:                                          ; preds = %maybe_choose_right
  br label %choose_done

choose_done:                                       ; preds = %no_right, %with_right
  %best_idx = phi i64 [ %best_idx_with, %with_right ], [ %child, %no_right ]
  %gep_var10 = getelementptr inbounds i32, i32* %arr, i64 %var10
  %val_var10 = load i32, i32* %gep_var10, align 4
  %gep_best = getelementptr inbounds i32, i32* %arr, i64 %best_idx
  %val_best = load i32, i32* %gep_best, align 4
  %cmp_lt = icmp slt i32 %val_var10, %val_best
  br i1 %cmp_lt, label %sift_swap, label %build_continue

sift_swap:                                         ; preds = %choose_done
  store i32 %val_best, i32* %gep_var10, align 4
  store i32 %val_var10, i32* %gep_best, align 4
  %var10_next = add i64 %best_idx, 0
  br label %sift_swap_cont

sift_swap_cont:                                    ; preds = %sift_swap
  br label %sift_check

build_continue:                                    ; preds = %choose_done, %sift_check
  %i_next = phi i64 [ %var10_init, %sift_check ], [ %var10_init, %choose_done ]
  br label %build_header

post_build_init:                                   ; preds = %build_header
  %end_idx_init = add i64 %n, -1
  br label %extract_header

extract_header:                                    ; preds = %after_sift2, %post_build_init
  %end_idx = phi i64 [ %end_idx_init, %post_build_init ], [ %end_idx_next, %after_sift2 ]
  %cond2 = icmp ne i64 %end_idx, 0
  br i1 %cond2, label %extract_body, label %end

extract_body:                                      ; preds = %extract_header
  %gep0 = getelementptr inbounds i32, i32* %arr, i64 0
  %root = load i32, i32* %gep0, align 4
  %gepend = getelementptr inbounds i32, i32* %arr, i64 %end_idx
  %last = load i32, i32* %gepend, align 4
  store i32 %last, i32* %gep0, align 4
  store i32 %root, i32* %gepend, align 4
  br label %sift2_check

sift2_check:                                       ; preds = %sift2_swap_cont, %extract_body
  %i2 = phi i64 [ 0, %extract_body ], [ %i2_next, %sift2_swap_cont ]
  %child2tmp = shl i64 %i2, 1
  %child2 = add i64 %child2tmp, 1
  %have_child2 = icmp ult i64 %child2, %end_idx
  br i1 %have_child2, label %maybe_choose_right2, label %after_sift2

maybe_choose_right2:                               ; preds = %sift2_check
  %right2 = add i64 %child2, 1
  %has_right2 = icmp ult i64 %right2, %end_idx
  %gep_left2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %left_val2 = load i32, i32* %gep_left2, align 4
  br i1 %has_right2, label %with_right2, label %no_right2

with_right2:                                       ; preds = %maybe_choose_right2
  %gep_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %gep_right2, align 4
  %cmp_rl2 = icmp sgt i32 %right_val2, %left_val2
  %best_idx2_with = select i1 %cmp_rl2, i64 %right2, i64 %child2
  br label %choose_done2

no_right2:                                         ; preds = %maybe_choose_right2
  br label %choose_done2

choose_done2:                                      ; preds = %no_right2, %with_right2
  %best_idx2 = phi i64 [ %best_idx2_with, %with_right2 ], [ %child2, %no_right2 ]
  %gep_i2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %val_i2 = load i32, i32* %gep_i2, align 4
  %gep_best2 = getelementptr inbounds i32, i32* %arr, i64 %best_idx2
  %val_best2 = load i32, i32* %gep_best2, align 4
  %cmp_ge2 = icmp sge i32 %val_i2, %val_best2
  br i1 %cmp_ge2, label %after_sift2, label %sift2_swap

sift2_swap:                                        ; preds = %choose_done2
  store i32 %val_best2, i32* %gep_i2, align 4
  store i32 %val_i2, i32* %gep_best2, align 4
  %i2_next = add i64 %best_idx2, 0
  br label %sift2_swap_cont

sift2_swap_cont:                                   ; preds = %sift2_swap
  br label %sift2_check

after_sift2:                                       ; preds = %choose_done2, %sift2_check
  %end_idx_next = add i64 %end_idx, -1
  br label %extract_header

end:                                               ; preds = %extract_header, %entry
  ret void
}