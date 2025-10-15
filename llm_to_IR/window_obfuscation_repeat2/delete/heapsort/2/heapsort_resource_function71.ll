; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* %arg0, i64 %arg8) {
entry:
  %cmp_len_le1 = icmp ule i64 %arg8, 1
  br i1 %cmp_len_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %arg8, 1
  br label %build_loop_dec

build_loop_dec:
  %var8_phi = phi i64 [ %half, %build_init ], [ %var8_next, %sift_exit ]
  %var8_nondec = add i64 %var8_phi, 0
  %var8_next = add i64 %var8_nondec, -1
  %cond = icmp ne i64 %var8_nondec, 0
  br i1 %cond, label %build_iter_start, label %after_build

build_iter_start:
  %i_init = add i64 %var8_next, 0
  br label %sift_loop

sift_loop:
  %i_phi = phi i64 [ %i_init, %build_iter_start ], [ %i_new, %did_swap ]
  %left_mul2 = shl i64 %i_phi, 1
  %left = add i64 %left_mul2, 1
  %left_in_range = icmp ult i64 %left, %arg8
  br i1 %left_in_range, label %choose_right_check, label %sift_exit

choose_right_check:
  %right = add i64 %left, 1
  %right_in_range = icmp ult i64 %right, %arg8
  br i1 %right_in_range, label %compare_children, label %child_choice_left

compare_children:
  %ptr_right = getelementptr inbounds i32, i32* %arg0, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arg0, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %cmp_right_le_left = icmp sle i32 %val_right, %val_left
  br i1 %cmp_right_le_left, label %child_choice_left, label %child_choice_right

child_choice_right:
  br label %child_chosen

child_choice_left:
  br label %child_chosen

child_chosen:
  %chosen = phi i64 [ %right, %child_choice_right ], [ %left, %child_choice_left ]
  %ptr_i = getelementptr inbounds i32, i32* %arg0, i64 %i_phi
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_chosen = getelementptr inbounds i32, i32* %arg0, i64 %chosen
  %val_chosen = load i32, i32* %ptr_chosen, align 4
  %cmp_i_lt_chosen = icmp slt i32 %val_i, %val_chosen
  br i1 %cmp_i_lt_chosen, label %do_swap, label %sift_exit

do_swap:
  store i32 %val_chosen, i32* %ptr_i, align 4
  store i32 %val_i, i32* %ptr_chosen, align 4
  %i_new = add i64 %chosen, 0
  br label %did_swap

did_swap:
  br label %sift_loop

sift_exit:
  br label %build_loop_dec

after_build:
  %end_index = add i64 %arg8, -1
  br label %extract_check

extract_check:
  %var20 = phi i64 [ %end_index, %after_build ], [ %var20_next, %extract_end_adjust ]
  %cond_extract = icmp ne i64 %var20, 0
  br i1 %cond_extract, label %extract_body, label %ret

extract_body:
  %ptr0 = getelementptr inbounds i32, i32* %arg0, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arg0, i64 %var20
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %extract_sift_loop

extract_sift_loop:
  %i2 = phi i64 [ 0, %extract_body ], [ %i2_new, %extract_did_swap ]
  %left2_mul = shl i64 %i2, 1
  %left2 = add i64 %left2_mul, 1
  %left_lt_var20 = icmp ult i64 %left2, %var20
  br i1 %left_lt_var20, label %right2_check, label %extract_break_paths

right2_check:
  %right2 = add i64 %left2, 1
  %right_in_range2 = icmp ult i64 %right2, %var20
  br i1 %right_in_range2, label %compare_children2, label %child_choice_left2

compare_children2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arg0, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arg0, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %cmp_right_le_left2 = icmp sle i32 %val_right2, %val_left2
  br i1 %cmp_right_le_left2, label %child_choice_left2, label %child_choice_right2

child_choice_right2:
  br label %child_chosen2

child_choice_left2:
  br label %child_chosen2

child_chosen2:
  %chosen2 = phi i64 [ %right2, %child_choice_right2 ], [ %left2, %child_choice_left2 ]
  %ptr_i2 = getelementptr inbounds i32, i32* %arg0, i64 %i2
  %val_i2 = load i32, i32* %ptr_i2, align 4
  %ptr_chosen2 = getelementptr inbounds i32, i32* %arg0, i64 %chosen2
  %val_chosen2 = load i32, i32* %ptr_chosen2, align 4
  %cmp_i_ge_chosen2 = icmp sge i32 %val_i2, %val_chosen2
  br i1 %cmp_i_ge_chosen2, label %extract_break2, label %do_swap2

do_swap2:
  store i32 %val_chosen2, i32* %ptr_i2, align 4
  store i32 %val_i2, i32* %ptr_chosen2, align 4
  %i2_new = add i64 %chosen2, 0
  br label %extract_did_swap

extract_did_swap:
  br label %extract_sift_loop

extract_break2:
  br label %extract_break_paths

extract_break_paths:
  %var20_next = add i64 %var20, -1
  br label %extract_end_adjust

extract_end_adjust:
  br label %extract_check

ret:
  ret void
}