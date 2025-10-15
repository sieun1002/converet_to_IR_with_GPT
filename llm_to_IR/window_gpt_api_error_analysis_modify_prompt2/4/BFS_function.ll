; ModuleID = 'bfs'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %matrix, i64 %n, i64 %src, i32* %dist, i64* %out, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %invalid, label %check_src

check_src:
  %src_lt_n = icmp ult i64 %src, %n
  br i1 %src_lt_n, label %init_dist_loop, label %invalid

invalid:
  store i64 0, i64* %count
  ret void

init_dist_loop:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist_loop ], [ %i.next, %dist_loop_body_end ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %dist_loop_body, label %after_init_dist

dist_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr
  br label %dist_loop_body_end

dist_loop_body_end:
  %i.next = add i64 %i, 1
  br label %dist_loop

after_init_dist:
  %size_bytes = shl i64 %n, 3
  %queue_i8 = call i8* @malloc(i64 %size_bytes)
  %queue_null = icmp eq i8* %queue_i8, null
  br i1 %queue_null, label %invalid, label %queue_ok

queue_ok:
  %queue = bitcast i8* %queue_i8 to i64*
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr
  %q_tail_ptr0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %src, i64* %q_tail_ptr0
  %tail1 = add i64 0, 1
  store i64 0, i64* %count
  br label %bfs_cond

bfs_cond:
  %head = phi i64 [ 0, %queue_ok ], [ %head.inc, %bfs_iter_end ]
  %tail = phi i64 [ %tail1, %queue_ok ], [ %tail.cur.out, %bfs_iter_end ]
  %have = icmp ult i64 %head, %tail
  br i1 %have, label %bfs_iter, label %after_bfs

bfs_iter:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %cur = load i64, i64* %q_head_ptr
  %head.inc = add i64 %head, 1
  %cnt_old = load i64, i64* %count
  %cnt_inc = add i64 %cnt_old, 1
  store i64 %cnt_inc, i64* %count
  %out_idx_ptr = getelementptr inbounds i64, i64* %out, i64 %cnt_old
  store i64 %cur, i64* %out_idx_ptr
  br label %neighbor_loop

neighbor_loop:
  %j = phi i64 [ 0, %bfs_iter ], [ %j.next, %neighbor_iter_end ]
  %tail.cur = phi i64 [ %tail, %bfs_iter ], [ %tail.updated, %neighbor_iter_end ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %neighbor_body, label %neighbor_done

neighbor_body:
  %cur_mul_n = mul i64 %cur, %n
  %row_idx = add i64 %cur_mul_n, %j
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %row_idx
  %mat_elem = load i32, i32* %mat_elem_ptr
  %is_zero = icmp eq i32 %mat_elem, 0
  br i1 %is_zero, label %neighbor_zero, label %neighbor_nonzero

neighbor_zero:
  br label %neighbor_iter_end

neighbor_nonzero:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j_val = load i32, i32* %dist_j_ptr
  %is_unvisited = icmp eq i32 %dist_j_val, -1
  br i1 %is_unvisited, label %neighbor_visit, label %neighbor_skip

neighbor_skip:
  br label %neighbor_iter_end

neighbor_visit:
  %dist_cur_ptr = getelementptr inbounds i32, i32* %dist, i64 %cur
  %dist_cur_val = load i32, i32* %dist_cur_ptr
  %dist_plus = add i32 %dist_cur_val, 1
  store i32 %dist_plus, i32* %dist_j_ptr
  %q_tail_ptr2 = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %j, i64* %q_tail_ptr2
  %tail.enq = add i64 %tail.cur, 1
  br label %neighbor_iter_end

neighbor_iter_end:
  %tail.updated = phi i64 [ %tail.cur, %neighbor_zero ], [ %tail.cur, %neighbor_skip ], [ %tail.enq, %neighbor_visit ]
  %j.next = add i64 %j, 1
  br label %neighbor_loop

neighbor_done:
  %tail.cur.out = add i64 %tail.cur, 0
  br label %bfs_iter_end

bfs_iter_end:
  br label %bfs_cond

after_bfs:
  %queue_i8_free = bitcast i64* %queue to i8*
  call void @free(i8* %queue_i8_free)
  ret void
}