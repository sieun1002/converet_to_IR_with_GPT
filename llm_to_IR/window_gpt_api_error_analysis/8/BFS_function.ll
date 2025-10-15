; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %s, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early, label %check_s

check_s:
  %cmp_s_ge_n = icmp uge i64 %s, %n
  br i1 %cmp_s_ge_n, label %early, label %init_loop

early:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop:
  br label %loop_init

loop_init:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %loop_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %loop_body, label %post_init

loop_body:
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr_i, align 4
  %i.next = add i64 %i, 1
  br label %loop_init

post_init:
  %n_bytes = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %n_bytes)
  %is_null = icmp eq i8* %malloc_ptr, null
  br i1 %is_null, label %early, label %init_queue

init_queue:
  %queue = bitcast i8* %malloc_ptr to i64*
  %dist_ptr_s = getelementptr inbounds i32, i32* %dist, i64 %s
  store i32 0, i32* %dist_ptr_s, align 4
  %qslot0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %s, i64* %qslot0, align 8
  store i64 0, i64* %outCount, align 8
  br label %bfs_loop

bfs_loop:
  %head = phi i64 [ 0, %init_queue ], [ %head_inc, %after_inner ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail_final, %after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done

dequeue:
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head_inc = add i64 %head, 1
  %oldcnt = load i64, i64* %outCount, align 8
  %out_idx_ptr = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %u, i64* %out_idx_ptr, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %outCount, align 8
  br label %inner_header

inner_header:
  %v = phi i64 [ 0, %dequeue ], [ %v_next, %inner_next ]
  %tail_cur = phi i64 [ %tail, %dequeue ], [ %tail_update, %inner_next ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner_body, label %after_inner

inner_body:
  %mul_un = mul i64 %u, %n
  %sum_idx = add i64 %mul_un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum_idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nz = icmp ne i32 %adj_val, 0
  br i1 %adj_nz, label %check_dist, label %inner_next

check_dist:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %enqueue, label %inner_next

enqueue:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %qpos_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_cur
  store i64 %v, i64* %qpos_ptr, align 8
  %tail_cur_inc = add i64 %tail_cur, 1
  br label %inner_next

inner_next:
  %tail_update = phi i64 [ %tail_cur, %inner_body ], [ %tail_cur, %check_dist ], [ %tail_cur_inc, %enqueue ]
  %v_next = add i64 %v, 1
  br label %inner_header

after_inner:
  %tail_final = phi i64 [ %tail_cur, %inner_header ]
  br label %bfs_loop

done:
  %free_ptr = bitcast i64* %queue to i8*
  call void @free(i8* %free_ptr)
  ret void
}