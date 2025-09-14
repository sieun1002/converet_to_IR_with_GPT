; ModuleID = 'bfs'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %countPtr) {
entry:
  %queue = alloca i64*, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %u = alloca i64, align 8
  %init_i = alloca i64, align 8
  %v = alloca i64, align 8
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %bad_or = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %bad_or, label %early, label %init_loop

early:
  store i64 0, i64* %countPtr, align 8
  ret void

init_loop:
  store i64 0, i64* %init_i, align 8
  br label %init_loop_test

init_loop_test:
  %i_val = load i64, i64* %init_i, align 8
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %init_loop_body, label %post_init

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i_val
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %init_i, align 8
  br label %init_loop_test

post_init:
  %n_bytes = shl i64 %n, 3
  %raw = call i8* @malloc(i64 %n_bytes)
  %queue_cast = bitcast i8* %raw to i64*
  store i64* %queue_cast, i64** %queue, align 8
  %isnull = icmp eq i64* %queue_cast, null
  br i1 %isnull, label %early2, label %after_alloc

early2:
  store i64 0, i64* %countPtr, align 8
  ret void

after_alloc:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %tail_inc1 = add i64 %tail0, 1
  store i64 %tail_inc1, i64* %tail, align 8
  %queue_base = load i64*, i64** %queue, align 8
  %enq0_ptr = getelementptr inbounds i64, i64* %queue_base, i64 %tail0
  store i64 %start, i64* %enq0_ptr, align 8
  store i64 0, i64* %countPtr, align 8
  br label %outer_cond

outer_cond:
  %head_val = load i64, i64* %head, align 8
  %tail_val = load i64, i64* %tail, align 8
  %has_items = icmp ult i64 %head_val, %tail_val
  br i1 %has_items, label %dequeue, label %done

dequeue:
  %queue_base2 = load i64*, i64** %queue, align 8
  %u_ptr = getelementptr inbounds i64, i64* %queue_base2, i64 %head_val
  %uval = load i64, i64* %u_ptr, align 8
  store i64 %uval, i64* %u, align 8
  %head_inc = add i64 %head_val, 1
  store i64 %head_inc, i64* %head, align 8
  %oldCount = load i64, i64* %countPtr, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %countPtr, align 8
  %out_elem_ptr = getelementptr inbounds i64, i64* %out, i64 %oldCount
  store i64 %uval, i64* %out_elem_ptr, align 8
  store i64 0, i64* %v, align 8
  br label %inner_cond

inner_cond:
  %vval = load i64, i64* %v, align 8
  %v_lt_n = icmp ult i64 %vval, %n
  br i1 %v_lt_n, label %inner_body, label %outer_cond

inner_body:
  %u_load = load i64, i64* %u, align 8
  %prod = mul i64 %u_load, %n
  %sum = add i64 %prod, %vval
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge_val = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %edge_val, 0
  br i1 %has_edge, label %check_unseen, label %inner_incr

check_unseen:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %vval
  %dist_v_val = load i32, i32* %dist_v_ptr, align 4
  %is_neg1 = icmp eq i32 %dist_v_val, -1
  br i1 %is_neg1, label %relax, label %inner_incr

relax:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u_load
  %dist_u_val = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus = add i32 %dist_u_val, 1
  store i32 %dist_u_plus, i32* %dist_v_ptr, align 4
  %tail_val2 = load i64, i64* %tail, align 8
  %tail_inc2 = add i64 %tail_val2, 1
  store i64 %tail_inc2, i64* %tail, align 8
  %queue_base3 = load i64*, i64** %queue, align 8
  %enq_ptr = getelementptr inbounds i64, i64* %queue_base3, i64 %tail_val2
  store i64 %vval, i64* %enq_ptr, align 8
  br label %inner_incr

inner_incr:
  %v_next = add i64 %vval, 1
  store i64 %v_next, i64* %v, align 8
  br label %inner_cond

done:
  %queue_base4 = load i64*, i64** %queue, align 8
  %queue_i8 = bitcast i64* %queue_base4 to i8*
  call void @free(i8* %queue_i8)
  ret void
}