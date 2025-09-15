; ModuleID = 'dfs_module'
source_filename = "dfs.ll"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %outCount) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %alloc, label %ret_zero

ret_zero:
  store i64 0, i64* %outCount, align 8
  ret void

alloc:
  %bytes_vis = shl i64 %n, 2
  %pvis_raw = call noalias i8* @malloc(i64 %bytes_vis)
  %visited = bitcast i8* %pvis_raw to i32*
  %bytes_nx = shl i64 %n, 3
  %pnext_raw = call noalias i8* @malloc(i64 %bytes_nx)
  %next = bitcast i8* %pnext_raw to i64*
  %pstack_raw = call noalias i8* @malloc(i64 %bytes_nx)
  %stack = bitcast i8* %pstack_raw to i64*
  %vis_null = icmp eq i8* %pvis_raw, null
  %next_null = icmp eq i8* %pnext_raw, null
  %stack_null = icmp eq i8* %pstack_raw, null
  %tmp0 = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp0, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %pvis_raw)
  call void @free(i8* %pnext_raw)
  call void @free(i8* %pstack_raw)
  store i64 0, i64* %outCount, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i_next, %init_body_end ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %init_body, label %post_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_body_end

init_body_end:
  %i_next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %outCount, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %cur0 = load i64, i64* %outCount, align 8
  %cur1 = add i64 %cur0, 1
  store i64 %cur1, i64* %outCount, align 8
  %out_pos0 = getelementptr inbounds i64, i64* %out, i64 %cur0
  store i64 %start, i64* %out_pos0, align 8
  br label %outer_cond

outer_cond:
  %ss = phi i64 [ 1, %post_init ], [ %ss2, %after_inner_or_pop ]
  %has = icmp ne i64 %ss, 0
  br i1 %has, label %outer_body, label %done

outer_body:
  %ssm1 = add i64 %ss, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %v0 = load i64, i64* %next_u_ptr, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ %v0, %outer_body ], [ %v_inc, %inner_continue ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_check_edge, label %no_more_neighbors

inner_check_edge:
  %u_mul_n = mul i64 %u, %n
  %uv = add i64 %u_mul_n, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %uv
  %edge_val = load i32, i32* %adj_ptr, align 4
  %edge_nz = icmp ne i32 %edge_val, 0
  br i1 %edge_nz, label %check_visited, label %inner_continue

check_visited:
  %vis_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %vis_v = load i32, i32* %vis_v_ptr, align 4
  %not_vis = icmp eq i32 %vis_v, 0
  br i1 %not_vis, label %take_edge, label %inner_continue

take_edge:
  %v1 = add i64 %v, 1
  store i64 %v1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_v_ptr, align 4
  %curA = load i64, i64* %outCount, align 8
  %curA_inc = add i64 %curA, 1
  store i64 %curA_inc, i64* %outCount, align 8
  %out_pos = getelementptr inbounds i64, i64* %out, i64 %curA
  store i64 %v, i64* %out_pos, align 8
  %stack_pos = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %v, i64* %stack_pos, align 8
  %ss_inc = add i64 %ss, 1
  br label %after_inner_or_pop

inner_continue:
  %v_inc = add i64 %v, 1
  br label %inner_loop

no_more_neighbors:
  %ss_dec = add i64 %ss, -1
  br label %after_inner_or_pop

after_inner_or_pop:
  %ss2 = phi i64 [ %ss_inc, %take_edge ], [ %ss_dec, %no_more_neighbors ]
  br label %outer_cond

done:
  call void @free(i8* %pvis_raw)
  call void @free(i8* %pnext_raw)
  call void @free(i8* %pstack_raw)
  ret void
}