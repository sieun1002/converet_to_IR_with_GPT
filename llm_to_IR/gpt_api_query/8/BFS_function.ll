; ModuleID = 'bfs'
source_filename = "bfs.ll"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %i = alloca i64, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %v = alloca i64, align 8

  ; if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %cond = or i1 %n_is_zero, %start_ge_n
  br i1 %cond, label %early_ret, label %init

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

init:
  store i64 0, i64* %i, align 8
  br label %loop_init

loop_init:
  %i_val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i_val, %n
  br i1 %cmp, label %loop_body, label %post_init

loop_body:
  %dist_i = getelementptr inbounds i32, i32* %dist, i64 %i_val
  store i32 -1, i32* %dist_i, align 4
  %inc = add i64 %i_val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_init

post_init:
  ; queue = malloc(n * 8)
  %q_bytes = shl i64 %n, 3
  %q_mem = call noalias i8* @malloc(i64 %q_bytes)
  %queue = bitcast i8* %q_mem to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %early_ret2, label %queue_init

early_ret2:
  store i64 0, i64* %out_count, align 8
  ret void

queue_init:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8

  ; dist[start] = 0
  %dstart_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dstart_ptr, align 4

  ; enqueue start
  %tail_val0 = load i64, i64* %tail, align 8
  %qslot0 = getelementptr inbounds i64, i64* %queue, i64 %tail_val0
  store i64 %start, i64* %qslot0, align 8
  %tail_inc0 = add i64 %tail_val0, 1
  store i64 %tail_inc0, i64* %tail, align 8

  ; *out_count = 0
  store i64 0, i64* %out_count, align 8

  br label %while_cond

while_cond:
  %head_val = load i64, i64* %head, align 8
  %tail_val = load i64, i64* %tail, align 8
  %has = icmp ult i64 %head_val, %tail_val
  br i1 %has, label %deq, label %done

deq:
  ; u = queue[head]; head++
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head_val
  %u = load i64, i64* %u_ptr, align 8
  %head_next = add i64 %head_val, 1
  store i64 %head_next, i64* %head, align 8

  ; out[count] = u; count++
  %cnt0 = load i64, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %u, i64* %out_slot, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8

  ; for (v = 0; v < n; v++)
  store i64 0, i64* %v, align 8
  br label %for_cond

for_cond:
  %v_val = load i64, i64* %v, align 8
  %v_cmp = icmp ult i64 %v_val, %n
  br i1 %v_cmp, label %for_body, label %for_end

for_body:
  ; if (adj[u*n + v] != 0)
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v_val
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_edge = icmp ne i32 %adj_val, 0
  br i1 %is_edge, label %check_unvisited, label %for_inc

check_unvisited:
  ; if (dist[v] == -1)
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v_val
  %dv = load i32, i32* %dv_ptr, align 4
  %is_unvisited = icmp eq i32 %dv, -1
  br i1 %is_unvisited, label %visit, label %for_inc

visit:
  ; dist[v] = dist[u] + 1
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du_ptr, align 4
  %du1 = add nsw i32 %du, 1
  store i32 %du1, i32* %dv_ptr, align 4

  ; enqueue v
  %tail_val2 = load i64, i64* %tail, align 8
  %qslot_v = getelementptr inbounds i64, i64* %queue, i64 %tail_val2
  store i64 %v_val, i64* %qslot_v, align 8
  %tail_inc2 = add i64 %tail_val2, 1
  store i64 %tail_inc2, i64* %tail, align 8
  br label %for_inc

for_inc:
  %v_next = add i64 %v_val, 1
  store i64 %v_next, i64* %v, align 8
  br label %for_cond

for_end:
  br label %while_cond

done:
  %q_mem_i8 = bitcast i64* %queue to i8*
  call void @free(i8* %q_mem_i8)
  ret void
}