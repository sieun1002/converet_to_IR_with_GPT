; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS over an n×n int adjacency matrix; writes preorder to out and count to *out_count (confidence=0.95). Evidence: index u*n+v with 4-byte loads, visited flags, explicit stack with neighbor cursor.
; Preconditions: adj points to at least n*n i32; out points to space for up to n i64; out_count valid; 0 <= start < n.
; Postconditions: 0 <= *out_count <= n; out[0..*out_count-1] contain the DFS visitation order from start.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  ; Early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_ret, label %allocs

early_ret:                                          ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

allocs:                                             ; preds = %entry
  ; allocate visited: n * 4 bytes
  %size_vis_bytes = shl i64 %n, 2
  %visited_i8 = call noalias i8* @malloc(i64 %size_vis_bytes)
  ; allocate next index per node: n * 8 bytes
  %size_next_bytes = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %size_next_bytes)
  ; allocate stack: n * 8 bytes
  %stack_i8 = call noalias i8* @malloc(i64 %size_next_bytes)
  ; bitcast to typed pointers
  %visited = bitcast i8* %visited_i8 to i32*
  %nextidx = bitcast i8* %next_i8 to i64*
  %stack = bitcast i8* %stack_i8 to i64*
  ; check OOM
  %vis_is_null = icmp eq i8* %visited_i8, null
  %next_is_null = icmp eq i8* %next_i8, null
  %stack_is_null = icmp eq i8* %stack_i8, null
  %any_null_tmp = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %any_null_tmp, %stack_is_null
  br i1 %any_null, label %oom, label %init_loop

oom:                                                ; preds = %allocs
  ; free in the observed order: visited, nextidx, stack
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:                                          ; preds = %allocs
  br label %init_loop.cond

init_loop.cond:                                     ; preds = %init_loop.body, %init_loop
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.body ]
  %init_done = icmp uge i64 %i, %n
  br i1 %init_done, label %after_init, label %init_loop.body

init_loop.body:                                     ; preds = %init_loop.cond
  ; visited[i] = 0
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  ; nextidx[i] = 0
  %next_ptr = getelementptr inbounds i64, i64* %nextidx, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop.cond

after_init:                                         ; preds = %init_loop.cond
  ; *out_count = 0
  store i64 0, i64* %out_count, align 8
  ; push start onto stack
  ; stack[0] = start
  %stack0_ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0_ptr, align 8
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; append start to out
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  %out_pos0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_pos0, align 8
  ; initial stack size = 1
  br label %outer.cond

outer.cond:                                         ; preds = %inner.pop, %inner.found, %after_init
  %stack_sz = phi i64 [ 1, %after_init ], [ %stack_sz_dec, %inner.pop ], [ %stack_sz_inc, %inner.found ]
  %stack_empty = icmp eq i64 %stack_sz, 0
  br i1 %stack_empty, label %cleanup, label %top_load

top_load:                                           ; preds = %outer.cond
  ; u = stack[stack_sz - 1]
  %top_idx = add i64 %stack_sz, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %u = load i64, i64* %top_ptr, align 8
  ; v = nextidx[u]
  %v_ptr0 = getelementptr inbounds i64, i64* %nextidx, i64 %u
  %v0 = load i64, i64* %v_ptr0, align 8
  br label %inner.cond

inner.cond:                                         ; preds = %v.inc, %top_load
  %v = phi i64 [ %v0, %top_load ], [ %v.next, %v.inc ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %inner.pop

inner.body:                                         ; preds = %inner.cond
  ; if adj[u*n + v] == 0 -> increment v
  %u_mul_n = mul i64 %u, %n
  %idx_uv = add i64 %u_mul_n, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_uv
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_edge = icmp ne i32 %adj_val, 0
  br i1 %is_edge, label %check_visited, label %v.inc

check_visited:                                      ; preds = %inner.body
  ; if visited[v] != 0 -> increment v
  %vis_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %vis_v = load i32, i32* %vis_v_ptr, align 4
  %not_visited = icmp eq i32 %vis_v, 0
  br i1 %not_visited, label %take_edge, label %v.inc

take_edge:                                          ; preds = %check_visited
  ; nextidx[u] = v + 1
  %v_plus1 = add i64 %v, 1
  store i64 %v_plus1, i64* %v_ptr0, align 8
  ; visited[v] = 1
  store i32 1, i32* %vis_v_ptr, align 4
  ; append v to out
  %cnt_old = load i64, i64* %out_count, align 8
  %cnt_new = add i64 %cnt_old, 1
  store i64 %cnt_new, i64* %out_count, align 8
  %out_pos = getelementptr inbounds i64, i64* %out, i64 %cnt_old
  store i64 %v, i64* %out_pos, align 8
  ; push v onto stack
  %push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_sz
  store i64 %v, i64* %push_ptr, align 8
  %stack_sz_inc = add i64 %stack_sz, 1
  br label %inner.found

v.inc:                                              ; preds = %check_visited, %inner.body
  %v.next = add i64 %v, 1
  br label %inner.cond

inner.pop:                                          ; preds = %inner.cond
  ; v == n -> pop stack
  %stack_sz_dec = add i64 %stack_sz, -1
  br label %outer.cond

inner.found:                                        ; preds = %take_edge
  ; continue outer loop without popping
  br label %outer.cond

cleanup:                                            ; preds = %outer.cond
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}