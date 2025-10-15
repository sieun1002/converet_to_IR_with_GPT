target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %visited, i64* %out_order, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %out_count, align 8
  br label %ret

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_loop_cond, label %early_invalid

early_invalid:
  store i64 0, i64* %out_count, align 8
  br label %ret

init_loop_cond:
  %i = phi i64 [ 0, %check_start ], [ %i_next, %init_loop_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %alloc

init_loop_body:
  %visited_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 -1, i32* %visited_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %init_loop_cond

alloc:
  %size = shl i64 %n, 3
  %queue_mem = call noalias i8* @malloc(i64 %size)
  %queue = bitcast i8* %queue_mem to i64*
  %queue_is_null = icmp eq i8* %queue_mem, null
  br i1 %queue_is_null, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %out_count, align 8
  br label %ret

after_malloc:
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 0, i32* %vis_start_ptr, align 4
  %queue0_ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %queue0_ptr, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_cond

bfs_cond:
  %head = phi i64 [ 0, %after_malloc ], [ %head_next, %after_inner_loop ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail_next, %after_inner_loop ]
  %lt = icmp ult i64 %head, %tail
  br i1 %lt, label %dequeue, label %free_and_ret

dequeue:
  %q_elem_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %cur = load i64, i64* %q_elem_ptr, align 8
  %head_next = add i64 %head, 1
  %old_count_val = load i64, i64* %out_count, align 8
  %inc_count = add i64 %old_count_val, 1
  store i64 %inc_count, i64* %out_count, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out_order, i64 %old_count_val
  store i64 %cur, i64* %out_pos_ptr, align 8
  br label %neighbor_cond

neighbor_cond:
  %j = phi i64 [ 0, %dequeue ], [ %j_next, %neighbor_body_end ]
  %tail_live = phi i64 [ %tail, %dequeue ], [ %tail_live_next, %neighbor_body_end ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %neighbor_body, label %after_inner_loop

neighbor_body:
  %mul = mul i64 %cur, %n
  %idx = add i64 %mul, %j
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %neighbor_body_end, label %check_unvisited

check_unvisited:
  %vis_j_ptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vis_j_val = load i32, i32* %vis_j_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_j_val, -1
  br i1 %is_unvisited, label %enqueue, label %neighbor_body_end

enqueue:
  %vis_cur_ptr = getelementptr inbounds i32, i32* %visited, i64 %cur
  %vis_cur_val = load i32, i32* %vis_cur_ptr, align 4
  %vis_cur_plus1 = add i32 %vis_cur_val, 1
  store i32 %vis_cur_plus1, i32* %vis_j_ptr, align 4
  %write_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_live
  store i64 %j, i64* %write_ptr, align 8
  %tail_inc = add i64 %tail_live, 1
  br label %neighbor_body_end

neighbor_body_end:
  %tail_live_next = phi i64 [ %tail_live, %neighbor_body ], [ %tail_live, %check_unvisited ], [ %tail_inc, %enqueue ]
  %j_next = add i64 %j, 1
  br label %neighbor_cond

after_inner_loop:
  %tail_next = phi i64 [ %tail_live, %neighbor_cond ]
  br label %bfs_cond

free_and_ret:
  %queue_i8 = bitcast i64* %queue to i8*
  call void @free(i8* %queue_i8)
  br label %ret

ret:
  ret void
}