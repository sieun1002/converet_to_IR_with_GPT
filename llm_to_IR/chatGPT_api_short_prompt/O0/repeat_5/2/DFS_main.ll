; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS over an n×n int adjacency matrix (row-major), writing pre-order visitation to out and incrementing outCount (confidence=0.98). Evidence: uses explicit stack, visited bitmap, next-neighbor index per node; accesses matrix[u*n+v].
; Preconditions: n > 0 and start < n; matrix has at least n*n i32s; out can hold up to n i64s; outCount is a valid i64*.
; Postconditions: out[0..outCount-1] are nodes visited in DFS pre-order from start; outCount is number of visited nodes.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %outCount) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_oob = icmp uge i64 %start, %n
  %invalid = or i1 %n_is_zero, %start_oob
  br i1 %invalid, label %ret_zero, label %alloc

ret_zero:                                          ; preds = %entry
  store i64 0, i64* %outCount, align 8
  ret void

alloc:                                             ; preds = %entry
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %p_vis_i8 to i32*
  %size8 = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size8)
  %next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %vis_null = icmp eq i8* %p_vis_i8, null
  %next_null = icmp eq i8* %p_next_i8, null
  %stack_null = icmp eq i8* %p_stack_i8, null
  %any_null = or i1 %vis_null, %next_null
  %any_null2 = or i1 %any_null, %stack_null
  br i1 %any_null2, label %alloc_fail, label %init_loop

alloc_fail:                                        ; preds = %alloc
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %outCount, align 8
  ret void

init_loop:                                         ; preds = %alloc
  br label %init_cmp

init_cmp:                                          ; preds = %init_body, %init_loop
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_body ]
  %more = icmp ult i64 %i, %n
  br i1 %more, label %init_body, label %after_init

init_body:                                         ; preds = %init_cmp
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_cmp

after_init:                                        ; preds = %init_cmp
  store i64 0, i64* %outCount, align 8
  ; push start (stack[0] = start; sp = 1)
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  ; visited[start] = 1
  %vis_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start, align 4
  ; out[outCount++] = start
  %oldc = load i64, i64* %outCount, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %start, i64* %out_slot, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %outCount, align 8
  br label %main_loop_cond

main_loop_cond:                                    ; preds = %after_no_neighbor, %after_found, %after_init
  %sp = phi i64 [ 1, %after_init ], [ %sp2, %after_found ], [ %sp.dec, %after_no_neighbor ]
  %sp_nonzero = icmp ne i64 %sp, 0
  br i1 %sp_nonzero, label %top_block, label %finalize

top_block:                                         ; preds = %main_loop_cond
  %sp.m1 = add i64 %sp, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp.m1
  %u = load i64, i64* %top_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %v0 = load i64, i64* %next_u_ptr, align 8
  br label %neighbor_head

neighbor_head:                                     ; preds = %neighbor_skip, %top_block
  %v = phi i64 [ %v0, %top_block ], [ %v.inc, %neighbor_skip ]
  ; u is loop-invariant across neighbor scan; use %u from top_block (dominates %neighbor_skip)
  %has_more_neighbors = icmp ult i64 %v, %n
  br i1 %has_more_neighbors, label %neighbor_check, label %no_neighbor

neighbor_check:                                    ; preds = %neighbor_head
  ; if (matrix[u*n + v] && !visited[v]) -> found
  %u_mul_n = mul i64 %u, %n
  %idx_uv = add i64 %u_mul_n, %v
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx_uv
  %mat_val = load i32, i32* %mat_ptr, align 4
  %edge_exists = icmp ne i32 %mat_val, 0
  br i1 %edge_exists, label %check_visited, label %neighbor_skip

check_visited:                                     ; preds = %neighbor_check
  %vis_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %vis_v = load i32, i32* %vis_v_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_v, 0
  br i1 %is_unvisited, label %found, label %neighbor_skip

neighbor_skip:                                     ; preds = %check_visited, %neighbor_check
  %v.inc = add i64 %v, 1
  br label %neighbor_head

found:                                             ; preds = %check_visited
  ; next[u] = v + 1
  %v.plus1 = add i64 %v, 1
  store i64 %v.plus1, i64* %next_u_ptr, align 8
  ; visited[v] = 1
  store i32 1, i32* %vis_v_ptr, align 4
  ; out[outCount++] = v
  %oldc2 = load i64, i64* %outCount, align 8
  %out_slot2 = getelementptr inbounds i64, i64* %out, i64 %oldc2
  store i64 %v, i64* %out_slot2, align 8
  %newc2 = add i64 %oldc2, 1
  store i64 %newc2, i64* %outCount, align 8
  ; push v onto stack
  %stack_sp_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp
  store i64 %v, i64* %stack_sp_ptr, align 8
  %sp2 = add i64 %sp, 1
  br label %main_loop_cond

no_neighbor:                                       ; preds = %neighbor_head
  ; pop stack
  %sp.dec = add i64 %sp, -1
  br label %main_loop_cond

finalize:                                          ; preds = %main_loop_cond
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  ret void
}