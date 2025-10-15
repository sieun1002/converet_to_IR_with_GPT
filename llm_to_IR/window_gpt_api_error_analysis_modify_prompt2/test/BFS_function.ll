target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_loop, label %early

early:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop:
  %i = phi i64 [ 0, %check_start ], [ %i.next, %init_loop ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_body, label %post_init

init_body:
  %dist_i_ptr = getelementptr i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  %size_bytes = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %size_bytes)
  %block = bitcast i8* %mem to i64*
  %isnull = icmp eq i64* %block, null
  br i1 %isnull, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

after_malloc:
  %dist_start_ptr = getelementptr i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %block_tail0_ptr = getelementptr i64, i64* %block, i64 0
  store i64 %start, i64* %block_tail0_ptr, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_loop

outer_loop:
  %head.phi = phi i64 [ 0, %after_malloc ], [ %head.inc, %inner_post ]
  %tail.phi = phi i64 [ 1, %after_malloc ], [ %tail.exit, %inner_post ]
  %not_empty = icmp ult i64 %head.phi, %tail.phi
  br i1 %not_empty, label %dequeue, label %done

dequeue:
  %block_head_ptr = getelementptr i64, i64* %block, i64 %head.phi
  %u = load i64, i64* %block_head_ptr, align 8
  %head.inc = add i64 %head.phi, 1
  %oldCount = load i64, i64* %outCount, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %outCount, align 8
  %order_slot = getelementptr i64, i64* %order, i64 %oldCount
  store i64 %u, i64* %order_slot, align 8
  br label %inner_loop

inner_loop:
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %inner_continue ]
  %tail.cur = phi i64 [ %tail.phi, %dequeue ], [ %tail.updated, %inner_continue ]
  %cond_j = icmp ult i64 %j, %n
  br i1 %cond_j, label %inner_body, label %inner_post

inner_body:
  %u_times_n = mul i64 %u, %n
  %idx = add i64 %u_times_n, %j
  %adj_ptr = getelementptr i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  br i1 %adj_nonzero, label %check_unvisited, label %inner_continue_noenq

check_unvisited:
  %dist_j_ptr = getelementptr i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_j, -1
  br i1 %is_unvisited, label %visit, label %inner_continue_noenq

visit:
  %dist_u_ptr = getelementptr i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_j_ptr, align 4
  %block_tail_ptr = getelementptr i64, i64* %block, i64 %tail.cur
  store i64 %j, i64* %block_tail_ptr, align 8
  %tail.enq = add i64 %tail.cur, 1
  br label %inner_continue_enq

inner_continue_noenq:
  br label %inner_continue

inner_continue_enq:
  br label %inner_continue

inner_continue:
  %tail.updated = phi i64 [ %tail.cur, %inner_continue_noenq ], [ %tail.enq, %inner_continue_enq ]
  %j.next = add i64 %j, 1
  br label %inner_loop

inner_post:
  %tail.exit = phi i64 [ %tail.cur, %inner_loop ]
  br label %outer_loop

done:
  %block.bc = bitcast i64* %block to i8*
  call void @free(i8* %block.bc)
  ret void
}