; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Depth-first search traversal over an adjacency matrix, emitting preorder and count (confidence=0.95). Evidence: uses explicit stack and visited arrays; indexes matrix as cur*n + j and appends discovered nodes to output.
; Preconditions: matrix points to an n*n i32 adjacency matrix (nonzero means edge). out_nodes has capacity >= n. 0 <= start < n.
; Postconditions: out_nodes[0..*out_count-1] contains the DFS preorder starting from start; *out_count is the number of visited nodes.

declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out_nodes, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:                                         ; preds = %entry
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %alloc, label %ret_zero

ret_zero:                                            ; preds = %check_start, %entry
  store i64 0, i64* %out_count, align 8
  ret void

alloc:                                               ; preds = %check_start
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %p_vis_i8 to i32*
  %size64 = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size64)
  %nextIdx = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %vis_is_null = icmp eq i32* %visited, null
  %next_is_null = icmp eq i64* %nextIdx, null
  %tmp_or = or i1 %vis_is_null, %next_is_null
  %stack_is_null = icmp eq i64* %stack, null
  %any_null = or i1 %tmp_or, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init_zero

alloc_fail:                                          ; preds = %alloc
  %vis_i8_fail = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8_fail)
  %next_i8_fail = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_i8_fail)
  %stack_i8_fail = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8_fail)
  store i64 0, i64* %out_count, align 8
  ret void

init_zero:                                           ; preds = %alloc
  br label %zero_loop

zero_loop:                                           ; preds = %zero_body, %init_zero
  %i = phi i64 [ 0, %init_zero ], [ %i.next, %zero_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %zero_body, label %after_zero

zero_body:                                           ; preds = %zero_loop
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %nptr, align 8
  %i.next = add i64 %i, 1
  br label %zero_loop

after_zero:                                          ; preds = %zero_loop
  store i64 0, i64* %out_count, align 8
  ; push start onto stack
  ; stack_size becomes 1, element at index 0 is start
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  ; visited[start] = 1
  %vstart = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vstart, align 4
  ; append start to out_nodes
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out_nodes, i64 %cnt0
  store i64 %start, i64* %out_slot0, align 8
  br label %loop_cond

loop_cond:                                           ; preds = %found_branch, %inner_done, %after_zero
  %stack_size = phi i64 [ 1, %after_zero ], [ %stack_size_inc, %found_branch ], [ %stack_size_dec, %inner_done ]
  %has_items = icmp ne i64 %stack_size, 0
  br i1 %has_items, label %loop_body, label %finish

loop_body:                                           ; preds = %loop_cond
  %top_index = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %cur = load i64, i64* %top_ptr, align 8
  %nidx_ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %cur
  %j0 = load i64, i64* %nidx_ptr, align 8
  br label %neighbors_loop

neighbors_loop:                                      ; preds = %incr_j, %loop_body
  %j = phi i64 [ %j0, %loop_body ], [ %j.next, %incr_j ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %check_edge, label %inner_done

check_edge:                                          ; preds = %neighbors_loop
  %mul = mul i64 %cur, %n
  %idx = add i64 %mul, %j
  %m_elem = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %edge_val = load i32, i32* %m_elem, align 4
  %edge_is_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_is_zero, label %incr_j, label %check_visited

check_visited:                                       ; preds = %check_edge
  %vj_ptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vj = load i32, i32* %vj_ptr, align 4
  %vj_nz = icmp ne i32 %vj, 0
  br i1 %vj_nz, label %incr_j, label %discover

discover:                                            ; preds = %check_visited
  ; nextIdx[cur] = j + 1
  %j_plus = add i64 %j, 1
  store i64 %j_plus, i64* %nidx_ptr, align 8
  ; visited[j] = 1
  store i32 1, i32* %vj_ptr, align 4
  ; append j to out_nodes and increment count
  %cnt = load i64, i64* %out_count, align 8
  %cnt_inc = add i64 %cnt, 1
  store i64 %cnt_inc, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out_nodes, i64 %cnt
  store i64 %j, i64* %out_slot, align 8
  ; push j onto stack
  %push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %j, i64* %push_ptr, align 8
  %stack_size_inc = add i64 %stack_size, 1
  br label %found_branch

incr_j:                                              ; preds = %check_visited, %check_edge
  %j.next = add i64 %j, 1
  br label %neighbors_loop

inner_done:                                          ; preds = %neighbors_loop
  %stack_size_dec = add i64 %stack_size, -1
  br label %loop_cond

found_branch:                                        ; preds = %discover
  br label %loop_cond

finish:                                              ; preds = %loop_cond
  %vis_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8)
  %next_i8 = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_i8)
  %stack_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8)
  ret void
}