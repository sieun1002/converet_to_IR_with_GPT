; ModuleID = 'bfs.ll'

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad_input = or i1 %n_is_zero, %start_ge_n
  br i1 %bad_input, label %early_ret, label %init_dist

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %init_loop.body ]
  %init_cond = icmp ult i64 %i, %n
  br i1 %init_cond, label %init_loop.body, label %after_init

init_loop.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  %size = shl i64 %n, 3
  %q_i8 = call noalias i8* @malloc(i64 %size)
  %q = bitcast i8* %q_i8 to i64*
  %q_null = icmp eq i64* %q, null
  br i1 %q_null, label %early_ret, label %post_alloc

post_alloc:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_tail_ptr0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q_tail_ptr0, align 8
  %tail.init = add i64 0, 1
  store i64 0, i64* %out_count, align 8
  br label %outer_cond

outer_cond:
  %head.phi = phi i64 [ 0, %post_alloc ], [ %head.next, %after_inner ]
  %tail.phi = phi i64 [ %tail.init, %post_alloc ], [ %tail.after, %after_inner ]
  %has_items = icmp ult i64 %head.phi, %tail.phi
  br i1 %has_items, label %outer_body, label %done

outer_body:
  %q_head_ptr = getelementptr inbounds i64, i64* %q, i64 %head.phi
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head.phi, 1
  %count0 = load i64, i64* %out_count, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_count, align 8
  %order_ptr = getelementptr inbounds i64, i64* %order, i64 %count0
  store i64 %u, i64* %order_ptr, align 8
  br label %inner_cond

inner_cond:
  %v.phi = phi i64 [ 0, %outer_body ], [ %v.next, %inner_inc ]
  %tail.inner = phi i64 [ %tail.phi, %outer_body ], [ %tail.updated, %inner_inc ]
  %v_lt_n = icmp ult i64 %v.phi, %n
  br i1 %v_lt_n, label %inner_body, label %after_inner

inner_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v.phi
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj_val, 0
  br i1 %is_zero, label %inner_inc, label %check_dist

check_dist:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v.phi
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %inner_inc

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.inner
  store i64 %v.phi, i64* %q_tail_ptr, align 8
  %tail.next = add i64 %tail.inner, 1
  br label %inner_inc

inner_inc:
  %tail.updated = phi i64 [ %tail.inner, %inner_body ], [ %tail.inner, %check_dist ], [ %tail.next, %visit ]
  %v.next = add i64 %v.phi, 1
  br label %inner_cond

after_inner:
  %tail.after = phi i64 [ %tail.inner, %inner_cond ]
  br label %outer_cond

done:
  %q_i8_2 = bitcast i64* %q to i8*
  call void @free(i8* %q_i8_2)
  ret void
}