; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/BFS_function.ll"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp ne i64 %n, 0
  %src_in_range = icmp ult i64 %src, %n
  %or.cond = select i1 %n_is_zero, i1 %src_in_range, i1 false
  br i1 %or.cond, label %init_loop.header, label %ret_zero

common.ret:                                       ; preds = %exit, %ret_zero
  ret void

ret_zero:                                         ; preds = %post_init, %entry
  store i64 0, i64* %out_len, align 4
  br label %common.ret

init_loop.header:                                 ; preds = %entry, %init_loop.body
  %i = phi i64 [ %i.next, %init_loop.body ], [ 0, %entry ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop.body, label %post_init

init_loop.body:                                   ; preds = %init_loop.header
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.header

post_init:                                        ; preds = %init_loop.header
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %mem_null = icmp eq i8* %mem, null
  br i1 %mem_null, label %ret_zero, label %init_queue

init_queue:                                       ; preds = %post_init
  %q = bitcast i8* %mem to i64*
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr, align 4
  store i64 %src, i64* %q, align 4
  store i64 0, i64* %out_len, align 4
  br label %outer.header

outer.header:                                     ; preds = %inner.header, %init_queue
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %inner.header ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.cur, %inner.header ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.header
  %q_u_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_u_ptr, align 4
  %head.next = add i64 %head, 1
  %len_old = load i64, i64* %out_len, align 4
  %len_new = add i64 %len_old, 1
  store i64 %len_new, i64* %out_len, align 4
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len_old
  store i64 %u, i64* %out_slot, align 4
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %outer.body
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.latch ]
  %tail.cur = phi i64 [ %tail, %outer.body ], [ %tail.next, %inner.latch ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.check_adj, label %outer.header

inner.check_adj:                                  ; preds = %inner.header
  %mul_un = mul i64 %u, %n
  %idx_mat = add i64 %mul_un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_mat
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %inner.latch, label %inner.check_visit

inner.check_visit:                                ; preds = %inner.check_adj
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %inner.latch

visit:                                            ; preds = %inner.check_visit
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr, align 4
  %tail.enq = add i64 %tail.cur, 1
  br label %inner.latch

inner.latch:                                      ; preds = %inner.check_adj, %inner.check_visit, %visit
  %tail.next = phi i64 [ %tail.enq, %visit ], [ %tail.cur, %inner.check_visit ], [ %tail.cur, %inner.check_adj ]
  %v.next = add i64 %v, 1
  br label %inner.header

exit:                                             ; preds = %outer.header
  call void @free(i8* %mem)
  br label %common.ret
}
