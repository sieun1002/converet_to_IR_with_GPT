; target: System V x86_64 Linux
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_nodes, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_loop, label %early_zero

early_zero:
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:
  br label %init_loop_cond

init_loop_cond:
  %i = phi i64 [ 0, %init_loop ], [ %i_next, %init_loop_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %alloc_queue

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %init_loop_cond

alloc_queue:
  %size_bytes = mul i64 %n, 8
  %malloc_raw = call i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %malloc_raw to i64*
  %malloc_is_null = icmp eq i8* %malloc_raw, null
  br i1 %malloc_is_null, label %early_zero, label %main_init

main_init:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %queue_tail0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %queue_tail0, align 8
  store i64 0, i64* %out_count, align 8
  br label %while_cond

while_cond:
  %head = phi i64 [ 0, %main_init ], [ %head_next, %inner_cond ]
  %tail = phi i64 [ 1, %main_init ], [ %tail_cur, %inner_cond ]
  %head_lt_tail = icmp ult i64 %head, %tail
  br i1 %head_lt_tail, label %while_body, label %while_end

while_body:
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head_next = add i64 %head, 1
  %idx_old = load i64, i64* %out_count, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out_nodes, i64 %idx_old
  store i64 %u, i64* %out_pos_ptr, align 8
  %idx_new = add i64 %idx_old, 1
  store i64 %idx_new, i64* %out_count, align 8
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du_ptr, align 4
  br label %inner_cond

inner_cond:
  %v = phi i64 [ 0, %while_body ], [ %v_next, %inner_end_if ]
  %tail_cur = phi i64 [ %tail, %while_body ], [ %tail_updated, %inner_end_if ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_body, label %while_cond

inner_body:
  %un = mul i64 %u, %n
  %idx_lin = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_lin
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_ok = icmp ne i32 %adj_val, 0
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv_ptr, align 4
  %unvisited = icmp eq i32 %dv, -1
  %both = and i1 %edge_ok, %unvisited
  br i1 %both, label %if_then, label %inner_end_if

if_then:
  %du_plus1 = add i32 %du, 1
  store i32 %du_plus1, i32* %dv_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_cur
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail_inc = add i64 %tail_cur, 1
  br label %inner_end_if

inner_end_if:
  %tail_updated = phi i64 [ %tail_cur, %inner_body ], [ %tail_inc, %if_then ]
  %v_next = add i64 %v, 1
  br label %inner_cond

while_end:
  %queue_cast = bitcast i64* %queue to i8*
  call void @free(i8* %queue_cast)
  ret void
}