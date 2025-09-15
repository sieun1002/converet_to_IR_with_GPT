; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/DFS_main.ll"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %outSeq, i64* %outCount) {
entry:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %early

common.ret:                                       ; preds = %cleanup, %alloc_fail, %early
  ret void

early:                                            ; preds = %entry
  store i64 0, i64* %outCount, align 8
  br label %common.ret

alloc:                                            ; preds = %entry
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call i8* @malloc(i64 %size_vis)
  %p_vis = bitcast i8* %p_vis_i8 to i32*
  %size_next = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size_next)
  %p_next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size_next)
  %p_stack = bitcast i8* %p_stack_i8 to i64*
  %vis_ok = icmp ne i8* %p_vis_i8, null
  %next_ok = icmp ne i8* %p_next_i8, null
  %stack_ok = icmp ne i8* %p_stack_i8, null
  %tmp_all1 = and i1 %vis_ok, %next_ok
  %all_ok = and i1 %tmp_all1, %stack_ok
  br i1 %all_ok, label %init_loop_header, label %alloc_fail

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %outCount, align 8
  br label %common.ret

init_loop_header:                                 ; preds = %alloc, %init_body
  %i = phi i64 [ %i.next, %init_body ], [ 0, %alloc ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_body, label %post_init

init_body:                                        ; preds = %init_loop_header
  %vis_ptr_i = getelementptr inbounds i32, i32* %p_vis, i64 %i
  store i32 0, i32* %vis_ptr_i, align 4
  %next_ptr_i = getelementptr inbounds i64, i64* %p_next, i64 %i
  store i64 0, i64* %next_ptr_i, align 8
  %i.next = add i64 %i, 1
  br label %init_loop_header

post_init:                                        ; preds = %init_loop_header
  store i64 0, i64* %outCount, align 8
  store i64 %start, i64* %p_stack, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %p_vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %count0 = load i64, i64* %outCount, align 8
  %outseq_slot0 = getelementptr inbounds i64, i64* %outSeq, i64 %count0
  store i64 %start, i64* %outseq_slot0, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %outCount, align 8
  br label %main_loop_header

main_loop_header:                                 ; preds = %main_iter_end, %post_init
  %stack_size = phi i64 [ 1, %post_init ], [ %stack_size_after_iter, %main_iter_end ]
  %stack_nonzero.not = icmp eq i64 %stack_size, 0
  br i1 %stack_nonzero.not, label %cleanup, label %main_iter_begin

main_iter_begin:                                  ; preds = %main_loop_header
  %idx_top = add i64 %stack_size, -1
  %ptr_top = getelementptr inbounds i64, i64* %p_stack, i64 %idx_top
  %u = load i64, i64* %ptr_top, align 8
  %next_ptr_u = getelementptr inbounds i64, i64* %p_next, i64 %u
  %v0 = load i64, i64* %next_ptr_u, align 8
  br label %inner_header

inner_header:                                     ; preds = %inner_body_end, %main_iter_begin
  %v_curr = phi i64 [ %v0, %main_iter_begin ], [ %v_next, %inner_body_end ]
  %v_lt_n = icmp ult i64 %v_curr, %n
  br i1 %v_lt_n, label %inner_body_check_edge, label %finished_neighbors

inner_body_check_edge:                            ; preds = %inner_header
  %mul = mul i64 %u, %n
  %sum = add i64 %mul, %v_curr
  %adj_idx_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge_val = load i32, i32* %adj_idx_ptr, align 4
  %edge_nonzero.not = icmp eq i32 %edge_val, 0
  br i1 %edge_nonzero.not, label %inner_body_end, label %check_unvisited

check_unvisited:                                  ; preds = %inner_body_check_edge
  %vis_ptr_v = getelementptr inbounds i32, i32* %p_vis, i64 %v_curr
  %vis_v = load i32, i32* %vis_ptr_v, align 4
  %is_unvisited = icmp eq i32 %vis_v, 0
  br i1 %is_unvisited, label %visit_neighbor, label %inner_body_end

visit_neighbor:                                   ; preds = %check_unvisited
  %v_plus1 = add i64 %v_curr, 1
  store i64 %v_plus1, i64* %next_ptr_u, align 8
  store i32 1, i32* %vis_ptr_v, align 4
  %stack_slot_push = getelementptr inbounds i64, i64* %p_stack, i64 %stack_size
  store i64 %v_curr, i64* %stack_slot_push, align 8
  %stack_size_inc = add i64 %stack_size, 1
  %count_before = load i64, i64* %outCount, align 8
  %outseq_slot = getelementptr inbounds i64, i64* %outSeq, i64 %count_before
  store i64 %v_curr, i64* %outseq_slot, align 8
  %count_after = add i64 %count_before, 1
  store i64 %count_after, i64* %outCount, align 8
  br label %main_iter_end

inner_body_end:                                   ; preds = %inner_body_check_edge, %check_unvisited
  %v_next = add i64 %v_curr, 1
  br label %inner_header

finished_neighbors:                               ; preds = %inner_header
  br label %main_iter_end

main_iter_end:                                    ; preds = %finished_neighbors, %visit_neighbor
  %stack_size_after_iter = phi i64 [ %stack_size_inc, %visit_neighbor ], [ %idx_top, %finished_neighbors ]
  br label %main_loop_header

cleanup:                                          ; preds = %main_loop_header
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  br label %common.ret
}
