; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative depth-first search from a start node over an n×n int32 adjacency matrix; writes visitation order to out and count to out_count (confidence=0.95). Evidence: accesses adj[u*n+v], uses visited/stack arrays and backtracking.
; Preconditions: adj points to at least n*n i32 elements; out points to space for at least n i64 elements; indices are treated as unsigned.
; Postconditions: *out_count is the number of nodes visited (reachable from start); out[0..*out_count-1] holds the visit order starting with start.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %ret_zero, label %check_start

check_start:                                        ; preds = %entry
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %ret_zero

ret_zero:                                           ; preds = %check_start, %entry, %free_stack, %chk_stack_free
  store i64 0, i64* %out_count, align 8
  ret void

alloc:                                              ; preds = %check_start
  %size_vis = mul i64 %n, 4
  %raw_vis = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %raw_vis to i32*
  %size_q = shl i64 %n, 3
  %raw_next = call noalias i8* @malloc(i64 %size_q)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call noalias i8* @malloc(i64 %size_q)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %t0 = or i1 %vis_null, %next_null
  %any_null = or i1 %t0, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:                                         ; preds = %alloc
  br i1 %vis_null, label %chk_next_free, label %free_vis

free_vis:                                           ; preds = %alloc_fail
  %vis_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8)
  br label %chk_next_free

chk_next_free:                                      ; preds = %free_vis, %alloc_fail
  br i1 %next_null, label %chk_stack_free, label %free_next

free_next:                                          ; preds = %chk_next_free
  %next_i8 = bitcast i64* %next to i8*
  call void @free(i8* %next_i8)
  br label %chk_stack_free

chk_stack_free:                                     ; preds = %free_next, %chk_next_free
  br i1 %stack_null, label %ret_zero, label %free_stack

free_stack:                                         ; preds = %chk_stack_free
  %stack_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8)
  br label %ret_zero

init:                                               ; preds = %alloc
  br label %init_loop

init_loop:                                          ; preds = %init_latch, %init
  %i = phi i64 [ 0, %init ], [ %i_next, %init_latch ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %init_body, label %post_init

init_body:                                          ; preds = %init_loop
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_latch

init_latch:                                         ; preds = %init_body
  %i_next = add i64 %i, 1
  br label %init_loop

post_init:                                          ; preds = %init_loop
  store i64 0, i64* %out_count, align 8
  ; push start at stack[0]
  %stack_idx0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_idx0, align 8
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; out[*cnt] = start; (*cnt)++
  %cnt0 = load i64, i64* %out_count, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_ptr0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  br label %outer_loop

outer_loop:                                         ; preds = %after_inner, %post_init
  %depth = phi i64 [ 1, %post_init ], [ %depth_next, %after_inner ]
  %depth_nonzero = icmp ne i64 %depth, 0
  br i1 %depth_nonzero, label %process_top, label %cleanup

process_top:                                        ; preds = %outer_loop
  %top_index_dec = add i64 %depth, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index_dec
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %iidx0 = load i64, i64* %next_u_ptr, align 8
  br label %inner_loop

inner_loop:                                         ; preds = %advance, %process_top
  %iidx = phi i64 [ %iidx0, %process_top ], [ %iidx_inc, %advance ]
  %i_lt_n = icmp ult i64 %iidx, %n
  br i1 %i_lt_n, label %check_edge, label %inner_done

check_edge:                                         ; preds = %inner_loop
  %un = mul i64 %u, %n
  %adj_index = add i64 %un, %iidx
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %adj_index
  %adj_val = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %adj_val, 0
  br i1 %has_edge, label %check_visited, label %advance

check_visited:                                      ; preds = %check_edge
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %iidx
  %vis_i_val = load i32, i32* %vis_i_ptr, align 4
  %not_visited = icmp eq i32 %vis_i_val, 0
  br i1 %not_visited, label %visit_neighbor, label %advance

visit_neighbor:                                     ; preds = %check_visited
  %i_plus1 = add i64 %iidx, 1
  store i64 %i_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %cnt_old2 = load i64, i64* %out_count, align 8
  %out_elem2 = getelementptr inbounds i64, i64* %out, i64 %cnt_old2
  store i64 %iidx, i64* %out_elem2, align 8
  %cnt_new2 = add i64 %cnt_old2, 1
  store i64 %cnt_new2, i64* %out_count, align 8
  %stack_p_ptr = getelementptr inbounds i64, i64* %stack, i64 %depth
  store i64 %iidx, i64* %stack_p_ptr, align 8
  %depth_incr = add i64 %depth, 1
  br label %after_inner

advance:                                            ; preds = %check_visited, %check_edge
  %iidx_inc = add i64 %iidx, 1
  br label %inner_loop

inner_done:                                         ; preds = %inner_loop
  %depth_dec = add i64 %depth, -1
  br label %after_inner

after_inner:                                        ; preds = %inner_done, %visit_neighbor
  %depth_next = phi i64 [ %depth_incr, %visit_neighbor ], [ %depth_dec, %inner_done ]
  br label %outer_loop

cleanup:                                            ; preds = %outer_loop
  %vis_i8_2 = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8_2)
  %next_i8_2 = bitcast i64* %next to i8*
  call void @free(i8* %next_i8_2)
  %stack_i8_2 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8_2)
  ret void
}