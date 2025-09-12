; ModuleID = 'bfs_module'
source_filename = "bfs.ll"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %invalid = or i1 %n_is_zero, %start_ge_n
  br i1 %invalid, label %invalid_ret, label %init_dist

invalid_ret:                                           ; preds = %entry, %post_init
  store i64 0, i64* %out_count
  ret void

init_dist:                                            ; preds = %entry
  br label %init_loop

init_loop:                                            ; preds = %init_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %inc, %init_body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_body, label %post_init

init_body:                                            ; preds = %init_loop
  %dist_elem_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_elem_ptr
  %inc = add i64 %i, 1
  br label %init_loop

post_init:                                            ; preds = %init_loop
  %size_bytes = shl i64 %n, 3
  %raw = call noalias i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %raw to i64*
  %q_is_null = icmp eq i64* %queue, null
  br i1 %q_is_null, label %invalid_ret, label %init_queue

init_queue:                                           ; preds = %post_init
  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr
  ; enqueue start at tail=0, then tail=1
  %q_ptr_tail0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q_ptr_tail0
  ; initialize out_count = 0
  store i64 0, i64* %out_count
  br label %bfs_loop_cond

bfs_loop_cond:                                        ; preds = %after_neighbors, %init_queue
  %head_phi = phi i64 [ 0, %init_queue ], [ %head1, %after_neighbors ]
  %tail_phi = phi i64 [ 1, %init_queue ], [ %tail_after_loop, %after_neighbors ]
  %cond_ht = icmp ult i64 %head_phi, %tail_phi
  br i1 %cond_ht, label %dequeue, label %cleanup

dequeue:                                              ; preds = %bfs_loop_cond
  ; u = queue[head]; head++
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head_phi
  %u = load i64, i64* %q_head_ptr
  %head1 = add i64 %head_phi, 1
  ; out[*out_count] = u; (*out_count)++
  %old_count = load i64, i64* %out_count
  %old_count_plus1 = add i64 %old_count, 1
  store i64 %old_count_plus1, i64* %out_count
  %out_slot_ptr = getelementptr inbounds i64, i64* %out, i64 %old_count
  store i64 %u, i64* %out_slot_ptr
  br label %neighbors_loop

neighbors_loop:                                       ; preds = %neighbors_cont, %dequeue
  %j = phi i64 [ 0, %dequeue ], [ %j_next, %neighbors_cont ]
  %tail_curr = phi i64 [ %tail_phi, %dequeue ], [ %tail_after, %neighbors_cont ]
  %cmpj = icmp ult i64 %j, %n
  br i1 %cmpj, label %check_edge, label %after_neighbors

check_edge:                                           ; preds = %neighbors_loop
  %un = mul i64 %u, %n
  %idx = add i64 %un, %j
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat_val = load i32, i32* %mat_elem_ptr
  %cond_edge_nonzero = icmp ne i32 %mat_val, 0
  br i1 %cond_edge_nonzero, label %check_unvisited, label %neighbors_cont

check_unvisited:                                      ; preds = %check_edge
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr
  %is_unvisited = icmp eq i32 %dist_j, -1
  br i1 %is_unvisited, label %visit_neighbor, label %neighbors_cont

visit_neighbor:                                       ; preds = %check_unvisited
  ; dist[j] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_j_ptr
  ; enqueue j at tail_curr; tail_curr++
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_curr
  store i64 %j, i64* %q_tail_ptr
  %tail2 = add i64 %tail_curr, 1
  br label %neighbors_cont

neighbors_cont:                                       ; preds = %visit_neighbor, %check_unvisited, %check_edge
  %tail_after = phi i64 [ %tail2, %visit_neighbor ], [ %tail_curr, %check_unvisited ], [ %tail_curr, %check_edge ]
  %j_next = add i64 %j, 1
  br label %neighbors_loop

after_neighbors:                                      ; preds = %neighbors_loop
  %tail_after_loop = phi i64 [ %tail_curr, %neighbors_loop ]
  br label %bfs_loop_cond

cleanup:                                              ; preds = %bfs_loop_cond
  %queue_void = bitcast i64* %queue to i8*
  call void @free(i8* %queue_void)
  ret void
}