; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @bfs(i32* %graph, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %fail, label %check_start

check_start:
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %init_loop_entry, label %fail

fail:
  store i64 0, i64* %outCount, align 8
  br label %ret

init_loop_entry:
  br label %init_loop_header

init_loop_header:
  %i = phi i64 [ 0, %init_loop_entry ], [ %i.next, %init_loop_body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_loop_body, label %after_init_loop

init_loop_body:
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop_header

after_init_loop:
  %size = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %size)
  %block = bitcast i8* %qraw to i64*
  %isnull = icmp eq i8* %qraw, null
  br i1 %isnull, label %fail, label %queue_init

queue_init:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_tail_ptr0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %q_tail_ptr0, align 8
  store i64 0, i64* %outCount, align 8
  br label %bfs_loop_header

bfs_loop_header:
  %head = phi i64 [ 0, %queue_init ], [ %head.next, %loop_end_iter ]
  %tail = phi i64 [ 1, %queue_init ], [ %tail.next_from_body, %loop_end_iter ]
  %cond = icmp ult i64 %head, %tail
  br i1 %cond, label %loop_body, label %cleanup

loop_body:
  %u_ptr = getelementptr inbounds i64, i64* %block, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  %oldCount = load i64, i64* %outCount, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %outCount, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %oldCount
  store i64 %u, i64* %order_slot, align 8
  br label %neighbors_header

neighbors_header:
  %v = phi i64 [ 0, %loop_body ], [ %v.next, %neighbors_incr ]
  %tail.curr = phi i64 [ %tail, %loop_body ], [ %tail.updated, %neighbors_incr ]
  %vcond = icmp ult i64 %v, %n
  br i1 %vcond, label %neighbors_body, label %loop_end_iter

neighbors_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %g_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %g_val = load i32, i32* %g_ptr, align 4
  %g_nonzero = icmp ne i32 %g_val, 0
  br i1 %g_nonzero, label %check_unvisited, label %neighbors_incr

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %neighbors_incr

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %block, i64 %tail.curr
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.next2 = add i64 %tail.curr, 1
  br label %neighbors_incr

neighbors_incr:
  %tail.updated = phi i64 [ %tail.curr, %neighbors_body ], [ %tail.curr, %check_unvisited ], [ %tail.next2, %visit ]
  %v.next = add i64 %v, 1
  br label %neighbors_header

loop_end_iter:
  %tail.next_from_body = phi i64 [ %tail.curr, %neighbors_header ]
  br label %bfs_loop_header

cleanup:
  %block_i8 = bitcast i64* %block to i8*
  call void @free(i8* %block_i8)
  br label %ret

ret:
  ret void
}