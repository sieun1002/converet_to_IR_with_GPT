; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

; Function Attrs: nounwind
define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out_seq, i64* %out_len) local_unnamed_addr #0 {
entry:
  %n_is_zero = icmp ne i64 %n, 0
  %start_lt_n = icmp ult i64 %start, %n
  %or.cond = select i1 %n_is_zero, i1 %start_lt_n, i1 false
  br i1 %or.cond, label %alloc, label %ret_zero

common.ret:                                       ; preds = %done, %alloc_fail, %ret_zero
  ret void

ret_zero:                                         ; preds = %entry
  store i64 0, i64* %out_len, align 8
  br label %common.ret

alloc:                                            ; preds = %entry
  %size_vis = shl i64 %n, 2
  %vis_raw = call i8* @malloc(i64 %size_vis) #0
  %vis = bitcast i8* %vis_raw to i32*
  %size_n8 = shl i64 %n, 3
  %next_raw = call i8* @malloc(i64 %size_n8) #0
  %next = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 %size_n8) #0
  %stack = bitcast i8* %stack_raw to i64*
  %vis_is_null = icmp eq i8* %vis_raw, null
  %next_is_null = icmp eq i8* %next_raw, null
  %stack_is_null = icmp eq i8* %stack_raw, null
  %tmp_or1 = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %tmp_or1, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_len, align 8
  br label %common.ret

init:                                             ; preds = %alloc
  store i64 0, i64* %out_len, align 8
  br label %init_loop

init_loop:                                        ; preds = %init_body, %init
  %i = phi i64 [ 0, %init ], [ %i_next, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %vis_i_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_i_ptr, align 4
  %next_i_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_i_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  store i64 %start, i64* %stack, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %old_len0 = load i64, i64* %out_len, align 8
  %new_len0 = add i64 %old_len0, 1
  store i64 %new_len0, i64* %out_len, align 8
  %out_pos0 = getelementptr inbounds i64, i64* %out_seq, i64 %old_len0
  store i64 %start, i64* %out_pos0, align 8
  br label %outer_loop

outer_loop:                                       ; preds = %outer_continue, %after_init
  %stack_len = phi i64 [ 1, %after_init ], [ %stack_len_next, %outer_continue ]
  %has_items.not = icmp eq i64 %stack_len, 0
  br i1 %has_items.not, label %done, label %process_top

process_top:                                      ; preds = %outer_loop
  %top_idx = add i64 %stack_len, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %u = load i64, i64* %top_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i_cur = load i64, i64* %next_u_ptr, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %no_push, %process_top
  %i_var = phi i64 [ %i_cur, %process_top ], [ %i_inc, %no_push ]
  %i_var_lt_n = icmp ult i64 %i_var, %n
  br i1 %i_var_lt_n, label %check_edge, label %after_inner

check_edge:                                       ; preds = %inner_loop
  %mul_un = mul i64 %u, %n
  %sum_un = add i64 %mul_un, %i_var
  %elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %sum_un
  %elem_val = load i32, i32* %elem_ptr, align 4
  %is_zero = icmp eq i32 %elem_val, 0
  br i1 %is_zero, label %no_push, label %check_visited

check_visited:                                    ; preds = %check_edge
  %vis_j_ptr = getelementptr inbounds i32, i32* %vis, i64 %i_var
  %vis_j_val = load i32, i32* %vis_j_ptr, align 4
  %visited.not = icmp eq i32 %vis_j_val, 0
  br i1 %visited.not, label %push_neighbor, label %no_push

push_neighbor:                                    ; preds = %check_visited
  %i_plus1 = add i64 %i_var, 1
  store i64 %i_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_j_ptr, align 4
  %old_len = load i64, i64* %out_len, align 8
  %new_len = add i64 %old_len, 1
  store i64 %new_len, i64* %out_len, align 8
  %out_pos = getelementptr inbounds i64, i64* %out_seq, i64 %old_len
  store i64 %i_var, i64* %out_pos, align 8
  %stack_pos_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_len
  store i64 %i_var, i64* %stack_pos_ptr, align 8
  %stack_len_inc = add i64 %stack_len, 1
  br label %outer_continue

no_push:                                          ; preds = %check_visited, %check_edge
  %i_inc = add i64 %i_var, 1
  br label %inner_loop

after_inner:                                      ; preds = %inner_loop
  %i_eq_n = icmp eq i64 %i_var, %n
  %spec.select = select i1 %i_eq_n, i64 %top_idx, i64 %stack_len
  br label %outer_continue

outer_continue:                                   ; preds = %after_inner, %push_neighbor
  %stack_len_next = phi i64 [ %stack_len_inc, %push_neighbor ], [ %spec.select, %after_inner ]
  br label %outer_loop

done:                                             ; preds = %outer_loop
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  br label %common.ret
}

attributes #0 = { nounwind }
