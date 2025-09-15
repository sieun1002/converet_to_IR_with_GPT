; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

; Function Attrs: nounwind
define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len_ptr) local_unnamed_addr #0 {
entry:
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %alloc, label %early_ret

common.ret:                                       ; preds = %cleanup, %alloc_fail, %early_ret
  ret void

early_ret:                                        ; preds = %entry
  store i64 0, i64* %out_len_ptr, align 8
  br label %common.ret

alloc:                                            ; preds = %entry
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call i8* @malloc(i64 %size_vis) #0
  %visited = bitcast i8* %p_vis_i8 to i32*
  %size_n8 = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size_n8) #0
  %nextIndex = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size_n8) #0
  %stack = bitcast i8* %p_stack_i8 to i64*
  %vis_is_null = icmp eq i8* %p_vis_i8, null
  %next_is_null = icmp eq i8* %p_next_i8, null
  %stack_is_null = icmp eq i8* %p_stack_i8, null
  %tmp_or1 = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %tmp_or1, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %zero_loop

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %out_len_ptr, align 8
  br label %common.ret

zero_loop:                                        ; preds = %alloc, %zero_body
  %i = phi i64 [ %i_next, %zero_body ], [ 0, %alloc ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %zero_body, label %after_zero

zero_body:                                        ; preds = %zero_loop
  %vis_ptr_i = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr_i, align 4
  %next_ptr_i = getelementptr inbounds i64, i64* %nextIndex, i64 %i
  store i64 0, i64* %next_ptr_i, align 8
  %i_next = add i64 %i, 1
  br label %zero_loop

after_zero:                                       ; preds = %zero_loop
  store i64 0, i64* %out_len_ptr, align 8
  store i64 %start, i64* %stack, align 8
  %vis_ptr_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_ptr_start, align 4
  store i64 %start, i64* %out, align 8
  store i64 1, i64* %out_len_ptr, align 8
  br label %loop_header

loop_header:                                      ; preds = %loop_back, %after_zero
  %cur_len = phi i64 [ 1, %after_zero ], [ %cur_len1, %loop_back ]
  %stackSize = phi i64 [ 1, %after_zero ], [ %stackSize_next, %loop_back ]
  %has_items.not = icmp eq i64 %stackSize, 0
  br i1 %has_items.not, label %cleanup, label %iter

iter:                                             ; preds = %loop_header
  %top_index = add i64 %stackSize, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %u = load i64, i64* %top_ptr, align 8
  %next_ptr_u = getelementptr inbounds i64, i64* %nextIndex, i64 %u
  %j_init = load i64, i64* %next_ptr_u, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %advance, %iter
  %j = phi i64 [ %j_init, %iter ], [ %j_inc, %advance ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner_body, label %no_more_neighbors

inner_body:                                       ; preds = %inner_loop
  %mul_un = mul i64 %u, %n
  %idx_flat = add i64 %mul_un, %j
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_flat
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge = icmp ne i32 %adj_val, 0
  %vis_ptr_j = getelementptr inbounds i32, i32* %visited, i64 %j
  %vis_j = load i32, i32* %vis_ptr_j, align 4
  %unvisited = icmp eq i32 %vis_j, 0
  %can_traverse = and i1 %edge, %unvisited
  br i1 %can_traverse, label %found, label %advance

advance:                                          ; preds = %inner_body
  %j_inc = add i64 %j, 1
  br label %inner_loop

found:                                            ; preds = %inner_body
  %j_plus1 = add i64 %j, 1
  store i64 %j_plus1, i64* %next_ptr_u, align 8
  store i32 1, i32* %vis_ptr_j, align 4
  %out_pos = getelementptr inbounds i64, i64* %out, i64 %cur_len
  store i64 %j, i64* %out_pos, align 8
  %new_len = add i64 %cur_len, 1
  store i64 %new_len, i64* %out_len_ptr, align 8
  %stack_pos_push = getelementptr inbounds i64, i64* %stack, i64 %stackSize
  store i64 %j, i64* %stack_pos_push, align 8
  %stackSize_inc = add i64 %stackSize, 1
  br label %loop_back

no_more_neighbors:                                ; preds = %inner_loop
  br label %loop_back

loop_back:                                        ; preds = %no_more_neighbors, %found
  %cur_len1 = phi i64 [ %new_len, %found ], [ %cur_len, %no_more_neighbors ]
  %stackSize_next = phi i64 [ %stackSize_inc, %found ], [ %top_index, %no_more_neighbors ]
  br label %loop_header

cleanup:                                          ; preds = %loop_header
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  br label %common.ret
}

attributes #0 = { nounwind }
