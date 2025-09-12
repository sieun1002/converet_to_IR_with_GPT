; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS over an NxN int adjacency matrix from a start node, writing visit order to out and count to out_len (confidence=0.83). Evidence: uses current*n+neighbor indexing; visited/stack/next arrays; push/pop with visit recording.
; Preconditions: n > 0, start < n; adj has at least n*n ints; out can hold up to n 64-bit entries; out_len, out, adj non-null.
; Postconditions: *out_len = number of visited nodes in DFS order; out[0..*out_len-1] filled with visited node indices.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %out_len) local_unnamed_addr {
entry:
  ; early parameter validation: if (n == 0 || start >= n) { *out_len = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_oob = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_oob
  br i1 %bad, label %early_ret, label %allocs

early_ret:                                           ; preds = %entry
  store i64 0, i64* %out_len, align 8
  ret void

allocs:                                              ; preds = %entry
  ; allocate visited[n] as i32, next_idx[n] as i64, stack[n] as i64
  %sz_vis.bytes = shl i64 %n, 2
  %p_vis.raw = call noalias i8* @malloc(i64 %sz_vis.bytes)
  %visited = bitcast i8* %p_vis.raw to i32*
  %sz64 = shl i64 %n, 3
  %p_next.raw = call noalias i8* @malloc(i64 %sz64)
  %next_idx = bitcast i8* %p_next.raw to i64*
  %p_stack.raw = call noalias i8* @malloc(i64 %sz64)
  %stack = bitcast i8* %p_stack.raw to i64*
  ; check for allocation failures
  %vis_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %next_idx, null
  %stack_null = icmp eq i64* %stack, null
  %any_null.tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:                                          ; preds = %allocs
  %p_vis.raw.bc = bitcast i32* %visited to i8*
  call void @free(i8* %p_vis.raw.bc)
  %p_next.raw.bc = bitcast i64* %next_idx to i8*
  call void @free(i8* %p_next.raw.bc)
  %p_stack.raw.bc = bitcast i64* %stack to i8*
  call void @free(i8* %p_stack.raw.bc)
  store i64 0, i64* %out_len, align 8
  ret void

init_loop:                                           ; preds = %allocs
  ; for (i=0; i<n; ++i) { visited[i]=0; next_idx[i]=0; }
  br label %init_loop.head

init_loop.head:                                      ; preds = %init_loop, %init_loop.body
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.body ]
  %cond.init = icmp ult i64 %i, %n
  br i1 %cond.init, label %init_loop.body, label %post_init

init_loop.body:                                      ; preds = %init_loop.head
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %next_idx, i64 %i
  store i64 0, i64* %next.ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop.head

post_init:                                           ; preds = %init_loop.head
  ; stack_size = 0; *out_len = 0;
  store i64 0, i64* %out_len, align 8
  ; push start
  ; stack[0] = start; stack_size = 1;
  store i64 %start, i64* %stack, align 8
  ; visited[start] = 1
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  ; out[*out_len] = start; ++*out_len;
  %len0 = load i64, i64* %out_len, align 8
  %out.dest = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out.dest, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %outer.loop

outer.loop:                                          ; preds = %found_neighbor, %pop_case, %post_init
  %stack_size = phi i64 [ 1, %post_init ], [ %ss.after.push, %found_neighbor ], [ %ss.after.pop, %pop_case ]
  %has_items = icmp ne i64 %stack_size, 0
  br i1 %has_items, label %top_and_scan, label %done

top_and_scan:                                        ; preds = %outer.loop
  ; current = stack[stack_size-1]
  %idx.top = add i64 %stack_size, -1
  %cur.ptr = getelementptr inbounds i64, i64* %stack, i64 %idx.top
  %current = load i64, i64* %cur.ptr, align 8
  ; i = next_idx[current]
  %next.cur.ptr = getelementptr inbounds i64, i64* %next_idx, i64 %current
  %i.start = load i64, i64* %next.cur.ptr, align 8
  br label %inner.loop

inner.loop:                                          ; preds = %inner.loop, %top_and_scan
  %i.cur = phi i64 [ %i.start, %top_and_scan ], [ %i.incr, %inner.loop ]
  %i.lt.n = icmp ult i64 %i.cur, %n
  br i1 %i.lt.n, label %check_edge, label %pop_case

check_edge:                                          ; preds = %inner.loop
  ; if (adj[current*n + i] != 0 && visited[i] == 0)
  %mul = mul i64 %current, %n
  %idx.flat = add i64 %mul, %i.cur
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx.flat
  %adj.val = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %adj.val, 0
  br i1 %has_edge, label %check_unvisited, label %advance_i

check_unvisited:                                     ; preds = %check_edge
  %vis.i.ptr = getelementptr inbounds i32, i32* %visited, i64 %i.cur
  %vis.i = load i32, i32* %vis.i.ptr, align 4
  %is_unvisited = icmp eq i32 %vis.i, 0
  br i1 %is_unvisited, label %found_neighbor, label %advance_i

advance_i:                                           ; preds = %check_unvisited, %check_edge
  %i.incr = add i64 %i.cur, 1
  br label %inner.loop

found_neighbor:                                      ; preds = %check_unvisited
  ; next_idx[current] = i+1
  %i.plus1 = add i64 %i.cur, 1
  store i64 %i.plus1, i64* %next.cur.ptr, align 8
  ; visited[i] = 1
  store i32 1, i32* %vis.i.ptr, align 4
  ; out[*out_len] = i; ++*out_len;
  %lenA = load i64, i64* %out_len, align 8
  %out.ptrA = getelementptr inbounds i64, i64* %out, i64 %lenA
  store i64 %i.cur, i64* %out.ptrA, align 8
  %lenA1 = add i64 %lenA, 1
  store i64 %lenA1, i64* %out_len, align 8
  ; push i onto stack
  %push.ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %i.cur, i64* %push.ptr, align 8
  %ss.after.push = add i64 %stack_size, 1
  br label %outer.loop

pop_case:                                            ; preds = %inner.loop
  ; no neighbor found: pop
  %ss.after.pop = add i64 %stack_size, -1
  br label %outer.loop

done:                                                ; preds = %outer.loop
  ; free resources
  %p_vis.raw.bc2 = bitcast i32* %visited to i8*
  call void @free(i8* %p_vis.raw.bc2)
  %p_next.raw.bc2 = bitcast i64* %next_idx to i8*
  call void @free(i8* %p_next.raw.bc2)
  %p_stack.raw.bc2 = bitcast i64* %stack to i8*
  call void @free(i8* %p_stack.raw.bc2)
  ret void
}