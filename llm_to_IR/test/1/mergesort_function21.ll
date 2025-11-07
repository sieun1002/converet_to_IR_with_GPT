; ModuleID = 'merge_sort'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %malloc_ptr = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %malloc_ptr, null
  br i1 %isnull, label %ret, label %init

init:
  %buf_i32 = bitcast i8* %malloc_ptr to i32*
  br label %outer_header

outer_header:
  %step_phi = phi i64 [ 1, %init ], [ %step_next, %after_inner ]
  %src_phi = phi i32* [ %dest, %init ], [ %tmp_phi, %after_inner ]
  %tmp_phi = phi i32* [ %buf_i32, %init ], [ %src_phi, %after_inner ]
  %cont_outer = icmp ult i64 %step_phi, %n
  br i1 %cont_outer, label %inner_header, label %after_outer

inner_header:
  %i_phi = phi i64 [ 0, %outer_header ], [ %i_next, %after_merge ]
  %cond_inner = icmp ult i64 %i_phi, %n
  br i1 %cond_inner, label %prepare_merge, label %after_inner

prepare_merge:
  %i_plus_step = add i64 %i_phi, %step_phi
  %i_step_gt_n = icmp ugt i64 %i_plus_step, %n
  %mid = select i1 %i_step_gt_n, i64 %n, i64 %i_plus_step
  %step2 = add i64 %step_phi, %step_phi
  %i_plus_2step = add i64 %i_phi, %step2
  %i_2step_gt_n = icmp ugt i64 %i_plus_2step, %n
  %right = select i1 %i_2step_gt_n, i64 %n, i64 %i_plus_2step
  br label %merge_loop_header

merge_loop_header:
  %k_phi = phi i64 [ %i_phi, %prepare_merge ], [ %k_phi_next, %merge_body_end ]
  %l_phi = phi i64 [ %i_phi, %prepare_merge ], [ %l_phi_next, %merge_body_end ]
  %r_phi = phi i64 [ %mid, %prepare_merge ], [ %r_phi_next, %merge_body_end ]
  %cond_k = icmp ult i64 %k_phi, %right
  br i1 %cond_k, label %choose_lcheck, label %after_merge

choose_lcheck:
  %l_lt_mid = icmp ult i64 %l_phi, %mid
  br i1 %l_lt_mid, label %check_r, label %take_right

check_r:
  %r_lt_right = icmp ult i64 %r_phi, %right
  br i1 %r_lt_right, label %compare_vals, label %take_left

compare_vals:
  %l_gep = getelementptr inbounds i32, i32* %src_phi, i64 %l_phi
  %l_val = load i32, i32* %l_gep, align 4
  %r_gep = getelementptr inbounds i32, i32* %src_phi, i64 %r_phi
  %r_val = load i32, i32* %r_gep, align 4
  %cmp_vals = icmp sgt i32 %l_val, %r_val
  br i1 %cmp_vals, label %take_right, label %take_left

take_left:
  %src_l_ptr = getelementptr inbounds i32, i32* %src_phi, i64 %l_phi
  %val_l = load i32, i32* %src_l_ptr, align 4
  %tmp_k_ptr = getelementptr inbounds i32, i32* %tmp_phi, i64 %k_phi
  store i32 %val_l, i32* %tmp_k_ptr, align 4
  %l_next = add i64 %l_phi, 1
  %r_keep = add i64 %r_phi, 0
  %k_inc_l = add i64 %k_phi, 1
  br label %merge_body_end

take_right:
  %src_r_ptr = getelementptr inbounds i32, i32* %src_phi, i64 %r_phi
  %val_r = load i32, i32* %src_r_ptr, align 4
  %tmp_k_ptr2 = getelementptr inbounds i32, i32* %tmp_phi, i64 %k_phi
  store i32 %val_r, i32* %tmp_k_ptr2, align 4
  %l_keep = add i64 %l_phi, 0
  %r_next = add i64 %r_phi, 1
  %k_inc_r = add i64 %k_phi, 1
  br label %merge_body_end

merge_body_end:
  %l_phi_next = phi i64 [ %l_next, %take_left ], [ %l_keep, %take_right ]
  %r_phi_next = phi i64 [ %r_keep, %take_left ], [ %r_next, %take_right ]
  %k_phi_next = phi i64 [ %k_inc_l, %take_left ], [ %k_inc_r, %take_right ]
  br label %merge_loop_header

after_merge:
  %two_step = add i64 %step_phi, %step_phi
  %i_next = add i64 %i_phi, %two_step
  br label %inner_header

after_inner:
  %step_next = shl i64 %step_phi, 1
  br label %outer_header

after_outer:
  %src_eq_dest = icmp eq i32* %src_phi, %dest
  br i1 %src_eq_dest, label %free_and_ret, label %do_memcpy

do_memcpy:
  %copy_bytes = shl i64 %n, 2
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8_final = bitcast i32* %src_phi to i8*
  %memcpy_ret = call i8* @memcpy(i8* %dest_i8, i8* %src_i8_final, i64 %copy_bytes)
  br label %free_and_ret

free_and_ret:
  call void @free(i8* %malloc_ptr)
  br label %ret

ret:
  ret void
}