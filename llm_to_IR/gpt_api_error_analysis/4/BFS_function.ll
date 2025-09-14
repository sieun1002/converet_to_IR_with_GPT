declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_src

check_src:
  %src_in_range = icmp ult i64 %src, %n
  br i1 %src_in_range, label %init_loop.header, label %ret_zero

ret_zero:
  store i64 0, i64* %out_len
  ret void

init_loop.header:
  %i = phi i64 [ 0, %check_src ], [ %i.next, %init_loop.body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop.body, label %post_init

init_loop.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr
  %i.next = add i64 %i, 1
  br label %init_loop.header

post_init:
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %mem_null = icmp eq i8* %mem, null
  br i1 %mem_null, label %ret_zero, label %init_queue

init_queue:
  %q = bitcast i8* %mem to i64*
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr
  %q_slot0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %src, i64* %q_slot0
  store i64 0, i64* %out_len
  br label %outer.header

outer.header:
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %outer.after_inner ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.after, %outer.after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer.body, label %exit

outer.body:
  %q_u_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_u_ptr
  %head.next = add i64 %head, 1
  %len_old = load i64, i64* %out_len
  %len_new = add i64 %len_old, 1
  store i64 %len_new, i64* %out_len
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len_old
  store i64 %u, i64* %out_slot
  br label %inner.header

inner.header:
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.latch ]
  %tail.cur = phi i64 [ %tail, %outer.body ], [ %tail.next, %inner.latch ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.check_adj, label %outer.after_inner

inner.check_adj:
  %mul_un = mul i64 %u, %n
  %idx_mat = add i64 %mul_un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_mat
  %adj_val = load i32, i32* %adj_ptr
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %inner.latch.noenq, label %inner.check_visit

inner.check_visit:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %inner.latch.noenq

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr
  %tail.enq = add i64 %tail.cur, 1
  br label %inner.latch.enq

inner.latch.noenq:
  %v.next0 = add i64 %v, 1
  br label %inner.latch

inner.latch.enq:
  %v.next1 = add i64 %v, 1
  br label %inner.latch

inner.latch:
  %v.next = phi i64 [ %v.next0, %inner.latch.noenq ], [ %v.next1, %inner.latch.enq ]
  %tail.next = phi i64 [ %tail.cur, %inner.latch.noenq ], [ %tail.enq, %inner.latch.enq ]
  br label %inner.header

outer.after_inner:
  %tail.after = phi i64 [ %tail.cur, %inner.header ]
  br label %outer.header

exit:
  %mem.free = bitcast i64* %q to i8*
  call void @free(i8* %mem.free)
  ret void
}