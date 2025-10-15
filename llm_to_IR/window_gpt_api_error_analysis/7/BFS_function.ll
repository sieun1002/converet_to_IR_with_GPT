; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %outOrder, i64* %outCount) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_loop, label %early_ret

early_ret:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop:
  %i = phi i64 [ 0, %check_start ], [ %i_next, %init_loop_body ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %init_loop_body, label %after_init

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:
  %bytes = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %bytes)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %early_ret, label %after_malloc

after_malloc:
  %queue = bitcast i8* %qraw to i64*
  %start_dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start_dist_ptr, align 4
  %zero0 = add i64 0, 0
  %queue_tail_ptr0 = getelementptr inbounds i64, i64* %queue, i64 %zero0
  store i64 %start, i64* %queue_tail_ptr0, align 8
  %tail_init = add i64 %zero0, 1
  store i64 0, i64* %outCount, align 8
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %after_malloc ], [ %head_next, %after_inner ]
  %tail = phi i64 [ %tail_init, %after_malloc ], [ %tail_after, %after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %process_item, label %done

process_item:
  %queue_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %x = load i64, i64* %queue_head_ptr, align 8
  %head_next = add i64 %head, 1
  %old_count = load i64, i64* %outCount, align 8
  %new_count = add i64 %old_count, 1
  store i64 %new_count, i64* %outCount, align 8
  %out_ptr = getelementptr inbounds i64, i64* %outOrder, i64 %old_count
  store i64 %x, i64* %out_ptr, align 8
  %dist_x_ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dist_x_val = load i32, i32* %dist_x_ptr, align 4
  %y_init = add i64 0, 0
  br label %inner_loop

inner_loop:
  %y = phi i64 [ %y_init, %process_item ], [ %y_next, %inner_continue ]
  %tail_in = phi i64 [ %tail, %process_item ], [ %tail_next, %inner_continue ]
  %y_cond = icmp ult i64 %y, %n
  br i1 %y_cond, label %inner_body, label %after_inner

inner_body:
  %mul = mul i64 %x, %n
  %idx = add i64 %mul, %y
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  %dist_y_ptr = getelementptr inbounds i32, i32* %dist, i64 %y
  %dist_y_val = load i32, i32* %dist_y_ptr, align 4
  %dist_y_unvisited = icmp eq i32 %dist_y_val, -1
  %do_enqueue = and i1 %adj_nonzero, %dist_y_unvisited
  br i1 %do_enqueue, label %enqueue, label %inner_continue

enqueue:
  %dist_x_plus1 = add i32 %dist_x_val, 1
  store i32 %dist_x_plus1, i32* %dist_y_ptr, align 4
  %queue_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_in
  store i64 %y, i64* %queue_tail_ptr, align 8
  %tail_inc = add i64 %tail_in, 1
  br label %inner_continue

inner_continue:
  %tail_next = phi i64 [ %tail_in, %inner_body ], [ %tail_inc, %enqueue ]
  %y_next = add i64 %y, 1
  br label %inner_loop

after_inner:
  %tail_after = phi i64 [ %tail_in, %inner_loop ]
  br label %outer_loop

done:
  %qraw2 = bitcast i64* %queue to i8*
  call void @free(i8* %qraw2)
  ret void
}