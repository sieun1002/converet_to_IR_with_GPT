; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: iterative DFS traversal from start node, writing visit order (confidence=0.88). Evidence: visited array, explicit stack (var_10), per-node next-neighbor index (var_18), adjacency checks with n*n indexing.
; Preconditions: adj points to an n*n int32 adjacency matrix in row-major; 0 <= start < n; out has capacity at least n; out_count is a valid pointer.
; Postconditions: out[0..*out_count-1] contains visit order; *out_count is number of visited nodes.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  ; Early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %alloc, label %early_ret

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

alloc:
  ; allocate visited: n * 4 bytes
  %size_vis = shl i64 %n, 2
  %vis_raw = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_raw to i32*
  ; allocate nextIdx: n * 8 bytes
  %size_q = shl i64 %n, 3
  %next_raw = call i8* @malloc(i64 %size_q)
  %nextIdx = bitcast i8* %next_raw to i64*
  ; allocate stack: n * 8 bytes
  %stack_raw = call i8* @malloc(i64 %size_q)
  %stack = bitcast i8* %stack_raw to i64*
  ; check allocation failure
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  ; free any (possibly null) allocations and return count=0
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:
  ; i = 0
  br label %init_loop.head

init_loop.head:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.body ]
  %cont = icmp ult i64 %i, %n
  br i1 %cont, label %init_loop.body, label %after_init

init_loop.body:
  ; visited[i] = 0
  %vis.gep = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.gep, align 4
  ; nextIdx[i] = 0
  %next.gep = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %next.gep, align 8
  ; i++
  %i.next = add i64 %i, 1
  br label %init_loop.head

after_init:
  ; *out_count = 0
  store i64 0, i64* %out_count, align 8
  ; push start onto stack: stack[0] = start; stack_size = 1
  %stack.0.ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.0.ptr, align 8
  ; visited[start] = 1
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  ; out[*out_count] = start; (*out_count)++
  %cnt0 = load i64, i64* %out_count, align 8
  %out.gep0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out.gep0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  ; enter main loop with stack_size = 1
  br label %main.loop

main.loop:
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size.next, %main.cont ], [ %stack_size.after, %after_neighbors ]
  %has_items = icmp ne i64 %stack_size, 0
  br i1 %has_items, label %process_top, label %cleanup

process_top:
  ; top = stack[stack_size - 1]
  %top.idx = add i64 %stack_size, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %top.idx
  %top = load i64, i64* %top.ptr, align 8
  ; idx = nextIdx[top]
  %next.ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %top
  %idx.init = load i64, i64* %next.ptr, align 8
  br label %neighbors.loop

neighbors.loop:
  %idx = phi i64 [ %idx.init, %process_top ], [ %idx.inc, %inc_idx ]
  %cond = icmp ult i64 %idx, %n
  br i1 %cond, label %check_edge, label %after_neighbors

check_edge:
  ; pos = top * n + idx
  %top.mul.n = mul i64 %top, %n
  %pos = add i64 %top.mul.n, %idx
  ; val = adj[pos]
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %pos
  %val32 = load i32, i32* %adj.ptr, align 4
  %is_edge = icmp ne i32 %val32, 0
  br i1 %is_edge, label %check_visited, label %inc_idx

check_visited:
  ; if not visited[idx]
  %vis.idx.ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis.idx = load i32, i32* %vis.idx.ptr, align 4
  %is_unvisited = icmp eq i32 %vis.idx, 0
  br i1 %is_unvisited, label %take_neighbor, label %inc_idx

take_neighbor:
  ; nextIdx[top] = idx + 1
  %idx.plus1 = add i64 %idx, 1
  store i64 %idx.plus1, i64* %next.ptr, align 8
  ; visited[idx] = 1
  store i32 1, i32* %vis.idx.ptr, align 4
  ; out[*out_count] = idx; (*out_count)++
  %cntA = load i64, i64* %out_count, align 8
  %out.gepA = getelementptr inbounds i64, i64* %out, i64 %cntA
  store i64 %idx, i64* %out.gepA, align 8
  %cntA1 = add i64 %cntA, 1
  store i64 %cntA1, i64* %out_count, align 8
  ; push idx onto stack
  %stack.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %idx, i64* %stack.push.ptr, align 8
  %stack_size.next = add i64 %stack_size, 1
  br label %main.cont

inc_idx:
  %idx.inc = add i64 %idx, 1
  br label %neighbors.loop

after_neighbors:
  ; if idx == n then pop (stack_size--)
  %idx.eq.n = icmp eq i64 %idx, %n
  %stack_size.after = select i1 %idx.eq.n, i64 (add i64 %stack_size, -1), i64 %stack_size
  br label %main.loop

main.cont:
  br label %main.loop

cleanup:
  ; free allocations and return
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}