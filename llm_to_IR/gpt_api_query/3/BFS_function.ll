; ModuleID = 'bfs.ll'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %visited, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_ret, label %init_dist

early_ret:                                            ; preds = %entry, %alloc_queue
  store i64 0, i64* %count, align 8
  ret void

init_dist:                                            ; preds = %entry
  br label %dist_loop

dist_loop:                                            ; preds = %dist_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_body ]
  %dist_cond = icmp ult i64 %i, %n
  br i1 %dist_cond, label %dist_body, label %alloc_queue

dist_body:                                            ; preds = %dist_loop
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr_i, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

alloc_queue:                                          ; preds = %dist_loop
  %size_bytes = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %mem to i64*
  %is_null = icmp eq i64* %queue, null
  br i1 %is_null, label %early_ret, label %init_bfs

init_bfs:                                             ; preds = %alloc_queue
  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  ; enqueue start at position 0, tail becomes 1
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  ; initialize output count = 0
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:                                             ; preds = %bfs_continue, %init_bfs
  %head = phi i64 [ 0, %init_bfs ], [ %head.next, %bfs_continue ]
  %tail = phi i64 [ 1, %init_bfs ], [ %tail.after, %bfs_continue ]
  %non_empty = icmp ult i64 %head, %tail
  br i1 %non_empty, label %dequeue, label %done_free

dequeue:                                              ; preds = %bfs_loop
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  ; append to visited: visited[*count] = u; (*count)++
  %old_count = load i64, i64* %count, align 8
  %new_count = add i64 %old_count, 1
  store i64 %new_count, i64* %count, align 8
  %vis_slot = getelementptr inbounds i64, i64* %visited, i64 %old_count
  store i64 %u, i64* %vis_slot, align 8
  br label %inner_loop

inner_loop:                                           ; preds = %inner_step, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_step ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.updated, %inner_step ]
  %vcond = icmp ult i64 %v, %n
  br i1 %vcond, label %inner_body, label %after_inner

inner_body:                                           ; preds = %inner_loop
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_edge = icmp ne i32 %adj_val, 0
  br i1 %is_edge, label %check_unseen, label %no_enqueue

check_unseen:                                         ; preds = %inner_body
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %do_enqueue, label %no_enqueue

do_enqueue:                                           ; preds = %check_unseen
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  ; enqueue v at tail.cur
  %queue_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %queue_tail_ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner_step

no_enqueue:                                           ; preds = %check_unseen, %inner_body
  br label %inner_step

inner_step:                                           ; preds = %no_enqueue, %do_enqueue
  %tail.updated = phi i64 [ %tail.inc, %do_enqueue ], [ %tail.cur, %no_enqueue ]
  %v.next = add i64 %v, 1
  br label %inner_loop

after_inner:                                          ; preds = %inner_loop
  ; carry tail.cur out of inner loop
  %tail.after = phi i64 [ %tail.cur, %inner_loop ]
  br label %bfs_continue

bfs_continue:                                         ; preds = %after_inner
  br label %bfs_loop

done_free:                                            ; preds = %bfs_loop
  call void @free(i8* %mem)
  ret void
}