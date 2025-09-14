; External declarations
declare i8* @memset(i8* noundef, i32 noundef, i64 noundef)
declare i32 @min_index(i32* noundef, i32* noundef, i32 noundef)

define void @dijkstra(i32* noundef %adj, i32 noundef %n, i32 noundef %start, i32* noundef %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s_i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* noundef %s_i8, i32 noundef 0, i64 noundef 400)

  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %init_loop

init_loop:                                            ; preds = %init_body, %entry
  %i_val = load i32, i32* %i, align 4
  %cmp_i = icmp slt i32 %i_val, %n
  br i1 %cmp_i, label %init_body, label %init_end

init_body:                                            ; preds = %init_loop
  %i64 = sext i32 %i_val to i64
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist_i_ptr, align 4
  %i_next = add i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %init_loop

init_end:                                             ; preds = %init_loop
  %start64 = sext i32 %start to i64
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start64
  store i32 0, i32* %dist_start_ptr, align 4

  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %outer_cond

outer_cond:                                           ; preds = %v_end, %init_end
  %k_val = load i32, i32* %k, align 4
  %n_minus1 = add i32 %n, -1
  %cmp_k = icmp slt i32 %k_val, %n_minus1
  br i1 %cmp_k, label %outer_body, label %exit

outer_body:                                           ; preds = %outer_cond
  %s_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* noundef %dist, i32* noundef %s_ptr, i32 noundef %n)
  %cmp_u_neg1 = icmp eq i32 %u, -1
  br i1 %cmp_u_neg1, label %exit, label %after_u

after_u:                                              ; preds = %outer_body
  %u64 = sext i32 %u to i64
  %s_u_ptr = getelementptr inbounds i32, i32* %s_ptr, i64 %u64
  store i32 1, i32* %s_u_ptr, align 4

  %v = alloca i32, align 4
  store i32 0, i32* %v, align 4
  br label %v_cond

v_cond:                                               ; preds = %v_next, %after_u
  %v_val = load i32, i32* %v, align 4
  %cmp_v = icmp slt i32 %v_val, %n
  br i1 %cmp_v, label %v_body, label %v_end

v_body:                                               ; preds = %v_cond
  %v64 = sext i32 %v_val to i64
  %u_mul_100 = mul nsw i64 %u64, 100
  %index = add nsw i64 %u_mul_100, %v64
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %index
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %edge_nz = icmp ne i32 %adj_val, 0
  br i1 %edge_nz, label %check_s_and_dist, label %v_next

check_s_and_dist:                                     ; preds = %v_body
  %s_v_ptr = getelementptr inbounds i32, i32* %s_ptr, i64 %v64
  %s_v = load i32, i32* %s_v_ptr, align 4
  %s_v_zero = icmp eq i32 %s_v, 0
  br i1 %s_v_zero, label %check_dist_u, label %v_next

check_dist_u:                                         ; preds = %check_s_and_dist
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_is_inf = icmp eq i32 %dist_u, 2147483647
  br i1 %dist_u_is_inf, label %v_next, label %relax

relax:                                                ; preds = %check_dist_u
  %newdist = add nsw i32 %dist_u, %adj_val
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %cmp_new = icmp slt i32 %newdist, %dist_v
  br i1 %cmp_new, label %do_update, label %v_next

do_update:                                            ; preds = %relax
  store i32 %newdist, i32* %dist_v_ptr, align 4
  br label %v_next

v_next:                                               ; preds = %do_update, %relax, %check_dist_u, %check_s_and_dist, %v_body
  %v_val2 = load i32, i32* %v, align 4
  %v_inc = add i32 %v_val2, 1
  store i32 %v_inc, i32* %v, align 4
  br label %v_cond

v_end:                                                ; preds = %v_cond
  %k_val2 = load i32, i32* %k, align 4
  %k_inc = add i32 %k_val2, 1
  store i32 %k_inc, i32* %k, align 4
  br label %outer_cond

exit:                                                 ; preds = %outer_body, %outer_cond
  ret void
}