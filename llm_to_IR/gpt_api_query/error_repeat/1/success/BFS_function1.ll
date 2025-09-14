; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %queue = alloca i64*, align 8
  %i.var = alloca i64, align 8
  %v.var = alloca i64, align 8

  ; early checks: if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_exit, label %init_dist

early_exit:
  store i64 0, i64* %out_count, align 8
  ret void

; initialize dist[0..n-1] = -1
init_dist:
  store i64 0, i64* %i.var, align 8
  br label %init_dist.loop

init_dist.loop:
  %i = load i64, i64* %i.var, align 8
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_dist.body, label %after_init_dist

init_dist.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  store i64 %i.next, i64* %i.var, align 8
  br label %init_dist.loop

after_init_dist:
  ; queue = malloc(n * 8)
  %qsize = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %qsize)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %malloc_fail, label %init_queue

malloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

init_queue:
  %q = bitcast i8* %qraw to i64*
  store i64* %q, i64** %queue, align 8
  ; head = 0; tail = 0
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  ; enqueue start: queue[tail] = start; tail++
  %tail0 = load i64, i64* %tail, align 8
  %qptr0 = load i64*, i64** %queue, align 8
  %q_tail_ptr = getelementptr inbounds i64, i64* %qptr0, i64 %tail0
  store i64 %start, i64* %q_tail_ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8
  ; *out_count = 0
  store i64 0, i64* %out_count, align 8
  br label %outer.cond

outer.cond:
  %head.cur = load i64, i64* %head, align 8
  %tail.cur = load i64, i64* %tail, align 8
  %has_item = icmp ult i64 %head.cur, %tail.cur
  br i1 %has_item, label %outer.body, label %done

outer.body:
  ; u = queue[head++]
  %qptr1 = load i64*, i64** %queue, align 8
  %q_head_ptr = getelementptr inbounds i64, i64* %qptr1, i64 %head.cur
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head, align 8

  ; out[*out_count] = u; (*out_count)++
  %cnt0 = load i64, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %u, i64* %out_slot, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8

  ; for (v = 0; v < n; ++v)
  store i64 0, i64* %v.var, align 8
  br label %inner.cond

inner.cond:
  %v = load i64, i64* %v.var, align 8
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %outer.cond

inner.body:
  ; if (adj[u*n + v] != 0 && dist[v] == -1) { dist[v] = dist[u]+1; enqueue v; }
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nz = icmp ne i32 %adj_val, 0
  br i1 %adj_nz, label %check_unseen, label %inner.inc

check_unseen:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %visit, label %inner.inc

visit:
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  ; enqueue v
  %tail.cur2 = load i64, i64* %tail, align 8
  %qptr2 = load i64*, i64** %queue, align 8
  %q_tail_ptr2 = getelementptr inbounds i64, i64* %qptr2, i64 %tail.cur2
  store i64 %v, i64* %q_tail_ptr2, align 8
  %tail.next2 = add i64 %tail.cur2, 1
  store i64 %tail.next2, i64* %tail, align 8
  br label %inner.inc

inner.inc:
  %v.next = add i64 %v, 1
  store i64 %v.next, i64* %v.var, align 8
  br label %inner.cond

done:
  ; free(queue)
  %qptr.free = load i64*, i64** %queue, align 8
  %qraw.free = bitcast i64* %qptr.free to i8*
  call void @free(i8* %qraw.free)
  ret void
}