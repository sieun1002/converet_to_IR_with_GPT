; ModuleID = 'bfs_module'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %early_ret, label %check_start

check_start:
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %init_loop.entry, label %early_ret

early_ret:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop.entry:
  br label %init_loop.cond

init_loop.cond:
  %i = phi i64 [ 0, %init_loop.entry ], [ %i.next, %init_loop.body ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_loop.body, label %alloc_queue

init_loop.body:
  %gep_dist_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep_dist_i, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.cond

alloc_queue:
  %size_elems = shl i64 %n, 3
  %qraw = call noalias i8* @malloc(i64 %size_elems)
  %queue = bitcast i8* %qraw to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %malloc_fail, label %bfs_init

malloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

bfs_init:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %qpos0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %qpos0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_cond

outer_cond:
  %head.phi = phi i64 [ 0, %bfs_init ], [ %head.next, %after_inner ]
  %tail.phi = phi i64 [ 1, %bfs_init ], [ %tail.inner, %after_inner ]
  %cmp_ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp_ht, label %outer_body, label %exit

outer_body:
  %qhead.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.phi
  %x = load i64, i64* %qhead.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %count0 = load i64, i64* %outCount, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %outCount, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %x, i64* %out.ptr, align 8
  br label %inner_cond

inner_cond:
  %i2 = phi i64 [ 0, %outer_body ], [ %i2.next, %inner_latch ]
  %tail.inner = phi i64 [ %tail.phi, %outer_body ], [ %tail.next, %inner_latch ]
  %cond_i2 = icmp ult i64 %i2, %n
  br i1 %cond_i2, label %inner_body, label %after_inner

inner_body:
  %xn = mul i64 %x, %n
  %idx = add i64 %xn, %i2
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.iszero = icmp eq i32 %adj.val, 0
  br i1 %adj.iszero, label %inner_skip, label %check_unvisited

check_unvisited:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i2
  %dist_i_val = load i32, i32* %dist_i_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_i_val, -1
  br i1 %is_unvisited, label %visit, label %inner_skip

visit:
  %dist_x_ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dist_x_val = load i32, i32* %dist_x_ptr, align 4
  %dist_x_plus1 = add i32 %dist_x_val, 1
  store i32 %dist_x_plus1, i32* %dist_i_ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.inner
  store i64 %i2, i64* %qtail.ptr, align 8
  %tail.next.visit = add i64 %tail.inner, 1
  br label %inner_latch

inner_skip:
  br label %inner_latch

inner_latch:
  %tail.next = phi i64 [ %tail.next.visit, %visit ], [ %tail.inner, %inner_skip ]
  %i2.next = add i64 %i2, 1
  br label %inner_cond

after_inner:
  br label %outer_cond

exit:
  %queue.cast = bitcast i64* %queue to i8*
  call void @free(i8* %queue.cast)
  ret void
}