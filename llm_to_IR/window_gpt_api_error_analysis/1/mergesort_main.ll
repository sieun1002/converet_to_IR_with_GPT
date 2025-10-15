; ModuleID = 'msvc_x64_mergesort'
source_filename = "msvc_x64_mergesort"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @merge_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %rec

rec:
  %mid = udiv i64 %n, 2
  %rightptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  call void @merge_sort(i32* %arr, i64 %mid)
  %n_minus_mid = sub i64 %n, %mid
  call void @merge_sort(i32* %rightptr, i64 %n_minus_mid)
  %tmp = alloca i32, i64 %n, align 4
  br label %loop1.header

loop1.header:
  %phi_i = phi i64 [ 0, %rec ], [ %i_next, %loop1.join ]
  %phi_j = phi i64 [ %mid, %rec ], [ %j_next, %loop1.join ]
  %phi_k = phi i64 [ 0, %rec ], [ %k_next, %loop1.join ]
  %cond_i = icmp ult i64 %phi_i, %mid
  %cond_j = icmp ult i64 %phi_j, %n
  %cond_both = and i1 %cond_i, %cond_j
  br i1 %cond_both, label %loop1.body, label %after_loop1

loop1.body:
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %phi_i
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %phi_j
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_vals = icmp sle i32 %val_i, %val_j
  br i1 %cmp_vals, label %pick_left, label %pick_right

pick_left:
  %tmp_ptr_k_l = getelementptr inbounds i32, i32* %tmp, i64 %phi_k
  store i32 %val_i, i32* %tmp_ptr_k_l, align 4
  %i_inc = add i64 %phi_i, 1
  %k_inc_l = add i64 %phi_k, 1
  br label %loop1.join

pick_right:
  %tmp_ptr_k_r = getelementptr inbounds i32, i32* %tmp, i64 %phi_k
  store i32 %val_j, i32* %tmp_ptr_k_r, align 4
  %j_inc = add i64 %phi_j, 1
  %k_inc_r = add i64 %phi_k, 1
  br label %loop1.join

loop1.join:
  %i_next = phi i64 [ %i_inc, %pick_left ], [ %phi_i, %pick_right ]
  %j_next = phi i64 [ %phi_j, %pick_left ], [ %j_inc, %pick_right ]
  %k_next = phi i64 [ %k_inc_l, %pick_left ], [ %k_inc_r, %pick_right ]
  br label %loop1.header

after_loop1:
  %i_after = phi i64 [ %phi_i, %loop1.header ]
  %j_after = phi i64 [ %phi_j, %loop1.header ]
  %k_after = phi i64 [ %phi_k, %loop1.header ]
  br label %copy_left.header

copy_left.header:
  %i_cl = phi i64 [ %i_after, %after_loop1 ], [ %i_cl_next, %copy_left.body ]
  %k_cl = phi i64 [ %k_after, %after_loop1 ], [ %k_cl_next, %copy_left.body ]
  %cond_left = icmp ult i64 %i_cl, %mid
  br i1 %cond_left, label %copy_left.body, label %copy_right.header

copy_left.body:
  %src_li_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cl
  %src_li = load i32, i32* %src_li_ptr, align 4
  %dst_l_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k_cl
  store i32 %src_li, i32* %dst_l_ptr, align 4
  %i_cl_next = add i64 %i_cl, 1
  %k_cl_next = add i64 %k_cl, 1
  br label %copy_left.header

copy_right.header:
  %j_cr = phi i64 [ %j_after, %after_loop1 ], [ %j_after, %copy_left.header ], [ %j_cr_next, %copy_right.body ]
  %k_cr = phi i64 [ %k_after, %after_loop1 ], [ %k_cl, %copy_left.header ], [ %k_cr_next, %copy_right.body ]
  %cond_right = icmp ult i64 %j_cr, %n
  br i1 %cond_right, label %copy_right.body, label %copy_merge_back.header

copy_right.body:
  %src_rj_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_cr
  %src_rj = load i32, i32* %src_rj_ptr, align 4
  %dst_r_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k_cr
  store i32 %src_rj, i32* %dst_r_ptr, align 4
  %j_cr_next = add i64 %j_cr, 1
  %k_cr_next = add i64 %k_cr, 1
  br label %copy_right.header

copy_merge_back.header:
  %k_back = phi i64 [ 0, %copy_right.header ], [ %k_back_next, %copy_merge_back.body ]
  %cond_back = icmp ult i64 %k_back, %n
  br i1 %cond_back, label %copy_merge_back.body, label %ret

copy_merge_back.body:
  %tmp_b_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k_back
  %tmp_b_val = load i32, i32* %tmp_b_ptr, align 4
  %arr_b_ptr = getelementptr inbounds i32, i32* %arr, i64 %k_back
  store i32 %tmp_b_val, i32* %arr_b_ptr, align 4
  %k_back_next = add i64 %k_back, 1
  br label %copy_merge_back.header

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr_alloc = alloca [10 x i32], align 16
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr_alloc, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr_base, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr_base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr_base, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr_base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr_base, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr_base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr_base, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr_base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr_base, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr_base, i64 9
  store i32 0, i32* %p9, align 4
  call void @merge_sort(i32* %arr_base, i64 10)
  br label %print_loop.header

print_loop.header:
  %i_index = phi i64 [ 0, %entry ], [ %i_next, %print_loop.body ]
  %cond_loop = icmp ult i64 %i_index, 10
  br i1 %cond_loop, label %print_loop.body, label %after_print

print_loop.body:
  %elem_ptr = getelementptr inbounds i32, i32* %arr_base, i64 %i_index
  %elem_val = load i32, i32* %elem_ptr, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem_val)
  %i_next = add i64 %i_index, 1
  br label %print_loop.header

after_print:
  %callput = call i32 @putchar(i32 10)
  ret i32 0
}