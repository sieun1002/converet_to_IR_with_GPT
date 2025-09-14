; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search from 'start' on an n-vertex graph adjacency matrix; fill distances and record visit order (confidence=0.98). Evidence: initializes dist[] to -1, uses a FIFO queue via malloc/free, checks adj[u*n+v]!=0, sets dist[v]=dist[u]+1, pushes v, records dequeue order in out array while incrementing length.
; Preconditions: adj points to n*n 32-bit ints (row-major), dist points to n 32-bit ints, order points to space for n 64-bit ints, out_len is non-null; if n==0 or start>=n, out_len is set to 0 and return.
; Postconditions: dist[v] == -1 for unreachable, otherwise shortest hop-count from start; order[0..*out_len-1] contains nodes in BFS dequeue order; *out_len is number of visited nodes.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @bfs(i32* noalias nocapture readonly %adj, i64 %n, i64 %start, i32* noalias nocapture %dist, i64* noalias nocapture %order, i64* noalias nocapture %out_len) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:                                          ; preds = %entry
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_dist, label %early_zero

early_zero:                                           ; preds = %check_start, %entry
  store i64 0, i64* %out_len, align 8
  ret void

init_dist:                                            ; preds = %check_start
  br label %dist_loop

dist_loop:                                            ; preds = %dist_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %dist_body, label %post_init

dist_body:                                            ; preds = %dist_loop
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr_i, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init:                                            ; preds = %dist_loop
  %size_bytes = shl i64 %n, 3
  %rawq = call noalias i8* @malloc(i64 %size_bytes)
  %q = bitcast i8* %rawq to i64*
  %is_null = icmp eq i64* %q, null
  br i1 %is_null, label %early_zero, label %init_queue

init_queue:                                           ; preds = %post_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_slot0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q_slot0, align 8
  store i64 0, i64* %out_len, align 8
  br label %outer_loop

outer_loop:                                           ; preds = %after_inner, %init_queue
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %after_inner ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.updated, %after_inner ]
  %has_item = icmp ult i64 %head, %tail
  br i1 %has_item, label %dequeue, label %cleanup

dequeue:                                              ; preds = %outer_loop
  %u_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  %old_len = load i64, i64* %out_len, align 8
  %new_len = add i64 %old_len, 1
  store i64 %new_len, i64* %out_len, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %old_len
  store i64 %u, i64* %order_slot, align 8
  br label %inner_header

inner_header:                                         ; preds = %inner_continue, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_continue ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next, %inner_continue ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_check_edge, label %after_inner

inner_check_edge:                                     ; preds = %inner_header
  %u_times_n = mul i64 %u, %n
  %idx = add i64 %u_times_n, %v
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge_val = load i32, i32* %adj_elem_ptr, align 4
  %has_edge = icmp ne i32 %edge_val, 0
  br i1 %has_edge, label %check_unvisited, label %inner_advance_no_enqueue

check_unvisited:                                      ; preds = %inner_check_edge
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit_neighbor, label %inner_advance_no_enqueue

visit_neighbor:                                       ; preds = %check_unvisited
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.cur.inc = add i64 %tail.cur, 1
  br label %inner_advance_enqueued

inner_advance_no_enqueue:                             ; preds = %check_unvisited, %inner_check_edge
  %v.next.no = add i64 %v, 1
  br label %inner_continue

inner_advance_enqueued:                               ; preds = %visit_neighbor
  %v.next.enq = add i64 %v, 1
  br label %inner_continue

inner_continue:                                       ; preds = %inner_advance_enqueued, %inner_advance_no_enqueue
  %tail.next = phi i64 [ %tail.cur, %inner_advance_no_enqueue ], [ %tail.cur.inc, %inner_advance_enqueued ]
  %v.next = phi i64 [ %v.next.no, %inner_advance_no_enqueue ], [ %v.next.enq, %inner_advance_enqueued ]
  br label %inner_header

after_inner:                                          ; preds = %inner_header
  %tail.updated = phi i64 [ %tail.cur, %inner_header ]
  br label %outer_loop

cleanup:                                              ; preds = %outer_loop
  %raw_q = bitcast i64* %q to i8*
  call void @free(i8* %raw_q)
  ret void
}