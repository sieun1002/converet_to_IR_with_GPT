; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Depth-first traversal on an adjacency matrix, recording visit order (confidence=0.84). Evidence: stack-based walk, visited array, matrix access at curr*n+idx.
; Preconditions: adj is an n×n row-major int32 matrix; out has capacity ≥ n; out_len is a valid i64*.
; Postconditions: out[0..*out_len-1] contains nodes visited in DFS order from start; *out_len is the count.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) local_unnamed_addr {
entry:
  ; if (n == 0 || start >= n) { *out_len = 0; return; }
  %is_n_zero = icmp eq i64 %n, 0
  br i1 %is_n_zero, label %early_zero, label %check_start

early_zero:                                          ; preds = %entry, %check_start
  store i64 0, i64* %out_len, align 8
  ret void

check_start:                                         ; preds = %entry
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %early_zero

alloc:                                               ; preds = %check_start
  ; visited: n*4, nextidx: n*8, stack: n*8
  %size_vis = shl i64 %n, 2
  %vis_mem = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_mem to i32*
  %size_next = shl i64 %n, 3
  %next_mem = call noalias i8* @malloc(i64 %size_next)
  %nextidx = bitcast i8* %next_mem to i64*
  %size_stack = shl i64 %n, 3
  %stack_mem = call noalias i8* @malloc(i64 %size_stack)
  %stack = bitcast i8* %stack_mem to i64*
  %vis_null = icmp eq i8* %vis_mem, null
  %next_null = icmp eq i8* %next_mem, null
  %stack_null = icmp eq i8* %stack_mem, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_cond

alloc_fail:                                          ; preds = %alloc
  call void @free(i8* %vis_mem)
  call void @free(i8* %next_mem)
  call void @free(i8* %stack_mem)
  store i64 0, i64* %out_len, align 8
  ret void

init_cond:                                           ; preds = %alloc, %init_body
  %i = phi i64 [ 0, %alloc ], [ %i_next, %init_body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_body, label %post_init

init_body:                                           ; preds = %init_cond
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextidx, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_cond

post_init:                                           ; preds = %init_cond
  ; initialize out_len = 0
  store i64 0, i64* %out_len, align 8
  ; push start onto stack
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  ; top = 1
  ; mark visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; out[ (*out_len)++ ] = start
  %len0 = load i64, i64* %out_len, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out_slot0, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %outer_check

outer_check:                                         ; preds = %outer_continue, %post_init
  %top_phi = phi i64 [ 1, %post_init ], [ %top_after, %outer_continue ]
  %nonzero = icmp ne i64 %top_phi, 0
  br i1 %nonzero, label %outer_body, label %cleanup

outer_body:                                          ; preds = %outer_check
  ; curr = stack[top-1]
  %top_minus1 = add i64 %top_phi, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_minus1
  %curr = load i64, i64* %stack_top_ptr, align 8
  ; idx = nextidx[curr]
  %idx0_ptr = getelementptr inbounds i64, i64* %nextidx, i64 %curr
  %idx0 = load i64, i64* %idx0_ptr, align 8
  br label %inner_check

inner_check:                                         ; preds = %inc_idx, %outer_body
  %idx_phi = phi i64 [ %idx0, %outer_body ], [ %idx_inc, %inc_idx ]
  %cmp_idx = icmp ult i64 %idx_phi, %n
  br i1 %cmp_idx, label %inner_examine, label %after_inner

inner_examine:                                       ; preds = %inner_check
  ; if (adj[curr*n + idx] == 0) continue
  %rowMul = mul i64 %curr, %n
  %flat = add i64 %rowMul, %idx_phi
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %flat
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %inc_idx, label %check_visit

check_visit:                                         ; preds = %inner_examine
  ; if (visited[idx] != 0) continue
  %vis_ptr_idx = getelementptr inbounds i32, i32* %visited, i64 %idx_phi
  %vis_val2 = load i32, i32* %vis_ptr_idx, align 4
  %is_visited = icmp ne i32 %vis_val2, 0
  br i1 %is_visited, label %inc_idx, label %explore

inc_idx:                                             ; preds = %check_visit, %inner_examine
  %idx_inc = add i64 %idx_phi, 1
  br label %inner_check

explore:                                             ; preds = %check_visit
  ; nextidx[curr] = idx + 1
  %curr_next_ptr2 = getelementptr inbounds i64, i64* %nextidx, i64 %curr
  %idx_plus1b = add i64 %idx_phi, 1
  store i64 %idx_plus1b, i64* %curr_next_ptr2, align 8
  ; visited[idx] = 1
  store i32 1, i32* %vis_ptr_idx, align 4
  ; out[ (*out_len)++ ] = idx
  %lenA = load i64, i64* %out_len, align 8
  %out_elemA = getelementptr inbounds i64, i64* %out, i64 %lenA
  store i64 %idx_phi, i64* %out_elemA, align 8
  %lenA2 = add i64 %lenA, 1
  store i64 %lenA2, i64* %out_len, align 8
  ; push idx onto stack, top++
  %stack_slotP = getelementptr inbounds i64, i64* %stack, i64 %top_phi
  store i64 %idx_phi, i64* %stack_slotP, align 8
  %top_after_explore = add i64 %top_phi, 1
  br label %outer_continue

after_inner:                                         ; preds = %inner_check
  ; exhausted neighbors: pop stack (top--)
  %top_after_pop = add i64 %top_phi, -1
  br label %outer_continue

outer_continue:                                      ; preds = %after_inner, %explore
  %top_after = phi i64 [ %top_after_explore, %explore ], [ %top_after_pop, %after_inner ]
  br label %outer_check

cleanup:                                             ; preds = %outer_check
  call void @free(i8* %vis_mem)
  call void @free(i8* %next_mem)
  call void @free(i8* %stack_mem)
  ret void
}