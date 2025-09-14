; ModuleID = 'dfs_module'

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %out_len, align 8
  ret void

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero, label %alloc

alloc:
  %n_times_4 = shl i64 %n, 2
  %vis_raw = call i8* @malloc(i64 %n_times_4)
  %visited = bitcast i8* %vis_raw to i32*
  %n_times_8 = shl i64 %n, 3
  %next_raw = call i8* @malloc(i64 %n_times_8)
  %next = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 %n_times_8)
  %stack = bitcast i8* %stack_raw to i64*
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %tmp.null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp.null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_zero

alloc_fail:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_len, align 8
  ret void

init_zero:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_zero ], [ %i.next, %init_loop_body_end ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_loop_body, label %init_after

init_loop_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_loop_body_end

init_loop_body_end:
  %i.next = add i64 %i, 1
  br label %init_loop

init_after:
  store i64 0, i64* %out_len, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %count0 = load i64, i64* %out_len, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_slot0, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_len, align 8
  br label %outer_head

outer_head:
  %top = phi i64 [ 1, %init_after ], [ %top_next, %continue_outer ]
  %top_is_zero = icmp eq i64 %top, 0
  br i1 %top_is_zero, label %exit, label %load_u

load_u:
  %top_minus1 = add i64 %top, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_minus1
  %u = load i64, i64* %u_ptr, align 8
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %idx_init = load i64, i64* %next_u_ptr, align 8
  br label %inner_head

inner_head:
  %idx = phi i64 [ %idx_init, %load_u ], [ %idx_inc, %inner_continue ]
  %idx_lt_n = icmp ult i64 %idx, %n
  br i1 %idx_lt_n, label %neighbor_test, label %after_inner_equal

neighbor_test:
  %mul = mul i64 %u, %n
  %sum = add i64 %mul, %idx
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %sum
  %edge = load i32, i32* %mat_ptr, align 4
  %has_edge = icmp ne i32 %edge, 0
  br i1 %has_edge, label %check_unvisited, label %inner_continue

check_unvisited:
  %vis_idx_ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis_val = load i32, i32* %vis_idx_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_val, 0
  br i1 %is_unvisited, label %found_neighbor, label %inner_continue

inner_continue:
  %idx_inc = add i64 %idx, 1
  br label %inner_head

found_neighbor:
  %idx_plus1 = add i64 %idx, 1
  store i64 %idx_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %vis_idx_ptr, align 4
  %cnt_prev = load i64, i64* %out_len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt_prev
  store i64 %idx, i64* %out_slot, align 8
  %cnt_next = add i64 %cnt_prev, 1
  store i64 %cnt_next, i64* %out_len, align 8
  %stack_pos_ptr = getelementptr inbounds i64, i64* %stack, i64 %top
  store i64 %idx, i64* %stack_pos_ptr, align 8
  %top_after_push = add i64 %top, 1
  br label %continue_outer

after_inner_equal:
  %top_after_pop = add i64 %top, -1
  br label %continue_outer

continue_outer:
  %top_next = phi i64 [ %top_after_pop, %after_inner_equal ], [ %top_after_push, %found_neighbor ]
  br label %outer_head

exit:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}