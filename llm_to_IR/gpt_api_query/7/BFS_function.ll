; LLVM 14 IR for function: bfs

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  ; early exit: if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %n_is_zero, %start_ge_n
  br i1 %early, label %early_ret, label %init_dist

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:
  ; for (i=0; i<n; ++i) dist[i] = -1
  %i0 = phi i64 [ 0, %entry ], [ %i.next, %dist_loop ]
  %cmp_i = icmp ult i64 %i0, %n
  br i1 %cmp_i, label %dist_loop, label %alloc_q

dist_loop:
  %gep.di = getelementptr inbounds i32, i32* %dist, i64 %i0
  store i32 -1, i32* %gep.di, align 4
  %i.next = add i64 %i0, 1
  br label %init_dist

alloc_q:
  ; q = malloc(n * 8)
  %size = shl i64 %n, 3
  %q.raw = call noalias i8* @malloc(i64 %size)
  %q = bitcast i8* %q.raw to i64*
  %q_is_null = icmp eq i64* %q, null
  br i1 %q_is_null, label %malloc_fail, label %bfs_init

malloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

bfs_init:
  ; head = 0; tail = 0;
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8

  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4

  ; q[tail++] = start
  %tail0 = load i64, i64* %tail, align 8
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail0
  store i64 %start, i64* %q_tail_ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8

  ; *out_count = 0
  store i64 0, i64* %out_count, align 8

  br label %outer_cond

outer_cond:
  ; while (head < tail)
  %head.cur = load i64, i64* %head, align 8
  %tail.cur = load i64, i64* %tail, align 8
  %have = icmp ult i64 %head.cur, %tail.cur
  br i1 %have, label %outer_body, label %done

outer_body:
  ; u = q[head++]
  %u_ptr = getelementptr inbounds i64, i64* %q, i64 %head.cur
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head, align 8

  ; c_old = *out_count; *out_count = c_old + 1; out[c_old] = u
  %c_old = load i64, i64* %out_count, align 8
  %c_new = add i64 %c_old, 1
  store i64 %c_new, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %c_old
  store i64 %u, i64* %out_slot, align 8

  ; v = 0
  br label %inner_cond

inner_cond:
  ; for (v = 0; v < n; ++v)
  %v = phi i64 [ 0, %outer_body ], [ %v.next, %inner_next ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_body, label %outer_cond

inner_body:
  ; if (adj[u*n + v] != 0 && dist[v] == -1) { dist[v] = dist[u] + 1; q[tail++] = v; }
  %u_mul_n = mul i64 %u, %n
  %uv = add i64 %u_mul_n, %v
  %adj_uv_ptr = getelementptr inbounds i32, i32* %adj, i64 %uv
  %adj_uv = load i32, i32* %adj_uv_ptr, align 4
  %adj_nz = icmp ne i32 %adj_uv, 0
  br i1 %adj_nz, label %check_dist_v, label %inner_next

check_dist_v:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %dist_v_is_neg1 = icmp eq i32 %dist_v, -1
  br i1 %dist_v_is_neg1, label %relax_enqueue, label %inner_next

relax_enqueue:
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4

  ; q[tail++] = v
  %tail.cur2 = load i64, i64* %tail, align 8
  %q_tail_ptr2 = getelementptr inbounds i64, i64* %q, i64 %tail.cur2
  store i64 %v, i64* %q_tail_ptr2, align 8
  %tail.next2 = add i64 %tail.cur2, 1
  store i64 %tail.next2, i64* %tail, align 8
  br label %inner_next

inner_next:
  %v.next = add i64 %v, 1
  br label %inner_cond

done:
  ; free(q)
  %q.raw2 = bitcast i64* %q to i8*
  call void @free(i8* %q.raw2)
  ret void
}