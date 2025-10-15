; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

declare void @__main()
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define internal void @ms_rec(i32* %arr, i64 %lo, i64 %hi, i32* %tmp) {
entry:
  %sub = sub i64 %hi, %lo
  %base = icmp ule i64 %sub, 1
  br i1 %base, label %ret, label %recurse

recurse:
  %sum = add i64 %lo, %hi
  %mid = lshr i64 %sum, 1
  call void @ms_rec(i32* %arr, i64 %lo, i64 %mid, i32* %tmp)
  call void @ms_rec(i32* %arr, i64 %mid, i64 %hi, i32* %tmp)
  br label %merge_init

merge_init:
  br label %merge_cond

merge_cond:
  %i_phi = phi i64 [ %lo, %merge_init ], [ %i_next, %merge_latch ]
  %j_phi = phi i64 [ %mid, %merge_init ], [ %j_next, %merge_latch ]
  %k_phi = phi i64 [ %lo, %merge_init ], [ %k_next, %merge_latch ]
  %i_lt_mid = icmp ult i64 %i_phi, %mid
  %j_lt_hi = icmp ult i64 %j_phi, %hi
  %both_lt = and i1 %i_lt_mid, %j_lt_hi
  br i1 %both_lt, label %merge_body, label %post_merge

merge_body:
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_phi
  %ai = load i32, i32* %i_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_phi
  %aj = load i32, i32* %j_ptr, align 4
  %cmp_vals = icmp sle i32 %ai, %aj
  %out_val = select i1 %cmp_vals, i32 %ai, i32 %aj
  %tmp_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k_phi
  store i32 %out_val, i32* %tmp_ptr, align 4
  %i_inc = add i64 %i_phi, 1
  %j_inc = add i64 %j_phi, 1
  %k_inc = add i64 %k_phi, 1
  %i_next = select i1 %cmp_vals, i64 %i_inc, i64 %i_phi
  %j_next = select i1 %cmp_vals, i64 %j_phi, i64 %j_inc
  %k_next = %k_inc
  br label %merge_latch

merge_latch:
  br label %merge_cond

post_merge:
  %i_rem = icmp ult i64 %i_phi, %mid
  br i1 %i_rem, label %copy_left_init, label %check_right

copy_left_init:
  br label %copy_left_cond

copy_left_cond:
  %ci_phi = phi i64 [ %i_phi, %copy_left_init ], [ %ci_next, %copy_left_body ]
  %ck_phi = phi i64 [ %k_phi, %copy_left_init ], [ %ck_next, %copy_left_body ]
  %ci_lt = icmp ult i64 %ci_phi, %mid
  br i1 %ci_lt, label %copy_left_body, label %after_copies

copy_left_body:
  %src_l_ptr = getelementptr inbounds i32, i32* %arr, i64 %ci_phi
  %val_l = load i32, i32* %src_l_ptr, align 4
  %dst_l_ptr = getelementptr inbounds i32, i32* %tmp, i64 %ck_phi
  store i32 %val_l, i32* %dst_l_ptr, align 4
  %ci_next = add i64 %ci_phi, 1
  %ck_next = add i64 %ck_phi, 1
  br label %copy_left_cond

check_right:
  %j_rem = icmp ult i64 %j_phi, %hi
  br i1 %j_rem, label %copy_right_init, label %after_copies

copy_right_init:
  br label %copy_right_cond

copy_right_cond:
  %cj_phi = phi i64 [ %j_phi, %copy_right_init ], [ %cj_next, %copy_right_body ]
  %ckr_phi = phi i64 [ %k_phi, %copy_right_init ], [ %ckr_next, %copy_right_body ]
  %cj_lt = icmp ult i64 %cj_phi, %hi
  br i1 %cj_lt, label %copy_right_body, label %after_copies

copy_right_body:
  %src_r_ptr = getelementptr inbounds i32, i32* %arr, i64 %cj_phi
  %val_r = load i32, i32* %src_r_ptr, align 4
  %dst_r_ptr = getelementptr inbounds i32, i32* %tmp, i64 %ckr_phi
  store i32 %val_r, i32* %dst_r_ptr, align 4
  %cj_next = add i64 %cj_phi, 1
  %ckr_next = add i64 %ckr_phi, 1
  br label %copy_right_cond

after_copies:
  br label %copy_back_init

copy_back_init:
  br label %copy_back_cond

copy_back_cond:
  %t_phi = phi i64 [ %lo, %copy_back_init ], [ %t_next, %copy_back_body ]
  %t_lt = icmp ult i64 %t_phi, %hi
  br i1 %t_lt, label %copy_back_body, label %ret

copy_back_body:
  %tmp_t_ptr = getelementptr inbounds i32, i32* %tmp, i64 %t_phi
  %val_t = load i32, i32* %tmp_t_ptr, align 4
  %arr_t_ptr = getelementptr inbounds i32, i32* %arr, i64 %t_phi
  store i32 %val_t, i32* %arr_t_ptr, align 4
  %t_next = add i64 %t_phi, 1
  br label %copy_back_cond

ret:
  ret void
}

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %too_small = icmp ule i64 %n, 1
  br i1 %too_small, label %ret, label %alloc

alloc:
  %tmp = alloca i32, i64 %n, align 16
  call void @ms_rec(i32* %arr, i64 0, i64 %n, i32* %tmp)
  br label %ret

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9, align 4
  call void @merge_sort(i32* %arr0, i64 10)
  br label %loop_init

loop_init:
  br label %loop_cond

loop_cond:
  %i = phi i64 [ 0, %loop_init ], [ %i_next, %loop_body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %elem_ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %val = load i32, i32* %elem_ptr, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %val)
  %i_next = add i64 %i, 1
  br label %loop_cond

after_loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}