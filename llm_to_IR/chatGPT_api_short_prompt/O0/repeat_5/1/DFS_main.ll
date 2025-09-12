; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS (preorder) over an n×n i32 adjacency matrix; writes visit order to out and count to out_count. (confidence=0.86). Evidence: explicit stack/visited arrays, next-neighbor index per node, pushes neighbors and records order.
; Preconditions: matrix is row-major n*n of 32-bit ints; out has capacity >= n.
; Postconditions: *out_count set to number of visited nodes from start; out[0..*out_count-1] contains visit order.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early_bad = or i1 %n_is_zero, %start_ge_n
  br i1 %early_bad, label %early, label %alloc

early:
  store i64 0, i64* %out_count, align 8
  ret void

alloc:
  %size_vis = shl i64 %n, 2
  %vis_i8 = call noalias i8* @malloc(i64 %size_vis)
  %vis = bitcast i8* %vis_i8 to i32*
  %size_64 = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %size_64)
  %next = bitcast i8* %next_i8 to i64*
  %stack_i8 = call noalias i8* @malloc(i64 %size_64)
  %stack = bitcast i8* %stack_i8 to i64*
  %vis_null = icmp eq i8* %vis_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %tmp_or = or i1 %vis_null, %next_null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null = or i1 %tmp_or, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init:
  ; Initialize visited[] = 0 and nextNeighbor[] = 0
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop.body_end ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop.body, label %after_init

init_loop.body:
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_loop.body_end

init_loop.body_end:
  %i.next = add nuw i64 %i, 1
  br label %init_loop

after_init:
  ; *out_count = 0
  store i64 0, i64* %out_count, align 8
  ; push start
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  ; mark visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; record start in out and increment count
  %count0 = load i64, i64* %out_count, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_slot0, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_count, align 8
  br label %outer_loop

outer_loop:
  %sp = phi i64 [ 1, %after_init ], [ %sp.next, %outer_latch ]
  %sp_nonzero = icmp ne i64 %sp, 0
  br i1 %sp_nonzero, label %process_top, label %cleanup

process_top:
  %top_index = add i64 %sp, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %u = load i64, i64* %top_ptr, align 8
  %next_u_ptr2 = getelementptr inbounds i64, i64* %next, i64 %u
  %j0 = load i64, i64* %next_u_ptr2, align 8
  br label %inner_loop

inner_loop:
  %j = phi i64 [ %j0, %process_top ], [ %j.next, %inner_body_latch ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %check_edge, label %after_inner

check_edge:
  %u_times_n = mul i64 %u, %n
  %idx = add i64 %u_times_n, %j
  %adj_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %adj = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj, 0
  br i1 %is_zero, label %inner_body_latch, label %check_unvisited

check_unvisited:
  %vis_j_ptr = getelementptr inbounds i32, i32* %vis, i64 %j
  %vis_j = load i32, i32* %vis_j_ptr, align 4
  %vis_j_zero = icmp eq i32 %vis_j, 0
  br i1 %vis_j_zero, label %found_neighbor, label %inner_body_latch

found_neighbor:
  %j_plus1 = add i64 %j, 1
  store i64 %j_plus1, i64* %next_u_ptr2, align 8
  store i32 1, i32* %vis_j_ptr, align 4
  %cnt_prev = load i64, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt_prev
  store i64 %j, i64* %out_slot, align 8
  %cnt_inc = add i64 %cnt_prev, 1
  store i64 %cnt_inc, i64* %out_count, align 8
  %stack_cur_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp
  store i64 %j, i64* %stack_cur_ptr, align 8
  %sp_inc = add i64 %sp, 1
  br label %outer_latch

inner_body_latch:
  %j.next = add i64 %j, 1
  br label %inner_loop

after_inner:
  ; no neighbor found: pop
  %sp_dec = add i64 %sp, -1
  br label %outer_latch

outer_latch:
  %sp.next = phi i64 [ %sp_dec, %after_inner ], [ %sp_inc, %found_neighbor ]
  br label %outer_loop

cleanup:
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}