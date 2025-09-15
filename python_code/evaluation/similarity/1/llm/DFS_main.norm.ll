; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/DFS_main.ll"
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %count_ptr) {
entry:
  %n_is_zero = icmp ne i64 %n, 0
  %start_lt_n = icmp ult i64 %start, %n
  %or.cond = select i1 %n_is_zero, i1 %start_lt_n, i1 false
  br i1 %or.cond, label %alloc, label %early_zero

common.ret:                                       ; preds = %end_cleanup, %alloc_fail, %early_zero
  ret void

early_zero:                                       ; preds = %entry
  store i64 0, i64* %count_ptr, align 8
  br label %common.ret

alloc:                                            ; preds = %entry
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %p_vis_i8 to i32*
  %size_next_stack = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size_next_stack)
  %next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size_next_stack)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %vis_is_null = icmp eq i8* %p_vis_i8, null
  %next_is_null = icmp eq i8* %p_next_i8, null
  %stack_is_null = icmp eq i8* %p_stack_i8, null
  %any_null_tmp = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %any_null_tmp, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %count_ptr, align 8
  br label %common.ret

init_loop:                                        ; preds = %alloc, %init_loop_body
  %i = phi i64 [ %i_next, %init_loop_body ], [ 0, %alloc ]
  %cmp_init = icmp ult i64 %i, %n
  br i1 %cmp_init, label %init_loop_body, label %init_done

init_loop_body:                                   ; preds = %init_loop
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

init_done:                                        ; preds = %init_loop
  store i64 0, i64* %count_ptr, align 8
  store i64 %start, i64* %stack, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  store i64 1, i64* %count_ptr, align 8
  store i64 %start, i64* %out, align 8
  br label %outer_loop

outer_loop:                                       ; preds = %after_pop, %found_neighbor, %init_done
  %stackSize = phi i64 [ 1, %init_done ], [ %stackSize_after_push, %found_neighbor ], [ %top_index, %after_pop ]
  %nonempty.not = icmp eq i64 %stackSize, 0
  br i1 %nonempty.not, label %end_cleanup, label %iter_prep

iter_prep:                                        ; preds = %outer_loop
  %top_index = add i64 %stackSize, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %u = load i64, i64* %top_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i_init = load i64, i64* %next_u_ptr, align 8
  br label %neighbor_loop

neighbor_loop:                                    ; preds = %neighbor_continue, %iter_prep
  %i_phi = phi i64 [ %i_init, %iter_prep ], [ %i_inc, %neighbor_continue ]
  %i_lt_n = icmp ult i64 %i_phi, %n
  br i1 %i_lt_n, label %check_edge, label %after_pop

check_edge:                                       ; preds = %neighbor_loop
  %mul = mul i64 %u, %n
  %idx1 = add i64 %mul, %i_phi
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx1
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %has_edge.not = icmp eq i32 %adj_val, 0
  br i1 %has_edge.not, label %neighbor_continue, label %check_visited

check_visited:                                    ; preds = %check_edge
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i_phi
  %vis_i_val = load i32, i32* %vis_i_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_i_val, 0
  br i1 %is_unvisited, label %found_neighbor, label %neighbor_continue

found_neighbor:                                   ; preds = %check_visited
  %i_plus1 = add i64 %i_phi, 1
  store i64 %i_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %oldc = load i64, i64* %count_ptr, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %count_ptr, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %i_phi, i64* %out_slot, align 8
  %push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stackSize
  store i64 %i_phi, i64* %push_ptr, align 8
  %stackSize_after_push = add i64 %stackSize, 1
  br label %outer_loop

neighbor_continue:                                ; preds = %check_visited, %check_edge
  %i_inc = add i64 %i_phi, 1
  br label %neighbor_loop

after_pop:                                        ; preds = %neighbor_loop
  br label %outer_loop

end_cleanup:                                      ; preds = %outer_loop
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  br label %common.ret
}
