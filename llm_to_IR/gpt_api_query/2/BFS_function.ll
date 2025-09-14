; ModuleID = 'bfs'
source_filename = "bfs.ll"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %u = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8
  %q = alloca i64*, align 8
  %raw = alloca i8*, align 8

  ; if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_dist, label %early_ret

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

; initialize dist[0..n-1] = -1
init_dist:
  store i64 0, i64* %i, align 8
  br label %init_loop

init_loop:
  %i_val = load i64, i64* %i, align 8
  %init_cond = icmp ult i64 %i_val, %n
  br i1 %init_cond, label %init_body, label %after_init

init_body:
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %i_val
  store i32 -1, i32* %dist_ptr, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %init_loop

after_init:
  ; q = malloc(n * 8)
  %size = shl i64 %n, 3
  %rawmem = call i8* @malloc(i64 %size)
  store i8* %rawmem, i8** %raw, align 8
  %qnull = icmp eq i8* %rawmem, null
  br i1 %qnull, label %early_ret, label %alloc_ok

alloc_ok:
  %qptr = bitcast i8* %rawmem to i64*
  store i64* %qptr, i64** %q, align 8

  ; head = 0; tail = 0;
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8

  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4

  ; enqueue start
  %tail0 = load i64, i64* %tail, align 8
  %qptr2 = load i64*, i64** %q, align 8
  %qslot = getelementptr inbounds i64, i64* %qptr2, i64 %tail0
  store i64 %start, i64* %qslot, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8

  ; *out_count = 0
  store i64 0, i64* %out_count, align 8

  br label %outer_cond

outer_cond:
  %head_val = load i64, i64* %head, align 8
  %tail_val = load i64, i64* %tail, align 8
  %not_empty = icmp ult i64 %head_val, %tail_val
  br i1 %not_empty, label %dequeue, label %done

dequeue:
  ; u = q[head++]
  %qptr3 = load i64*, i64** %q, align 8
  %qslot_h = getelementptr inbounds i64, i64* %qptr3, i64 %head_val
  %u_val = load i64, i64* %qslot_h, align 8
  store i64 %u_val, i64* %u, align 8
  %head_next = add i64 %head_val, 1
  store i64 %head_next, i64* %head, align 8

  ; out[out_count++] = u
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %u_val, i64* %out_slot, align 8

  ; for (v = 0; v < n; ++v)
  store i64 0, i64* %v, align 8
  br label %inner_cond

inner_cond:
  %v_val = load i64, i64* %v, align 8
  %v_ok = icmp ult i64 %v_val, %n
  br i1 %v_ok, label %inner_body, label %outer_cond

inner_body:
  ; if (adj[u*n + v] != 0 && dist[v] == -1)
  %u_curr = load i64, i64* %u, align 8
  %row_off = mul i64 %u_curr, %n
  %adj_idx = add i64 %row_off, %v_val
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %adj_idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_nz = icmp ne i32 %adj_val, 0
  br i1 %edge_nz, label %check_unvisited, label %inner_next

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v_val
  %dist_v_val = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v_val, -1
  br i1 %is_unvisited, label %visit_v, label %inner_next

visit_v:
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u_curr
  %dist_u_val = load i32, i32* %dist_u_ptr, align 4
  %dist_v_new = add i32 %dist_u_val, 1
  store i32 %dist_v_new, i32* %dist_v_ptr, align 4

  ; enqueue v
  %tail_curr = load i64, i64* %tail, align 8
  %qptr4 = load i64*, i64** %q, align 8
  %qslot_t = getelementptr inbounds i64, i64* %qptr4, i64 %tail_curr
  store i64 %v_val, i64* %qslot_t, align 8
  %tail_next2 = add i64 %tail_curr, 1
  store i64 %tail_next2, i64* %tail, align 8
  br label %inner_next

inner_next:
  %v_inc = add i64 %v_val, 1
  store i64 %v_inc, i64* %v, align 8
  br label %inner_cond

done:
  ; free(q)
  %rawmem2 = load i8*, i8** %raw, align 8
  call void @free(i8* %rawmem2)
  ret void
}