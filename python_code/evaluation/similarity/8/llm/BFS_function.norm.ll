; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/BFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %countPtr) {
entry:
  %cmp_start_ge_n.not = icmp ult i64 %start, %n
  br i1 %cmp_start_ge_n.not, label %init_loop_test, label %early

common.ret:                                       ; preds = %done, %early2, %early
  ret void

early:                                            ; preds = %entry
  store i64 0, i64* %countPtr, align 8
  br label %common.ret

init_loop_test:                                   ; preds = %entry, %init_loop_body
  %init_i.0 = phi i64 [ %i_next, %init_loop_body ], [ 0, %entry ]
  %i_lt_n = icmp ult i64 %init_i.0, %n
  br i1 %i_lt_n, label %init_loop_body, label %post_init

init_loop_body:                                   ; preds = %init_loop_test
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %init_i.0
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %init_i.0, 1
  br label %init_loop_test

post_init:                                        ; preds = %init_loop_test
  %n_bytes = shl i64 %n, 3
  %raw = call i8* @malloc(i64 %n_bytes)
  %queue_cast = bitcast i8* %raw to i64*
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %early2, label %after_alloc

early2:                                           ; preds = %post_init
  store i64 0, i64* %countPtr, align 8
  br label %common.ret

after_alloc:                                      ; preds = %post_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %queue_cast, align 8
  store i64 0, i64* %countPtr, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %inner_cond, %after_alloc
  %tail.0 = phi i64 [ 1, %after_alloc ], [ %tail.1, %inner_cond ]
  %head.0 = phi i64 [ 0, %after_alloc ], [ %head_inc, %inner_cond ]
  %has_items = icmp ult i64 %head.0, %tail.0
  br i1 %has_items, label %dequeue, label %done

dequeue:                                          ; preds = %outer_cond
  %u_ptr = getelementptr inbounds i64, i64* %queue_cast, i64 %head.0
  %uval = load i64, i64* %u_ptr, align 8
  %head_inc = add i64 %head.0, 1
  %oldCount = load i64, i64* %countPtr, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %countPtr, align 8
  %out_elem_ptr = getelementptr inbounds i64, i64* %out, i64 %oldCount
  store i64 %uval, i64* %out_elem_ptr, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %inner_incr, %dequeue
  %tail.1 = phi i64 [ %tail.0, %dequeue ], [ %tail.2, %inner_incr ]
  %v.0 = phi i64 [ 0, %dequeue ], [ %v_next, %inner_incr ]
  %v_lt_n = icmp ult i64 %v.0, %n
  br i1 %v_lt_n, label %inner_body, label %outer_cond

inner_body:                                       ; preds = %inner_cond
  %prod = mul i64 %uval, %n
  %sum = add i64 %prod, %v.0
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge_val = load i32, i32* %adj_ptr, align 4
  %has_edge.not = icmp eq i32 %edge_val, 0
  br i1 %has_edge.not, label %inner_incr, label %check_unseen

check_unseen:                                     ; preds = %inner_body
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v.0
  %dist_v_val = load i32, i32* %dist_v_ptr, align 4
  %is_neg1 = icmp eq i32 %dist_v_val, -1
  br i1 %is_neg1, label %relax, label %inner_incr

relax:                                            ; preds = %check_unseen
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %uval
  %dist_u_val = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus = add i32 %dist_u_val, 1
  store i32 %dist_u_plus, i32* %dist_v_ptr, align 4
  %tail_inc2 = add i64 %tail.1, 1
  %enq_ptr = getelementptr inbounds i64, i64* %queue_cast, i64 %tail.1
  store i64 %v.0, i64* %enq_ptr, align 8
  br label %inner_incr

inner_incr:                                       ; preds = %relax, %check_unseen, %inner_body
  %tail.2 = phi i64 [ %tail_inc2, %relax ], [ %tail.1, %check_unseen ], [ %tail.1, %inner_body ]
  %v_next = add i64 %v.0, 1
  br label %inner_cond

done:                                             ; preds = %outer_cond
  call void @free(i8* %raw)
  br label %common.ret
}
