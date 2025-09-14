; ModuleID = 'dfs_module'
; LLVM 14 IR

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %out_count, align 8
  ret void

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero2, label %allocs

early_zero2:
  store i64 0, i64* %out_count, align 8
  ret void

allocs:
  %size_vis = shl i64 %n, 2
  %vis_raw = call noalias i8* @malloc(i64 %size_vis)
  %size_next = shl i64 %n, 3
  %next_raw = call noalias i8* @malloc(i64 %size_next)
  %stack_raw = call noalias i8* @malloc(i64 %size_next)
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %after_alloc

alloc_fail:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_count, align 8
  ret void

after_alloc:
  %visited = bitcast i8* %vis_raw to i32*
  %nextidx = bitcast i8* %next_raw to i64*
  %stack = bitcast i8* %stack_raw to i64*
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %init_loop

init_loop:
  %i_val = load i64, i64* %i, align 8
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %init_body, label %init_done

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i_val
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextidx, i64 %i_val
  store i64 0, i64* %next_ptr, align 8
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i, align 8
  br label %init_loop

init_done:
  %stackSize = alloca i64, align 8
  store i64 0, i64* %stackSize, align 8
  store i64 0, i64* %out_count, align 8
  %ss0 = load i64, i64* %stackSize, align 8
  %ss0_inc = add i64 %ss0, 1
  store i64 %ss0_inc, i64* %stackSize, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 %ss0
  store i64 %start, i64* %stack_slot0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt0_inc = add i64 %cnt0, 1
  store i64 %cnt0_inc, i64* %out_count, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_slot0, align 8
  br label %outer_check

outer_check:
  %ss_cur = load i64, i64* %stackSize, align 8
  %ss_nonzero = icmp ne i64 %ss_cur, 0
  br i1 %ss_nonzero, label %outer_body, label %cleanup

outer_body:
  %ss_cur2 = load i64, i64* %stackSize, align 8
  %top_index = add i64 %ss_cur2, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %curr = load i64, i64* %top_ptr, align 8
  %j = alloca i64, align 8
  %next_ptr2 = getelementptr inbounds i64, i64* %nextidx, i64 %curr
  %j_init = load i64, i64* %next_ptr2, align 8
  store i64 %j_init, i64* %j, align 8
  br label %inner_check

inner_check:
  %j_val = load i64, i64* %j, align 8
  %j_lt_n = icmp ult i64 %j_val, %n
  br i1 %j_lt_n, label %inner_body, label %after_inner

inner_body:
  %row_off = mul i64 %curr, %n
  %flat_idx = add i64 %row_off, %j_val
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %flat_idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %adj_val, 0
  br i1 %edge_zero, label %inc_j, label %check_visited

check_visited:
  %vis_j_ptr = getelementptr inbounds i32, i32* %visited, i64 %j_val
  %vis_j = load i32, i32* %vis_j_ptr, align 4
  %vis_j_zero = icmp eq i32 %vis_j, 0
  br i1 %vis_j_zero, label %discover, label %inc_j

discover:
  %next_for_curr = add i64 %j_val, 1
  store i64 %next_for_curr, i64* %next_ptr2, align 8
  store i32 1, i32* %vis_j_ptr, align 4
  %cnt1 = load i64, i64* %out_count, align 8
  %cnt1_inc = add i64 %cnt1, 1
  store i64 %cnt1_inc, i64* %out_count, align 8
  %out_slot1 = getelementptr inbounds i64, i64* %out, i64 %cnt1
  store i64 %j_val, i64* %out_slot1, align 8
  %ss_push = load i64, i64* %stackSize, align 8
  %ss_push_inc = add i64 %ss_push, 1
  store i64 %ss_push_inc, i64* %stackSize, align 8
  %stack_slot_push = getelementptr inbounds i64, i64* %stack, i64 %ss_push
  store i64 %j_val, i64* %stack_slot_push, align 8
  br label %outer_check

inc_j:
  %j_next = add i64 %j_val, 1
  store i64 %j_next, i64* %j, align 8
  br label %inner_check

after_inner:
  %ss_pop0 = load i64, i64* %stackSize, align 8
  %ss_pop1 = add i64 %ss_pop0, -1
  store i64 %ss_pop1, i64* %stackSize, align 8
  br label %outer_check

cleanup:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}