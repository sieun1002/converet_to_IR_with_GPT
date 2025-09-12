; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS on an NxN i32 adjacency matrix from a start node, writing discovery order and count (confidence=0.95). Evidence: adjacency index u*N+j over i32 matrix; explicit visited[], next-neighbor[], and LIFO stack.
; Preconditions: adj points to at least n*n 32-bit ints; out has capacity >= n; 0 <= start < n (else *out_count set to 0 and return).
; Postconditions: *out_count = number of discovered nodes; out[0..*out_count-1] holds nodes in discovery order (start first).

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ok = icmp ult i64 %start, %n
  %bad = or i1 %n_is_zero, (xor i1 %start_ok, true)
  br i1 %bad, label %early, label %allocs

early:
  store i64 0, i64* %out_count, align 8
  ret void

allocs:
  %size_vis = mul i64 %n, 4
  %p_vis_i8 = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %p_vis_i8 to i32*
  %size8 = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size8)
  %next_idx = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %null1 = icmp eq i8* %p_vis_i8, null
  %null2 = icmp eq i8* %p_next_i8, null
  %null3 = icmp eq i8* %p_stack_i8, null
  %any12 = or i1 %null1, %null2
  %any = or i1 %any12, %null3
  br i1 %any, label %malloc_fail, label %init_loop

malloc_fail:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:
  %i = phi i64 [ 0, %allocs ], [ %i_next, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %post_init

init_body:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %next_idx, i64 %i
  store i64 0, i64* %nptr, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %out_count, align 8
  %st0_ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %st0_ptr, align 8
  %vptr_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vptr_start, align 4
  %oc0 = load i64, i64* %out_count, align 8
  %o_ptr0 = getelementptr inbounds i64, i64* %out, i64 %oc0
  store i64 %start, i64* %o_ptr0, align 8
  %oc1 = add i64 %oc0, 1
  store i64 %oc1, i64* %out_count, align 8
  br label %main_loop

main_loop:
  %sp = phi i64 [ 1, %post_init ], [ %sp_next, %after_inner ]
  %has_items = icmp ne i64 %sp, 0
  br i1 %has_items, label %process_top, label %cleanup

process_top:
  %sp_dec = add i64 %sp, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_dec
  %u = load i64, i64* %top_ptr, align 8
  %nptr_u = getelementptr inbounds i64, i64* %next_idx, i64 %u
  %j0 = load i64, i64* %nptr_u, align 8
  br label %inner_loop

inner_loop:
  %j = phi i64 [ %j0, %process_top ], [ %j_inc, %j_inc_block ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %edge_check, label %inner_exit

edge_check:
  %mul = mul i64 %u, %n
  %sum = add i64 %mul, %j
  %aptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %aval = load i32, i32* %aptr, align 4
  %nonzero = icmp ne i32 %aval, 0
  br i1 %nonzero, label %visit_check, label %j_inc_block

visit_check:
  %vptr_j = getelementptr inbounds i32, i32* %visited, i64 %j
  %v_j = load i32, i32* %vptr_j, align 4
  %is_unvisited = icmp eq i32 %v_j, 0
  br i1 %is_unvisited, label %discover, label %j_inc_block

j_inc_block:
  %j_inc = add i64 %j, 1
  br label %inner_loop

discover:
  %j_plus1 = add i64 %j, 1
  store i64 %j_plus1, i64* %nptr_u, align 8
  store i32 1, i32* %vptr_j, align 4
  %oc = load i64, i64* %out_count, align 8
  %out_ptr = getelementptr inbounds i64, i64* %out, i64 %oc
  store i64 %j, i64* %out_ptr, align 8
  %oc_next = add i64 %oc, 1
  store i64 %oc_next, i64* %out_count, align 8
  %st_ptr_sp = getelementptr inbounds i64, i64* %stack, i64 %sp
  store i64 %j, i64* %st_ptr_sp, align 8
  %sp_inc = add i64 %sp, 1
  br label %after_inner

inner_exit:
  %j_exit = phi i64 [ %j, %inner_loop ]
  br label %after_inner

after_inner:
  %j_after = phi i64 [ %j, %discover ], [ %j_exit, %inner_exit ]
  %sp_candidate = phi i64 [ %sp_inc, %discover ], [ %sp, %inner_exit ]
  %is_end = icmp eq i64 %j_after, %n
  %sp_pop = add i64 %sp, -1
  %sp_next = select i1 %is_end, i64 %sp_pop, i64 %sp_candidate
  br label %main_loop

cleanup:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  ret void
}