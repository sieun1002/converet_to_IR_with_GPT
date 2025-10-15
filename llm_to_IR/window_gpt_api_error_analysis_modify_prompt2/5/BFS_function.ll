; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %order_len) {
entry:
  %block = alloca i64*, align 8
  %v8 = alloca i64, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %cur = alloca i64, align 8
  %i = alloca i64, align 8
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early, label %check_start

check_start:                                         ; preds = %entry
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_dist_loop, label %early

init_dist_loop:                                      ; preds = %check_start
  store i64 0, i64* %v8, align 8
  br label %init_dist_cond

init_dist_cond:                                      ; preds = %init_dist_body, %init_dist_loop
  %v8val = load i64, i64* %v8, align 8
  %v8_lt_n = icmp ult i64 %v8val, %n
  br i1 %v8_lt_n, label %init_dist_body, label %after_init_dist

init_dist_body:                                      ; preds = %init_dist_cond
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %v8val
  store i32 -1, i32* %dist_ptr, align 4
  %v8inc = add i64 %v8val, 1
  store i64 %v8inc, i64* %v8, align 8
  br label %init_dist_cond

after_init_dist:                                     ; preds = %init_dist_cond
  %size_bytes = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %size_bytes)
  %qcast = bitcast i8* %malloc_ptr to i64*
  store i64* %qcast, i64** %block, align 8
  %isnull = icmp eq i64* %qcast, null
  br i1 %isnull, label %early, label %after_alloc

after_alloc:                                         ; preds = %after_init_dist
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %tail_old0 = load i64, i64* %tail, align 8
  %tail_new0 = add i64 %tail_old0, 1
  store i64 %tail_new0, i64* %tail, align 8
  %qptr0 = load i64*, i64** %block, align 8
  %qslot0 = getelementptr inbounds i64, i64* %qptr0, i64 %tail_old0
  store i64 %start, i64* %qslot0, align 8
  store i64 0, i64* %order_len, align 8
  br label %outer_cond

outer_cond:                                          ; preds = %inner_cond, %after_alloc
  %headv = load i64, i64* %head, align 8
  %tailv = load i64, i64* %tail, align 8
  %has_items = icmp ult i64 %headv, %tailv
  br i1 %has_items, label %dequeue, label %finish

dequeue:                                             ; preds = %outer_cond
  %oldhead = load i64, i64* %head, align 8
  %newhead = add i64 %oldhead, 1
  store i64 %newhead, i64* %head, align 8
  %qptr1 = load i64*, i64** %block, align 8
  %qslot1 = getelementptr inbounds i64, i64* %qptr1, i64 %oldhead
  %curv = load i64, i64* %qslot1, align 8
  store i64 %curv, i64* %cur, align 8
  %len_old = load i64, i64* %order_len, align 8
  %len_new = add i64 %len_old, 1
  store i64 %len_new, i64* %order_len, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %len_old
  %cur_loaded = load i64, i64* %cur, align 8
  store i64 %cur_loaded, i64* %order_slot, align 8
  store i64 0, i64* %i, align 8
  br label %inner_cond

inner_cond:                                          ; preds = %inner_inc, %dequeue
  %ival = load i64, i64* %i, align 8
  %i_lt_n = icmp ult i64 %ival, %n
  br i1 %i_lt_n, label %inner_body, label %outer_cond

inner_body:                                          ; preds = %inner_cond
  %cur2 = load i64, i64* %cur, align 8
  %mulidx = mul i64 %cur2, %n
  %idx = add i64 %mulidx, %ival
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_ptr, align 4
  %edge_is_zero = icmp eq i32 %edge, 0
  br i1 %edge_is_zero, label %inner_inc, label %check_visited

check_visited:                                       ; preds = %inner_body
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %ival
  %dist_i = load i32, i32* %dist_i_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_i, -1
  br i1 %is_unvisited, label %visit_neighbor, label %inner_inc

visit_neighbor:                                      ; preds = %check_visited
  %dist_cur_ptr = getelementptr inbounds i32, i32* %dist, i64 %cur2
  %dist_cur = load i32, i32* %dist_cur_ptr, align 4
  %dist_plus1 = add i32 %dist_cur, 1
  store i32 %dist_plus1, i32* %dist_i_ptr, align 4
  %tail_old1 = load i64, i64* %tail, align 8
  %tail_new1 = add i64 %tail_old1, 1
  store i64 %tail_new1, i64* %tail, align 8
  %qptr2 = load i64*, i64** %block, align 8
  %qslot2 = getelementptr inbounds i64, i64* %qptr2, i64 %tail_old1
  store i64 %ival, i64* %qslot2, align 8
  br label %inner_inc

inner_inc:                                           ; preds = %visit_neighbor, %check_visited, %inner_body
  %ival2 = load i64, i64* %i, align 8
  %ival_next = add i64 %ival2, 1
  store i64 %ival_next, i64* %i, align 8
  br label %inner_cond

finish:                                              ; preds = %outer_cond
  %qptr_end = load i64*, i64** %block, align 8
  %qraw_end = bitcast i64* %qptr_end to i8*
  call void @free(i8* %qraw_end)
  br label %epilogue

early:                                               ; preds = %after_init_dist, %check_start, %entry
  store i64 0, i64* %order_len, align 8
  br label %epilogue

epilogue:                                            ; preds = %early, %finish
  ret void
}