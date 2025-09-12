; LLVM 14 IR for: void dfs(int32_t* adj, uint64_t n, uint64_t start, uint64_t* order, uint64_t* out_count)

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %order, i64* %out_count) {
entry:
  ; Early checks: if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %allocs, label %ret_zero

ret_zero:
  store i64 0, i64* %out_count, align 8
  ret void

allocs:
  ; visited: i32[n]
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %p_vis_i8 to i32*
  ; next_idx: i64[n]
  %size_next = shl i64 %n, 3
  %p_next_i8 = call noalias i8* @malloc(i64 %size_next)
  %next = bitcast i8* %p_next_i8 to i64*
  ; stack: i64[n]
  %p_stack_i8 = call noalias i8* @malloc(i64 %size_next)
  %stack = bitcast i8* %p_stack_i8 to i64*

  ; if any allocation failed, free all and return with count = 0
  %vis_null = icmp eq i8* %p_vis_i8, null
  %next_null = icmp eq i8* %p_next_i8, null
  %stack_null = icmp eq i8* %p_stack_i8, null
  %anynull1 = or i1 %vis_null, %next_null
  %anynull = or i1 %anynull1, %stack_null
  br i1 %anynull, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

; Initialize visited[] = 0 and next[] = 0
init_loop:
  %i = phi i64 [ 0, %allocs ], [ %i_next, %init_body ]
  %init_more = icmp ult i64 %i, %n
  br i1 %init_more, label %init_body, label %init_done

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

init_done:
  ; *out_count = 0
  store i64 0, i64* %out_count, align 8
  ; push start onto stack
  %stack0ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0ptr, align 8
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; ++*out_count; order[old] = start
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  %ord_ptr0 = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %start, i64* %ord_ptr0, align 8
  br label %outer_loop

; while (stack_size != 0)
outer_loop:
  %ss = phi i64 [ 1, %init_done ], [ %ss2, %outer_continue ], [ %ss_dec, %after_inner ]
  %ss_is_zero = icmp eq i64 %ss, 0
  br i1 %ss_is_zero, label %finish, label %outer_body

outer_body:
  ; current = stack[ss-1]
  %ss_minus1 = add i64 %ss, -1
  %curr_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss_minus1
  %curr = load i64, i64* %curr_ptr, align 8
  ; idx = next[curr]
  %next_curr_ptr = getelementptr inbounds i64, i64* %next, i64 %curr
  %idx0 = load i64, i64* %next_curr_ptr, align 8
  br label %inner_loop

; for (idx = next[curr]; idx < n; ++idx)
inner_loop:
  %idx = phi i64 [ %idx0, %outer_body ], [ %idx_inc, %inner_continue ]
  %idx_lt_n = icmp ult i64 %idx, %n
  br i1 %idx_lt_n, label %inner_check, label %after_inner

inner_check:
  ; if (adj[curr*n + idx] != 0 && visited[idx] == 0)
  %mul = mul i64 %curr, %n
  %lin = add i64 %mul, %idx
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %lin
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %inner_continue, label %check_not_visited

check_not_visited:
  %vis_idx_ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis_val = load i32, i32* %vis_idx_ptr, align 4
  %is_visited = icmp ne i32 %vis_val, 0
  br i1 %is_visited, label %inner_continue, label %take_edge

inner_continue:
  %idx_inc = add i64 %idx, 1
  br label %inner_loop

take_edge:
  ; next[curr] = idx + 1
  %idx_plus1 = add i64 %idx, 1
  store i64 %idx_plus1, i64* %next_curr_ptr, align 8
  ; visited[idx] = 1
  store i32 1, i32* %vis_idx_ptr, align 4
  ; ++*out_count; order[old] = idx
  %cnt_old2 = load i64, i64* %out_count, align 8
  %cnt_new2 = add i64 %cnt_old2, 1
  store i64 %cnt_new2, i64* %out_count, align 8
  %ord_ptr2 = getelementptr inbounds i64, i64* %order, i64 %cnt_old2
  store i64 %idx, i64* %ord_ptr2, align 8
  ; push idx onto stack
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %idx, i64* %stack_push_ptr, align 8
  %ss2 = add i64 %ss, 1
  br label %outer_continue

after_inner:
  ; no neighbor found: pop
  %ss_dec = add i64 %ss, -1
  br label %outer_continue

outer_continue:
  br label %outer_loop

finish:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  ret void
}