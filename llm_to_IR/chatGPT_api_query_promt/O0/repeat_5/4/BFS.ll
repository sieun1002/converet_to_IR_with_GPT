; ModuleID = 'bfs'
source_filename = "bfs.ll"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %count_ptr) {
entry:
  %head = alloca i64
  %tail = alloca i64
  %i = alloca i64
  %queue = alloca i64*
  %u = alloca i64
  %v = alloca i64

  ; if (n == 0) goto zero_ret
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %set_zero_and_ret, label %check_start

check_start:
  ; if (start < n) goto init else zero_ret
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init, label %set_zero_and_ret

set_zero_and_ret:
  store i64 0, i64* %count_ptr
  ret void

init:
  ; dist[i] = -1 for i in [0, n)
  store i64 0, i64* %i
  br label %init_loop

init_loop:
  %i_val = load i64, i64* %i
  %init_cond = icmp ult i64 %i_val, %n
  br i1 %init_cond, label %init_body, label %after_init

init_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i_val
  store i32 -1, i32* %dist_i_ptr
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i
  br label %init_loop

after_init:
  ; queue = malloc(n * 8)
  %size_bytes = shl i64 %n, 3
  %malloc_raw = call i8* @malloc(i64 %size_bytes)
  %queue_ptr = bitcast i8* %malloc_raw to i64*
  store i64* %queue_ptr, i64** %queue
  %queue_is_null = icmp eq i64* %queue_ptr, null
  br i1 %queue_is_null, label %set_zero_and_ret_null, label %setup

set_zero_and_ret_null:
  store i64 0, i64* %count_ptr
  ret void

setup:
  ; head = 0; tail = 0
  store i64 0, i64* %head
  store i64 0, i64* %tail

  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr

  ; enqueue start
  %tail0 = load i64, i64* %tail
  %qptr0 = load i64*, i64** %queue
  %qslot0 = getelementptr inbounds i64, i64* %qptr0, i64 %tail0
  store i64 %start, i64* %qslot0
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail

  ; *count_ptr = 0
  store i64 0, i64* %count_ptr

  br label %bfs_cond

bfs_cond:
  %head_val = load i64, i64* %head
  %tail_val = load i64, i64* %tail
  %not_empty = icmp ult i64 %head_val, %tail_val
  br i1 %not_empty, label %bfs_dequeue, label %done

bfs_dequeue:
  ; u = queue[head++]
  %qptr1 = load i64*, i64** %queue
  %u_ptr = getelementptr inbounds i64, i64* %qptr1, i64 %head_val
  %u_val = load i64, i64* %u_ptr
  store i64 %u_val, i64* %u
  %head_next = add i64 %head_val, 1
  store i64 %head_next, i64* %head

  ; order[(*count)++] = u
  %count_old = load i64, i64* %count_ptr
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %count_old
  store i64 %u_val, i64* %order_slot
  %count_inc = add i64 %count_old, 1
  store i64 %count_inc, i64* %count_ptr

  ; v = 0
  store i64 0, i64* %v
  br label %for_v_cond

for_v_cond:
  %v_val = load i64, i64* %v
  %v_lt_n = icmp ult i64 %v_val, %n
  br i1 %v_lt_n, label %for_v_body, label %bfs_cond

for_v_body:
  ; if (matrix[u*n + v] != 0)
  %u_cur = load i64, i64* %u
  %un = mul i64 %u_cur, %n
  %idx = add i64 %un, %v_val
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat_val = load i32, i32* %mat_ptr
  %is_edge = icmp ne i32 %mat_val, 0
  br i1 %is_edge, label %check_unvisited, label %inc_v

check_unvisited:
  ; if (dist[v] == -1)
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v_val
  %dist_v = load i32, i32* %dist_v_ptr
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit_neighbor, label %inc_v

visit_neighbor:
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u_cur
  %dist_u = load i32, i32* %dist_u_ptr
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr

  ; enqueue v
  %tail_cur = load i64, i64* %tail
  %qptr2 = load i64*, i64** %queue
  %qslot = getelementptr inbounds i64, i64* %qptr2, i64 %tail_cur
  store i64 %v_val, i64* %qslot
  %tail_inc = add i64 %tail_cur, 1
  store i64 %tail_inc, i64* %tail
  br label %inc_v

inc_v:
  %v_next = add i64 %v_val, 1
  store i64 %v_next, i64* %v
  br label %for_v_cond

done:
  %qptr_free = load i64*, i64** %queue
  %qptr_free_i8 = bitcast i64* %qptr_free to i8*
  call void @free(i8* %qptr_free_i8)
  ret void
}