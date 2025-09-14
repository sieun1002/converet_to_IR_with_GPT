; target triple for Linux x86_64
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len_ptr) {
entry:
  ; if (n == 0 || start >= n) { *out_len_ptr = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad_input = or i1 %n_is_zero, %start_ge_n
  br i1 %bad_input, label %set_zero_ret, label %alloc

set_zero_ret:
  store i64 0, i64* %out_len_ptr
  ret void

alloc:
  ; visited: n * 4 bytes
  %sizeVisited = mul i64 %n, 4
  %visited.raw = call i8* @malloc(i64 %sizeVisited)
  %visited = bitcast i8* %visited.raw to i32*

  ; next index per node: n * 8 bytes
  %sizeNext = mul i64 %n, 8
  %next.raw = call i8* @malloc(i64 %sizeNext)
  %next = bitcast i8* %next.raw to i64*

  ; stack: n * 8 bytes
  %stack.raw = call i8* @malloc(i64 %sizeNext)
  %stack = bitcast i8* %stack.raw to i64*

  ; if any allocation failed: free and return *out_len_ptr = 0
  %vnull = icmp eq i8* %visited.raw, null
  %nnull = icmp eq i8* %next.raw, null
  %snull = icmp eq i8* %stack.raw, null
  %tmp.or1 = or i1 %vnull, %nnull
  %anynull = or i1 %tmp.or1, %snull
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %visited.raw)
  call void @free(i8* %next.raw)
  call void @free(i8* %stack.raw)
  store i64 0, i64* %out_len_ptr
  ret void

init:
  ; zero visited[] and next[]
  br label %zero_loop

zero_loop:
  %z.i = phi i64 [ 0, %init ], [ %z.i.next, %zero_loop.body ]
  %z.cmp = icmp ult i64 %z.i, %n
  br i1 %z.cmp, label %zero_loop.body, label %after_zero

zero_loop.body:
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %z.i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %next, i64 %z.i
  store i64 0, i64* %next.ptr, align 8
  %z.i.next = add i64 %z.i, 1
  br label %zero_loop

after_zero:
  ; stack_size = 0; *out_len = 0
  store i64 0, i64* %out_len_ptr

  ; push start
  %stack.top0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.top0, align 8

  ; visited[start] = 1
  %visStartPtr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %visStartPtr, align 4

  ; append start to out
  %oldLen0 = load i64, i64* %out_len_ptr, align 8
  %out.pos0 = getelementptr inbounds i64, i64* %out, i64 %oldLen0
  store i64 %start, i64* %out.pos0, align 8
  %newLen0 = add i64 %oldLen0, 1
  store i64 %newLen0, i64* %out_len_ptr

  br label %outer.loop

outer.loop:
  ; PHI for stack size
  %ss = phi i64 [ 1, %after_zero ], [ %ss.after, %outer.cont ], [ %ss.push, %found_neighbor ]
  ; while (ss != 0)
  %ss_is_zero = icmp eq i64 %ss, 0
  br i1 %ss_is_zero, label %cleanup, label %outer.body

outer.body:
  ; u = stack[ss-1]
  %ssm1 = add i64 %ss, -1
  %stack.top.ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %u = load i64, i64* %stack.top.ptr, align 8

  ; idx = next[u]
  %next.u.ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %idx0 = load i64, i64* %next.u.ptr, align 8

  br label %inner.loop

inner.loop:
  %idx = phi i64 [ %idx0, %outer.body ], [ %idx.inc, %inner.advance ]
  ; if (idx < n) ...
  %idx_lt_n = icmp ult i64 %idx, %n
  br i1 %idx_lt_n, label %check_edge, label %no_more_neighbors

check_edge:
  ; edge = adj[u * n + idx]
  %mul = mul i64 %u, %n
  %flat = add i64 %mul, %idx
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %flat
  %edge = load i32, i32* %adj.ptr, align 4
  %edge_is_zero = icmp eq i32 %edge, 0
  br i1 %edge_is_zero, label %inner.advance, label %check_visited

check_visited:
  ; if (visited[idx] == 0)
  %vis.idx.ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis.idx = load i32, i32* %vis.idx.ptr, align 4
  %not_visited = icmp eq i32 %vis.idx, 0
  br i1 %not_visited, label %found_neighbor, label %inner.advance

inner.advance:
  ; idx++
  %idx.inc = add i64 %idx, 1
  br label %inner.loop

found_neighbor:
  ; next[u] = idx + 1
  %idx.plus1 = add i64 %idx, 1
  store i64 %idx.plus1, i64* %next.u.ptr, align 8

  ; visited[idx] = 1
  store i32 1, i32* %vis.idx.ptr, align 4

  ; append idx to out
  %oldLen = load i64, i64* %out_len_ptr, align 8
  %out.pos = getelementptr inbounds i64, i64* %out, i64 %oldLen
  store i64 %idx, i64* %out.pos, align 8
  %newLen = add i64 %oldLen, 1
  store i64 %newLen, i64* %out_len_ptr

  ; push idx onto stack: stack[ss] = idx; ss++
  %stack.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %idx, i64* %stack.push.ptr, align 8
  %ss.push = add i64 %ss, 1

  ; continue with outer loop (do not pop)
  br label %outer.loop

no_more_neighbors:
  ; pop: ss--
  %ss.after = add i64 %ss, -1
  br label %outer.cont

outer.cont:
  br label %outer.loop

cleanup:
  call void @free(i8* %visited.raw)
  call void @free(i8* %next.raw)
  call void @free(i8* %stack.raw)
  ret void
}