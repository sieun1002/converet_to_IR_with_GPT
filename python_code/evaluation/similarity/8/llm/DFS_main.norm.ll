; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %alloc, label %early_ret

common.ret:                                       ; preds = %done, %alloc_fail, %early_ret
  ret void

early_ret:                                        ; preds = %entry
  store i64 0, i64* %out_len, align 8
  br label %common.ret

alloc:                                            ; preds = %entry
  %size_i32 = shl i64 %n, 2
  %visited_raw = call noalias i8* @malloc(i64 %size_i32)
  %size_i64 = shl i64 %n, 3
  %next_raw = call noalias i8* @malloc(i64 %size_i64)
  %stack_raw = call noalias i8* @malloc(i64 %size_i64)
  %visited = bitcast i8* %visited_raw to i32*
  %next = bitcast i8* %next_raw to i64*
  %stack = bitcast i8* %stack_raw to i64*
  %vis_null = icmp eq i8* %visited_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop.header

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_len, align 8
  br label %common.ret

init_loop.header:                                 ; preds = %alloc, %init_loop.body
  %i = phi i64 [ %i.next, %init_loop.body ], [ 0, %alloc ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_loop.body, label %after_init

init_loop.body:                                   ; preds = %init_loop.header
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %nptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop.header

after_init:                                       ; preds = %init_loop.header
  store i64 0, i64* %out_len, align 8
  store i64 %start, i64* %stack, align 8
  %vptr_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vptr_start, align 4
  store i64 1, i64* %out_len, align 8
  store i64 %start, i64* %out, align 8
  br label %outer

outer:                                            ; preds = %after_pop, %take_edge, %after_init
  %top = phi i64 [ 1, %after_init ], [ %top.after_push, %take_edge ], [ %top_minus1, %after_pop ]
  %top_is_zero = icmp eq i64 %top, 0
  br i1 %top_is_zero, label %done, label %load_top

load_top:                                         ; preds = %outer
  %top_minus1 = add i64 %top, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_minus1
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %v0 = load i64, i64* %next_u_ptr, align 8
  br label %inner

inner:                                            ; preds = %inner_skip, %load_top
  %v = phi i64 [ %v0, %load_top ], [ %v.inc, %inner_skip ]
  %v_in_range = icmp ult i64 %v, %n
  br i1 %v_in_range, label %check_edge, label %after_pop

check_edge:                                       ; preds = %inner
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %m_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %m_val = load i32, i32* %m_ptr, align 4
  %m_is_zero = icmp eq i32 %m_val, 0
  br i1 %m_is_zero, label %inner_skip, label %check_visited

check_visited:                                    ; preds = %check_edge
  %v_vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %v_vis = load i32, i32* %v_vis_ptr, align 4
  %vis_is_zero = icmp eq i32 %v_vis, 0
  br i1 %vis_is_zero, label %take_edge, label %inner_skip

take_edge:                                        ; preds = %check_visited
  %v_plus1 = add i64 %v, 1
  store i64 %v_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %v_vis_ptr, align 4
  %len.cur = load i64, i64* %out_len, align 8
  %len.next = add i64 %len.cur, 1
  store i64 %len.next, i64* %out_len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len.cur
  store i64 %v, i64* %out_slot, align 8
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top
  store i64 %v, i64* %stack_top_ptr, align 8
  %top.after_push = add i64 %top, 1
  br label %outer

inner_skip:                                       ; preds = %check_visited, %check_edge
  %v.inc = add i64 %v, 1
  br label %inner

after_pop:                                        ; preds = %inner
  br label %outer

done:                                             ; preds = %outer
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  br label %common.ret
}
