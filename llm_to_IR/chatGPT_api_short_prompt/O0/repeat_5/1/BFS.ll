; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: BFS on adjacency-matrix graph: fill distances from start and record dequeue order (confidence=0.99). Evidence: queue malloc/free; dist init to -1; relax dist[v]=dist[u]+1; enqueue; visit order/count updates.
; Preconditions: adj is n*n int matrix (row-major); dist has length >= n; order has capacity >= n; outCount is non-null. If n==0 or start>=n or malloc fails, *outCount=0 and return.
; Postconditions: dist contains BFS distances from start (0 for start, -1 for unreachable); order[0..*outCount-1] are nodes in dequeue order; *outCount is number of visited nodes.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %n_is_zero, %start_ge_n
  br i1 %early, label %early_ret, label %init_dist

early_ret:
  store i64 0, i64* %outCount, align 8
  ret void

init_dist:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_loop ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %dist_body, label %after_init

dist_body:
  %gep_d = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep_d, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

after_init:
  %size_q = shl i64 %n, 3
  %qraw = call noalias i8* @malloc(i64 %size_q)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %alloc_fail, label %bfs_init

alloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

bfs_init:
  %q = bitcast i8* %qraw to i64*
  %dstart.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dstart.ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %bfs_init ], [ %head.next, %outer_loop_latch ]
  %tail = phi i64 [ 1, %bfs_init ], [ %tail.after_inner, %outer_loop_latch ]
  %cond_outer = icmp ult i64 %head, %tail
  br i1 %cond_outer, label %pop, label %done

pop:
  %q_head_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %oldCount = load i64, i64* %outCount, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %outCount, align 8
  %ord.ptr = getelementptr inbounds i64, i64* %order, i64 %oldCount
  store i64 %u, i64* %ord.ptr, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %pop ], [ %v.next, %inner_latch ]
  %tail.it = phi i64 [ %tail, %pop ], [ %tail.latch, %inner_latch ]
  %vcond = icmp ult i64 %v, %n
  br i1 %vcond, label %inner_body, label %outer_loop_latch

inner_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %adj.val, 0
  br i1 %has_edge, label %check_dist, label %inner_latch

check_dist:
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %is_unseen = icmp eq i32 %dv, -1
  br i1 %is_unseen, label %relax, label %inner_latch

relax:
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du1 = add nsw i32 %du, 1
  store i32 %du1, i32* %dv.ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.it
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.enq = add i64 %tail.it, 1
  br label %inner_latch

inner_latch:
  %tail.latch = phi i64 [ %tail.it, %inner_body ], [ %tail.it, %check_dist ], [ %tail.enq, %relax ]
  %v.next = add i64 %v, 1
  br label %inner_loop

outer_loop_latch:
  %tail.after_inner = phi i64 [ %tail.it, %inner_loop ]
  br label %outer_loop

done:
  call void @free(i8* %qraw)
  ret void
}