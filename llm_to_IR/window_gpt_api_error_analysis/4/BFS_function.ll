; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport noalias i8* @malloc(i64)
declare dllimport void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %count, align 8
  ret void

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero2, label %init_dist_loop

early_zero2:
  store i64 0, i64* %count, align 8
  ret void

init_dist_loop:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist_loop ], [ %i.next, %dist_loop_body_end ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %dist_loop_body, label %after_dist_loop

dist_loop_body:
  %dist_elem_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_elem_ptr, align 4
  br label %dist_loop_body_end

dist_loop_body_end:
  %i.next = add i64 %i, 1
  br label %dist_loop

after_dist_loop:
  %size_bytes = shl i64 %n, 3
  %queue_i8 = call noalias i8* @malloc(i64 %size_bytes)
  %queue_null = icmp eq i8* %queue_i8, null
  br i1 %queue_null, label %early_zero3, label %queue_ok

early_zero3:
  store i64 0, i64* %count, align 8
  ret void

queue_ok:
  %queue = bitcast i8* %queue_i8 to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %count, align 8
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %queue_ok ], [ %head.next, %after_inner_loop ]
  %tail = phi i64 [ 1, %queue_ok ], [ %tail.next_from_inner, %after_inner_loop ]
  %cmp_ht = icmp ult i64 %head, %tail
  br i1 %cmp_ht, label %dequeue, label %done

dequeue:
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  %old_count_val = load i64, i64* %count, align 8
  %new_count = add i64 %old_count_val, 1
  store i64 %new_count, i64* %count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %old_count_val
  store i64 %u, i64* %out_slot, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_body_end ]
  %tail_inner = phi i64 [ %tail, %dequeue ], [ %tail.next, %inner_body_end ]
  %cmp_v = icmp ult i64 %v, %n
  br i1 %cmp_v, label %inner_body, label %after_inner_loop

inner_body:
  %u_times_n = mul i64 %u, %n
  %index = add i64 %u_times_n, %v
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %index
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %edge = icmp ne i32 %adj_val, 0
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %unvisited = icmp eq i32 %dist_v, -1
  %cond_visit = and i1 %edge, %unvisited
  br i1 %cond_visit, label %visit_neighbor, label %inner_body_end

visit_neighbor:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %enqueue_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_inner
  store i64 %v, i64* %enqueue_ptr, align 8
  %tail.next = add i64 %tail_inner, 1
  br label %inner_body_end

inner_body_end:
  %tail.updated.ph = phi i64 [ %tail_inner, %inner_body ], [ %tail.next, %visit_neighbor ]
  %v.next = add i64 %v, 1
  br label %inner_loop

after_inner_loop:
  %tail.next_from_inner = phi i64 [ %tail_inner, %inner_loop ]
  br label %outer_loop

done:
  %queue_i8_cast = bitcast i64* %queue to i8*
  call void @free(i8* %queue_i8_cast)
  ret void
}