; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search from a start node on an N×N int adjacency matrix, computing distances and recording dequeue order (confidence=0.98). Evidence: dist array init to -1 and layered update, queue via malloc with head/tail, adjacency access graph[u*N+v].
; Preconditions: graph points to at least N*N int32, dist points to at least N int32, out_order points to at least N int64, out_count is non-null. start < N and N>0 for normal operation.
; Postconditions: If N==0 or start>=N or allocation fails: *out_count=0 and return (dist unchanged in first case, set to -1 if alloc failed path was entered after init). Otherwise: dist[v] = BFS distance from start or -1 if unreachable; out_order[0..*out_count-1] are nodes in dequeue order.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @bfs(i32* %graph, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) local_unnamed_addr {
entry:
  ; Early checks: if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret, label %chk_start

chk_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_dist, label %early_ret

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

; Initialize dist[i] = -1 for i in [0, n)
init_dist:
  %i.init = phi i64 [ 0, %chk_start ]
  %cmp.init = icmp ult i64 %i.init, %n
  br i1 %cmp.init, label %dist_loop, label %alloc_q

dist_loop:
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %i.init
  store i32 -1, i32* %dist_ptr, align 4
  %i.next = add i64 %i.init, 1
  %cont = icmp ult i64 %i.next, %n
  br i1 %cont, label %dist_loop, label %alloc_q

; Allocate queue of i64 with capacity n
alloc_q:
  %qsize = shl i64 %n, 3
  %qraw = call noalias i8* @malloc(i64 %qsize)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %malloc_fail, label %after_alloc

malloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

after_alloc:
  %queue = bitcast i8* %qraw to i64*
  ; head = 0; tail = 0;
  %head = phi i64 [ 0, %alloc_q ]
  %tail = phi i64 [ 0, %alloc_q ]
  ; dist[start] = 0;
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  ; queue[tail++] = start;
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail
  store i64 %start, i64* %q_tail_ptr, align 8
  %tail1 = add i64 %tail, 1
  ; *out_count = 0;
  store i64 0, i64* %out_count, align 8
  br label %while_check

while_check:
  %head.cur = phi i64 [ %head, %after_alloc ], [ %head.next, %inner_done ]
  %tail.cur = phi i64 [ %tail1, %after_alloc ], [ %tail.next, %inner_done ]
  %cmp_ht = icmp ult i64 %head.cur, %tail.cur
  br i1 %cmp_ht, label %dequeue, label %done

dequeue:
  ; u = queue[head++]
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head.cur
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head.cur, 1
  ; record: out_order[*out_count] = u; ++*out_count
  %cnt = load i64, i64* %out_count, align 8
  %cnt.next = add i64 %cnt, 1
  store i64 %cnt.next, i64* %out_count, align 8
  %out_ptr = getelementptr inbounds i64, i64* %out_order, i64 %cnt
  store i64 %u, i64* %out_ptr, align 8
  ; inner loop v = 0..n-1
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_iter_end ]
  ; if (v < n)
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_iter, label %inner_done

inner_iter:
  ; if (graph[u*n + v] != 0) ...
  %u_mul_n = mul i64 %u, %n
  %idx_uv = add i64 %u_mul_n, %v
  %edge_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx_uv
  %edge = load i32, i32* %edge_ptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %inner_iter_end, label %check_unvisited

check_unvisited:
  ; if (dist[v] == -1)
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv_ptr, align 4
  %is_unvisited = icmp eq i32 %dv, -1
  br i1 %is_unvisited, label %visit, label %inner_iter_end

visit:
  ; dist[v] = dist[u] + 1
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du_ptr, align 4
  %du_inc = add i32 %du, 1
  store i32 %du_inc, i32* %dv_ptr, align 4
  ; enqueue v: queue[tail.cur] = v; ++tail.cur
  %q_tail_ptr2 = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr2, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner_iter_end_tail

inner_iter_end_tail:
  ; update tail.cur after enqueue
  %tail.upd = phi i64 [ %tail.inc, %visit ]
  br label %inner_iter_end

inner_iter_end:
  ; propagate tail.cur if updated
  %tail.cur.next = phi i64 [ %tail.cur, %inner_iter ], [ %tail.upd, %inner_iter_end_tail ], [ %tail.cur, %check_unvisited ]
  %v.next = add i64 %v, 1
  br label %inner_loop

inner_done:
  %tail.next = phi i64 [ %tail.cur, %inner_loop ]
  br label %while_check

done:
  ; free(queue)
  %qraw.free = bitcast i64* %queue to i8*
  call void @free(i8* %qraw.free)
  ret void
}