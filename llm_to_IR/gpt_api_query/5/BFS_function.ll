; ModuleID = 'bfs'
source_filename = "bfs.ll"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_dist.cond, label %early

early:
  store i64 0, i64* %count, align 8
  ret void

init_dist.cond:
  %i = phi i64 [ 0, %check_start ], [ %i.next, %init_dist.body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_dist.body, label %alloc_queue

init_dist.body:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_dist.cond

alloc_queue:
  %size = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %size)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %count, align 8
  ret void

after_malloc:
  %q = bitcast i8* %qraw to i64*
  ; dist[start] = 0
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; queue[0] = start; tail = 1; head = 0
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %count, align 8
  br label %bfs.cond

bfs.cond:
  %head = phi i64 [ 0, %after_malloc ], [ %head.next, %neighbors.done ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail.out, %neighbors.done ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %bfs.body, label %bfs.end

bfs.body:
  ; u = q[head]; head++
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; order[count] = u; count++
  %oldcnt = load i64, i64* %count, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %count, align 8
  %order.ptr = getelementptr inbounds i64, i64* %order, i64 %oldcnt
  store i64 %u, i64* %order.ptr, align 8
  br label %neighbors.cond

neighbors.cond:
  %v = phi i64 [ 0, %bfs.body ], [ %v.next, %neighbors.merge ]
  %tail.in = phi i64 [ %tail, %bfs.body ], [ %tail.updated, %neighbors.merge ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %neighbors.body, label %neighbors.done

neighbors.body:
  ; if matrix[u*n + v] != 0
  %u_mul_n = mul i64 %u, %n
  %idx = add i64 %u_mul_n, %v
  %mat.ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat.val = load i32, i32* %mat.ptr, align 4
  %is_edge = icmp ne i32 %mat.val, 0
  br i1 %is_edge, label %check.unvisited, label %neighbors.nochange

check.unvisited:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is_unvisited = icmp eq i32 %dist.v, -1
  br i1 %is_unvisited, label %visit.neighbor, label %neighbors.nochange

visit.neighbor:
  ; dist[v] = dist[u] + 1
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add nsw i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  ; enqueue v: q[tail.in] = v; tail.in++
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.in
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.plus1 = add i64 %tail.in, 1
  br label %neighbors.change

neighbors.nochange:
  br label %neighbors.merge

neighbors.change:
  br label %neighbors.merge

neighbors.merge:
  %tail.updated = phi i64 [ %tail.in, %neighbors.nochange ], [ %tail.plus1, %neighbors.change ]
  %v.next = add i64 %v, 1
  br label %neighbors.cond

neighbors.done:
  %tail.out = phi i64 [ %tail.in, %neighbors.cond ]
  br label %bfs.cond

bfs.end:
  call void @free(i8* %qraw)
  ret void
}