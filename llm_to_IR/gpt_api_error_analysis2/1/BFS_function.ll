; ModuleID = 'bfs_module'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %set_zero_and_ret, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_loop_cond, label %set_zero_and_ret

set_zero_and_ret:
  store i64 0, i64* %out_len, align 8
  ret void

init_loop_cond:
  %i = phi i64 [ 0, %check_start ], [ %i.next, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %after_init

init_body:
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop_cond

after_init:
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %mem to i64*
  %queue_is_null = icmp eq i64* %queue, null
  br i1 %queue_is_null, label %set_zero_and_ret, label %alloc_ok

alloc_ok:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 0, i64* %out_len, align 8
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  br label %bfs_outer_cond

bfs_outer_cond:
  %head = phi i64 [ 0, %alloc_ok ], [ %head.next, %bfs_outer_body_end ]
  %tail = phi i64 [ 1, %alloc_ok ], [ %tail.after, %bfs_outer_body_end ]
  %have_items = icmp ult i64 %head, %tail
  br i1 %have_items, label %dequeue, label %free_and_ret

dequeue:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %old_len = load i64, i64* %out_len, align 8
  %new_len = add i64 %old_len, 1
  store i64 %new_len, i64* %out_len, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %old_len
  store i64 %u, i64* %order_slot, align 8
  br label %v_loop_cond

v_loop_cond:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %v_loop_continue ]
  %tail.iter = phi i64 [ %tail, %dequeue ], [ %tail.updated, %v_loop_continue ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %v_loop_body, label %bfs_outer_body_end

v_loop_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %v_no_enq, label %check_dist

check_dist:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %v_do_enq, label %v_no_enq

v_do_enq:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.iter
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.inc = add i64 %tail.iter, 1
  %v.next.yes = add i64 %v, 1
  br label %v_loop_continue

v_no_enq:
  %v.next.no = add i64 %v, 1
  br label %v_loop_continue

v_loop_continue:
  %v.next = phi i64 [ %v.next.no, %v_no_enq ], [ %v.next.yes, %v_do_enq ]
  %tail.updated = phi i64 [ %tail.iter, %v_no_enq ], [ %tail.inc, %v_do_enq ]
  br label %v_loop_cond

bfs_outer_body_end:
  %tail.after = phi i64 [ %tail.iter, %v_loop_cond ]
  br label %bfs_outer_cond

free_and_ret:
  %mem_i8 = bitcast i64* %queue to i8*
  call void @free(i8* %mem_i8)
  ret void
}