; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: breadth-first search over adjacency matrix, computing distances and visit order (confidence=0.95). Evidence: dist init to -1 and set via dist[v]=dist[u]+1; queue of i64 with head/tail and adjacency check graph[u*n+v]
; Preconditions: graph is an n*n int (i32) matrix; dist has length >= n; order has length >= n; out_count is non-null
; Postconditions: dist holds BFS levels (0 at start, -1 unreachable); order[0..*out_count-1] is dequeue order; *out_count=0 if n==0, start>=n, or allocation failure

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* nocapture readonly %graph, i64 %n, i64 %start, i32* nocapture %dist, i64* nocapture %order, i64* nocapture %out_count) local_unnamed_addr {
entry:
  ; if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early_bad = or i1 %n_is_zero, %start_ge_n
  br i1 %early_bad, label %early_ret, label %init_dist

early_ret:                                           ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:                                           ; preds = %entry
  br label %dist_loop

dist_loop:                                           ; preds = %dist_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %dist_body, label %post_init

dist_body:                                           ; preds = %dist_loop
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init:                                           ; preds = %dist_loop
  %size = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size)
  %q = bitcast i8* %q.raw to i64*
  %qnull = icmp eq i64* %q, null
  br i1 %qnull, label %malloc_fail, label %after_alloc

malloc_fail:                                         ; preds = %post_init
  store i64 0, i64* %out_count, align 8
  ret void

after_alloc:                                         ; preds = %post_init
  ; dist[start] = 0
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; enqueue start at tail=0
  store i64 0, i64* %out_count, align 8
  br label %init_queue

init_queue:                                          ; preds = %after_alloc
  %head0 = phi i64 [ 0, %after_alloc ]
  %tail0 = phi i64 [ 0, %after_alloc ]
  %q.tail0.ptr = getelementptr inbounds i64, i64* %q, i64 %tail0
  store i64 %start, i64* %q.tail0.ptr, align 8
  %tail1 = add i64 %tail0, 1
  br label %bfs_loop

bfs_loop:                                            ; preds = %neighbors_done, %init_queue
  %head = phi i64 [ %head0, %init_queue ], [ %head.out, %neighbors_done ]
  %tail = phi i64 [ %tail1, %init_queue ], [ %tail.out, %neighbors_done ]
  %nonempty = icmp ult i64 %head, %tail
  br i1 %nonempty, label %dequeue, label %done

dequeue:                                             ; preds = %bfs_loop
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next0 = add i64 %head, 1
  ; append u to order
  %count.old = load i64, i64* %out_count, align 8
  %ord.ptr = getelementptr inbounds i64, i64* %order, i64 %count.old
  store i64 %u, i64* %ord.ptr, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %out_count, align 8
  br label %neighbors_loop

neighbors_loop:                                      ; preds = %v_advance, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %v_advance ]
  %tail.curr = phi i64 [ %tail, %dequeue ], [ %tail.next, %v_advance ]
  %head.fixed = phi i64 [ %head.next0, %dequeue ], [ %head.fixed, %v_advance ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %neighbors_body, label %neighbors_done

neighbors_body:                                      ; preds = %neighbors_loop
  ; if (graph[u*n + v] == 0) continue
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %gval = load i32, i32* %g.ptr, align 4
  %isZero = icmp eq i32 %gval, 0
  br i1 %isZero, label %v_advance_no_enq, label %check_unvisited

check_unvisited:                                     ; preds = %neighbors_body
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %unvisited = icmp eq i32 %dv, -1
  br i1 %unvisited, label %do_visit, label %v_advance_no_enq

do_visit:                                            ; preds = %check_unvisited
  ; dist[v] = dist[u] + 1
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du1 = add nsw i32 %du, 1
  store i32 %du1, i32* %dv.ptr, align 4
  ; enqueue v
  %q.enq.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.curr
  store i64 %v, i64* %q.enq.ptr, align 8
  %tail.enq = add i64 %tail.curr, 1
  br label %v_advance

v_advance_no_enq:                                    ; preds = %check_unvisited, %neighbors_body
  br label %v_advance

v_advance:                                           ; preds = %v_advance_no_enq, %do_visit
  %tail.next = phi i64 [ %tail.enq, %do_visit ], [ %tail.curr, %v_advance_no_enq ]
  %v.next = add i64 %v, 1
  br label %neighbors_loop

neighbors_done:                                      ; preds = %neighbors_loop
  %head.out = phi i64 [ %head.fixed, %neighbors_loop ]
  %tail.out = phi i64 [ %tail.curr, %neighbors_loop ]
  br label %bfs_loop

done:                                                ; preds = %bfs_loop
  call void @free(i8* %q.raw)
  ret void
}