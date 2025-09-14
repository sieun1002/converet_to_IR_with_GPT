; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS over adjacency matrix; writes visitation order and count (confidence=0.86). Evidence: visited array, explicit stack with push/pop, adjacency matrix checks and next-neighbor index.
; Preconditions: adj has at least n*n entries (i32), out has capacity >= n, count is a valid i64*. If n==0 or start>=n, sets *count=0 and returns.
; Postconditions: *count = number of visited vertices; out[0..*count-1] lists visitation order starting at start.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %count) local_unnamed_addr {
entry:
  ; Early parameter checks: if n == 0 or start >= n => *count = 0; return.
  %n_is_zero = icmp eq i64 %n, 0
  %start_in_range = icmp ult i64 %start, %n
  %proceed = and i1 (not %n_is_zero), %start_in_range
  br i1 %proceed, label %allocs, label %early_zero

early_zero:                                       ; preds = %entry
  store i64 0, i64* %count, align 8
  ret void

allocs:                                           ; preds = %entry
  ; visited: i32[n]
  %size_vis = mul i64 %n, 4
  %vis_raw = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_raw to i32*
  ; nextIdx: i64[n]
  %size_i64 = mul i64 %n, 8
  %next_raw = call i8* @malloc(i64 %size_i64)
  %nextIdx = bitcast i8* %next_raw to i64*
  ; stack: i64[n]
  %stack_raw = call i8* @malloc(i64 %size_i64)
  %stack = bitcast i8* %stack_raw to i64*
  ; Check allocation failure
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null.tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_zero

alloc_fail:                                       ; preds = %allocs
  ; Free any (possibly NULL) and return with *count = 0
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %count, align 8
  ret void

init_zero:                                        ; preds = %allocs
  ; Initialize visited[i]=0 and nextIdx[i]=0 for i in [0..n)
  br label %init_loop

init_loop:                                        ; preds = %init_body, %init_zero
  %i = phi i64 [ 0, %init_zero ], [ %i.next, %init_body ]
  %i.lt.n = icmp ult i64 %i, %n
  br i1 %i.lt.n, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %vis_ptr_i = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr_i, align 4
  %next_ptr_i = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %next_ptr_i, align 8
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  ; Initialize count = 0, push start, mark visited[start]=1, append start to out
  store i64 0, i64* %count, align 8
  ; push start at stack[0], stack_size = 1
  %stack_pos0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_pos0, align 8
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; out[0] = start; count = 1
  %cnt0 = load i64, i64* %count, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_ptr0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %count, align 8
  br label %outer_check

outer_check:                                      ; preds = %outer_continue, %after_init
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size.next, %outer_continue ]
  %nonempty = icmp ne i64 %stack_size, 0
  br i1 %nonempty, label %outer_body, label %normal_cleanup

outer_body:                                       ; preds = %outer_check
  ; top = stack[stack_size-1]
  %top_idx = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %top = load i64, i64* %top_ptr, align 8
  ; ni = nextIdx[top]
  %ni_ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %top
  %ni0 = load i64, i64* %ni_ptr, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %inner_continue, %outer_body
  %ni = phi i64 [ %ni0, %outer_body ], [ %ni.next, %inner_continue ]
  %ni.lt.n = icmp ult i64 %ni, %n
  br i1 %ni.lt.n, label %check_edge, label %after_inner

check_edge:                                       ; preds = %inner_loop
  ; if adj[top*n + ni] != 0 and visited[ni] == 0
  %rowmul = mul i64 %top, %n
  %adj_idx = add i64 %rowmul, %ni
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %adj_idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %adj_val, 0
  br i1 %edge_zero, label %inner_continue, label %check_visited

check_visited:                                    ; preds = %check_edge
  %vis_ni_ptr = getelementptr inbounds i32, i32* %visited, i64 %ni
  %vis_ni = load i32, i32* %vis_ni_ptr, align 4
  %already = icmp ne i32 %vis_ni, 0
  br i1 %already, label %inner_continue, label %take_edge

inner_continue:                                   ; preds = %check_visited, %check_edge
  %ni.next = add i64 %ni, 1
  br label %inner_loop

take_edge:                                        ; preds = %check_visited
  ; nextIdx[top] = ni + 1
  %ni.plus = add i64 %ni, 1
  store i64 %ni.plus, i64* %ni_ptr, align 8
  ; visited[ni] = 1
  store i32 1, i32* %vis_ni_ptr, align 4
  ; append ni to out and increment count
  %cnt_old = load i64, i64* %count, align 8
  %out_pos = getelementptr inbounds i64, i64* %out, i64 %cnt_old
  store i64 %ni, i64* %out_pos, align 8
  %cnt_new = add i64 %cnt_old, 1
  store i64 %cnt_new, i64* %count, align 8
  ; push ni onto stack: stack[stack_size] = ni; stack_size++
  %push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %ni, i64* %push_ptr, align 8
  %stack_size.inc = add i64 %stack_size, 1
  br label %outer_continue

after_inner:                                      ; preds = %inner_loop
  ; if ni == n then pop: stack_size--
  %ni.eq.n = icmp eq i64 %ni, %n
  %stack_size.dec = add i64 %stack_size, -1
  %stack_size.sel = select i1 %ni.eq.n, i64 %stack_size.dec, i64 %stack_size
  br label %outer_continue

outer_continue:                                   ; preds = %after_inner, %take_edge
  %stack_size.next = phi i64 [ %stack_size.sel, %after_inner ], [ %stack_size.inc, %take_edge ]
  br label %outer_check

normal_cleanup:                                   ; preds = %outer_check
  ; Free allocations
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}