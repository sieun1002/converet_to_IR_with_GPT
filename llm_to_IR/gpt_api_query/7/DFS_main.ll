; LLVM IR for function: dfs (LLVM 14)

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count_ptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %cond0 = or i1 %n_is_zero, %start_ge_n
  br i1 %cond0, label %ret_zero, label %allocs

ret_zero:
  store i64 0, i64* %out_count_ptr, align 8
  ret void

allocs:
  %visited_bytes = shl i64 %n, 2
  %visited_i8 = call noalias i8* @malloc(i64 %visited_bytes)
  %visited = bitcast i8* %visited_i8 to i32*

  %next_bytes = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %next_bytes)
  %next = bitcast i8* %next_i8 to i64*

  %stack_i8 = call noalias i8* @malloc(i64 %next_bytes)
  %stack = bitcast i8* %stack_i8 to i64*

  %visited_is_null = icmp eq i32* %visited, null
  %next_is_null = icmp eq i64* %next, null
  %stack_is_null = icmp eq i64* %stack, null
  %any_null0 = or i1 %visited_is_null, %next_is_null
  %any_null = or i1 %any_null0, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_count_ptr, align 8
  ret void

init_loop:
  br label %init_loop_cond

init_loop_cond:
  %i = phi i64 [ 0, %init_loop ], [ %i_next, %init_loop_body ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_loop_body, label %after_init

init_loop_body:
  %visited_ptr_i = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %visited_ptr_i, align 4
  %next_ptr_i = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr_i, align 8
  %i_next = add i64 %i, 1
  br label %init_loop_cond

after_init:
  store i64 0, i64* %out_count_ptr, align 8

  ; push start at depth 0
  %stack_ptr_0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_ptr_0, align 8

  ; visited[start] = 1
  %visited_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %visited_start_ptr, align 4

  ; *out_count_ptr = *out_count_ptr + 1; out[old] = start
  %count0 = load i64, i64* %out_count_ptr, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_count_ptr, align 8
  %out_idx_ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_idx_ptr, align 8

  br label %outer_cond

outer_cond:
  %depth_phi = phi i64 [ 1, %after_init ], [ %depth_next, %after_continue ]
  %depth_not_zero = icmp ne i64 %depth_phi, 0
  br i1 %depth_not_zero, label %outer_body, label %done

outer_body:
  %depth_minus1 = add i64 %depth_phi, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %depth_minus1
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %v0 = load i64, i64* %next_u_ptr, align 8
  br label %inner_cond

inner_cond:
  %v = phi i64 [ %v0, %outer_body ], [ %v_inc, %inner_body_no_neighbor ]
  %cmp_v_n = icmp ult i64 %v, %n
  br i1 %cmp_v_n, label %inner_body, label %inner_done

inner_body:
  %u_times_n = mul i64 %u, %n
  %index_uv = add i64 %u_times_n, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %index_uv
  %adj_val = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %adj_val, 0
  br i1 %has_edge, label %check_unvisited, label %inner_body_no_neighbor

check_unvisited:
  %visited_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %visited_v = load i32, i32* %visited_v_ptr, align 4
  %is_unvisited = icmp eq i32 %visited_v, 0
  br i1 %is_unvisited, label %found_neighbor, label %inner_body_no_neighbor

inner_body_no_neighbor:
  %v_inc = add i64 %v, 1
  br label %inner_cond

found_neighbor:
  %v_plus1 = add i64 %v, 1
  store i64 %v_plus1, i64* %next_u_ptr, align 8

  store i32 1, i32* %visited_v_ptr, align 4

  %countA = load i64, i64* %out_count_ptr, align 8
  %countA_inc = add i64 %countA, 1
  store i64 %countA_inc, i64* %out_count_ptr, align 8
  %out_ptr2 = getelementptr inbounds i64, i64* %out, i64 %countA
  store i64 %v, i64* %out_ptr2, align 8

  %stack_slot_ptr = getelementptr inbounds i64, i64* %stack, i64 %depth_phi
  store i64 %v, i64* %stack_slot_ptr, align 8
  %depth_after_push = add i64 %depth_phi, 1
  br label %after_continue

inner_done:
  %depth_after_pop = add i64 %depth_phi, -1
  br label %after_continue

after_continue:
  %depth_next = phi i64 [ %depth_after_push, %found_neighbor ], [ %depth_after_pop, %inner_done ]
  br label %outer_cond

done:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}