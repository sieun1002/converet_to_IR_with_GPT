; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64) local_unnamed_addr

declare void @free(i8*) local_unnamed_addr

define void @dfs(i32* nocapture readonly %matrix, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %countp) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

common.ret:                                       ; preds = %cleanup, %after_free_all, %early_zero2, %early_zero
  ret void

early_zero:                                       ; preds = %entry
  store i64 0, i64* %countp, align 8
  br label %common.ret

check_start:                                      ; preds = %entry
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %alloc, label %early_zero2

early_zero2:                                      ; preds = %check_start
  store i64 0, i64* %countp, align 8
  br label %common.ret

alloc:                                            ; preds = %check_start
  %size_vis = shl i64 %n, 2
  %raw_vis = call i8* @malloc(i64 %size_vis)
  %vis = bitcast i8* %raw_vis to i32*
  %size64 = shl i64 %n, 3
  %raw_next = call i8* @malloc(i64 %size64)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i8* %raw_vis, null
  %next_null = icmp eq i8* %raw_next, null
  %stack_null = icmp eq i8* %raw_stack, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %malloc_fail, label %init_header

malloc_fail:                                      ; preds = %alloc
  br i1 %vis_null, label %skip_free_vis, label %free_vis

free_vis:                                         ; preds = %malloc_fail
  call void @free(i8* %raw_vis)
  br label %skip_free_vis

skip_free_vis:                                    ; preds = %free_vis, %malloc_fail
  br i1 %next_null, label %skip_free_next, label %free_next

free_next:                                        ; preds = %skip_free_vis
  call void @free(i8* %raw_next)
  br label %skip_free_next

skip_free_next:                                   ; preds = %free_next, %skip_free_vis
  br i1 %stack_null, label %after_free_all, label %free_stack

free_stack:                                       ; preds = %skip_free_next
  call void @free(i8* %raw_stack)
  br label %after_free_all

after_free_all:                                   ; preds = %free_stack, %skip_free_next
  store i64 0, i64* %countp, align 8
  br label %common.ret

init_header:                                      ; preds = %alloc, %init_body
  %i = phi i64 [ %i_next, %init_body ], [ 0, %alloc ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:                                        ; preds = %init_header
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr0 = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr0, align 8
  %i_next = add i64 %i, 1
  br label %init_header

after_init:                                       ; preds = %init_header
  store i64 0, i64* %countp, align 8
  store i64 %start, i64* %stack, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  store i64 1, i64* %countp, align 8
  store i64 %start, i64* %out, align 8
  br label %loop_header

loop_header:                                      ; preds = %after_loop_iter, %after_init
  %sp_phi = phi i64 [ 1, %after_init ], [ %sp_next, %after_loop_iter ]
  %sp_is_zero = icmp eq i64 %sp_phi, 0
  br i1 %sp_is_zero, label %cleanup, label %process_top

process_top:                                      ; preds = %loop_header
  %top_index = add i64 %sp_phi, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %current = load i64, i64* %top_ptr, align 8
  %next_ptr_cur = getelementptr inbounds i64, i64* %next, i64 %current
  %idx0 = load i64, i64* %next_ptr_cur, align 8
  br label %neighbor_header

neighbor_header:                                  ; preds = %neighbor_continue, %process_top
  %idx_phi = phi i64 [ %idx0, %process_top ], [ %idx_inc, %neighbor_continue ]
  %idx_lt_n = icmp ult i64 %idx_phi, %n
  br i1 %idx_lt_n, label %check_adj, label %no_more_neighbors

check_adj:                                        ; preds = %neighbor_header
  %row_mul = mul i64 %current, %n
  %lin_idx = add i64 %row_mul, %idx_phi
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %lin_idx
  %mat_elem = load i32, i32* %mat_elem_ptr, align 4
  %is_edge.not = icmp eq i32 %mat_elem, 0
  br i1 %is_edge.not, label %neighbor_continue, label %check_visited

check_visited:                                    ; preds = %check_adj
  %vis_idx_ptr = getelementptr inbounds i32, i32* %vis, i64 %idx_phi
  %vis_val = load i32, i32* %vis_idx_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_val, 0
  br i1 %is_unvisited, label %visit_neighbor, label %neighbor_continue

visit_neighbor:                                   ; preds = %check_visited
  %idx_plus1 = add i64 %idx_phi, 1
  store i64 %idx_plus1, i64* %next_ptr_cur, align 8
  store i32 1, i32* %vis_idx_ptr, align 4
  %c_old = load i64, i64* %countp, align 8
  %c_new = add i64 %c_old, 1
  store i64 %c_new, i64* %countp, align 8
  %out_ptr_i = getelementptr inbounds i64, i64* %out, i64 %c_old
  store i64 %idx_phi, i64* %out_ptr_i, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_phi
  store i64 %idx_phi, i64* %stack_push_ptr, align 8
  %sp_after_push = add i64 %sp_phi, 1
  br label %after_loop_iter

neighbor_continue:                                ; preds = %check_visited, %check_adj
  %idx_inc = add i64 %idx_phi, 1
  br label %neighbor_header

no_more_neighbors:                                ; preds = %neighbor_header
  br label %after_loop_iter

after_loop_iter:                                  ; preds = %no_more_neighbors, %visit_neighbor
  %sp_next = phi i64 [ %sp_after_push, %visit_neighbor ], [ %top_index, %no_more_neighbors ]
  br label %loop_header

cleanup:                                          ; preds = %loop_header
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  br label %common.ret
}
