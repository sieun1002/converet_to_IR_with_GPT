; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search over an adjacency matrix, computing distances and visit order (confidence=0.95). Evidence: queue via malloc/free, dist initialized to -1 then layered update; adjacency indexed as u*n+v.
; Preconditions: adj points to an n*n array of i32 (row-major), dist points to n i32s, order points to at least n i64s, out_count is non-null. n fits in i64. start is an index (0 <= start < n) or else visit count is set to 0.
; Postconditions: dist[start]=0; for reachable v, dist[v] is BFS distance; order[0..*out_count-1] contains nodes in dequeue order.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:                                           ; preds = %entry
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init_loop_entry, label %early

early:                                                 ; preds = %check_start, %entry
  store i64 0, i64* %out_count, align 8
  ret void

init_loop_entry:                                       ; preds = %check_start
  br label %init_loop

init_loop:                                             ; preds = %init_store, %init_loop_entry
  %i = phi i64 [ 0, %init_loop_entry ], [ %i.next, %init_store ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_store, label %post_init

init_store:                                            ; preds = %init_loop
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:                                             ; preds = %init_loop
  %size_bytes = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %malloc_ptr to i64*
  %queue_is_null = icmp eq i64* %queue, null
  br i1 %queue_is_null, label %early, label %after_alloc

after_alloc:                                           ; preds = %post_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  ; enqueue start at tail=0, then tail=1
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_loop

bfs_loop:                                              ; preds = %after_neighbors, %after_alloc
  %head = phi i64 [ 0, %after_alloc ], [ %head.inc, %after_neighbors ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail.out, %after_neighbors ]
  %cond_ht = icmp ult i64 %head, %tail
  br i1 %cond_ht, label %dequeue, label %end

dequeue:                                               ; preds = %bfs_loop
  %qhead_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qhead_ptr, align 8
  %head.inc = add i64 %head, 1
  ; increment out_count, then write order at old index
  %idx_old = load i64, i64* %out_count, align 8
  %idx_new = add i64 %idx_old, 1
  store i64 %idx_new, i64* %out_count, align 8
  %ord_ptr = getelementptr inbounds i64, i64* %order, i64 %idx_old
  store i64 %u, i64* %ord_ptr, align 8
  br label %v_header

v_header:                                              ; preds = %v_next, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %v_next ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.after, %v_next ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %edge_check, label %after_neighbors

edge_check:                                            ; preds = %v_header
  %mul = mul i64 %u, %n
  %idx_adj = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_adj
  %edge_val = load i32, i32* %adj_ptr, align 4
  %edge_nz = icmp ne i32 %edge_val, 0
  br i1 %edge_nz, label %check_dist, label %v_next

check_dist:                                            ; preds = %edge_check
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %unseen = icmp eq i32 %dist_v, -1
  br i1 %unseen, label %visit, label %v_next

visit:                                                 ; preds = %check_dist
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add nsw i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4
  %qtail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %qtail_ptr, align 8
  %tail.enq = add i64 %tail.cur, 1
  br label %v_next

v_next:                                                ; preds = %visit, %check_dist, %edge_check
  %tail.after = phi i64 [ %tail.enq, %visit ], [ %tail.cur, %check_dist ], [ %tail.cur, %edge_check ]
  %v.next = add i64 %v, 1
  br label %v_header

after_neighbors:                                       ; preds = %v_header
  %tail.out = phi i64 [ %tail.cur, %v_header ]
  br label %bfs_loop

end:                                                   ; preds = %bfs_loop
  call void @free(i8* %malloc_ptr)
  ret void
}