; ModuleID = 'dfs.ll'
; LLVM 14 IR

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out_nodes, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_bad, label %after_param

early_bad:
  store i64 0, i64* %out_count, align 8
  ret void

after_param:
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
  %tmp1 = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_cond

alloc_fail:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  store i64 0, i64* %out_count, align 8
  ret void

init_cond:
  %i = phi i64 [ 0, %after_param ], [ %inc, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %post_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %inc = add i64 %i, 1
  br label %init_cond

post_init:
  store i64 0, i64* %out_count, align 8
  ; push start
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  %ss1 = add i64 0, 1
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; out_nodes[count] = start; count++
  %cnt0 = load i64, i64* %out_count, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out_nodes, i64 %cnt0
  store i64 %start, i64* %out_ptr0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  br label %outer_cond

outer_cond:
  %ss = phi i64 [ %ss1, %post_init ], [ %ss_after_iter, %outer_latch ]
  %cond = icmp ne i64 %ss, 0
  br i1 %cond, label %outer_body, label %exit

outer_body:
  %ss_minus = add i64 %ss, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss_minus
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i_val = load i64, i64* %next_u_ptr, align 8
  br label %inner_cond

inner_cond:
  %i2 = phi i64 [ %i_val, %outer_body ], [ %i_next, %inner_incr ]
  %lt = icmp ult i64 %i2, %n
  br i1 %lt, label %inner_body, label %after_inner

inner_body:
  %mul = mul i64 %u, %n
  %idx_flat = add i64 %mul, %i2
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx_flat
  %mat_val = load i32, i32* %mat_elem_ptr, align 4
  %is_zero = icmp eq i32 %mat_val, 0
  br i1 %is_zero, label %inner_incr, label %check_visited

check_visited:
  %vis_i_ptr = getelementptr inbounds i32, i32* %vis, i64 %i2
  %vis_i = load i32, i32* %vis_i_ptr, align 4
  %is_visited = icmp ne i32 %vis_i, 0
  br i1 %is_visited, label %inner_incr, label %found_neighbor

found_neighbor:
  %i2_plus1 = add i64 %i2, 1
  store i64 %i2_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %cntA = load i64, i64* %out_count, align 8
  %out_slotA = getelementptr inbounds i64, i64* %out_nodes, i64 %cntA
  store i64 %i2, i64* %out_slotA, align 8
  %cntA_inc = add i64 %cntA, 1
  store i64 %cntA_inc, i64* %out_count, align 8
  %stack_slot_push = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %i2, i64* %stack_slot_push, align 8
  %ss_push_new = add i64 %ss, 1
  br label %outer_latch

inner_incr:
  %i_next = add i64 %i2, 1
  br label %inner_cond

after_inner:
  %ss_pop_new = add i64 %ss, -1
  br label %outer_latch

outer_latch:
  %ss_after_iter = phi i64 [ %ss_pop_new, %after_inner ], [ %ss_push_new, %found_neighbor ]
  br label %outer_cond

exit:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  ret void
}