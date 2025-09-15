; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/BFS_function.ll"
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmp_n0 = icmp ne i64 %n, 0
  %cmp_start = icmp ult i64 %start, %n
  %or.cond = select i1 %cmp_n0, i1 %cmp_start, i1 false
  br i1 %or.cond, label %init_loop.cond, label %early_ret

common.ret:                                       ; preds = %exit, %malloc_fail, %early_ret
  ret void

early_ret:                                        ; preds = %entry
  store i64 0, i64* %outCount, align 8
  br label %common.ret

init_loop.cond:                                   ; preds = %entry, %init_loop.body
  %i = phi i64 [ %i.next, %init_loop.body ], [ 0, %entry ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_loop.body, label %alloc_queue

init_loop.body:                                   ; preds = %init_loop.cond
  %gep_dist_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep_dist_i, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.cond

alloc_queue:                                      ; preds = %init_loop.cond
  %size_elems = shl i64 %n, 3
  %qraw = call noalias i8* @malloc(i64 %size_elems)
  %queue = bitcast i8* %qraw to i64*
  %isnull = icmp eq i8* %qraw, null
  br i1 %isnull, label %malloc_fail, label %bfs_init

malloc_fail:                                      ; preds = %alloc_queue
  store i64 0, i64* %outCount, align 8
  br label %common.ret

bfs_init:                                         ; preds = %alloc_queue
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %inner_cond, %bfs_init
  %head.phi = phi i64 [ 0, %bfs_init ], [ %head.next, %inner_cond ]
  %tail.phi = phi i64 [ 1, %bfs_init ], [ %tail.inner, %inner_cond ]
  %cmp_ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp_ht, label %outer_body, label %exit

outer_body:                                       ; preds = %outer_cond
  %qhead.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.phi
  %x = load i64, i64* %qhead.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %count0 = load i64, i64* %outCount, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %outCount, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %x, i64* %out.ptr, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %inner_latch, %outer_body
  %i2 = phi i64 [ 0, %outer_body ], [ %i2.next, %inner_latch ]
  %tail.inner = phi i64 [ %tail.phi, %outer_body ], [ %tail.next, %inner_latch ]
  %cond_i2 = icmp ult i64 %i2, %n
  br i1 %cond_i2, label %inner_body, label %outer_cond

inner_body:                                       ; preds = %inner_cond
  %xn = mul i64 %x, %n
  %idx = add i64 %xn, %i2
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.iszero = icmp eq i32 %adj.val, 0
  br i1 %adj.iszero, label %inner_latch, label %check_unvisited

check_unvisited:                                  ; preds = %inner_body
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i2
  %dist_i_val = load i32, i32* %dist_i_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_i_val, -1
  br i1 %is_unvisited, label %visit, label %inner_latch

visit:                                            ; preds = %check_unvisited
  %dist_x_ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dist_x_val = load i32, i32* %dist_x_ptr, align 4
  %dist_x_plus1 = add i32 %dist_x_val, 1
  store i32 %dist_x_plus1, i32* %dist_i_ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.inner
  store i64 %i2, i64* %qtail.ptr, align 8
  %tail.next.visit = add i64 %tail.inner, 1
  br label %inner_latch

inner_latch:                                      ; preds = %inner_body, %check_unvisited, %visit
  %tail.next = phi i64 [ %tail.next.visit, %visit ], [ %tail.inner, %check_unvisited ], [ %tail.inner, %inner_body ]
  %i2.next = add i64 %i2, 1
  br label %inner_cond

exit:                                             ; preds = %outer_cond
  call void @free(i8* %qraw)
  br label %common.ret
}
