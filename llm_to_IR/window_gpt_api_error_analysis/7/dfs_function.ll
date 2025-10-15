; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_nodes, i64* %out_count) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %early, label %early_exit, label %alloc_block

early_exit:
  store i64 0, i64* %out_count, align 8
  ret void

alloc_block:
  %size_vis = shl i64 %n, 2
  %vis_i8 = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_i8 to i32*
  %size_n8 = shl i64 %n, 3
  %next_i8 = call i8* @malloc(i64 %size_n8)
  %next = bitcast i8* %next_i8 to i64*
  %stack_i8 = call i8* @malloc(i64 %size_n8)
  %stack = bitcast i8* %stack_i8 to i64*
  %vis_null = icmp eq i8* %vis_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop_entry

alloc_fail:
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init_loop_entry:
  %sp_ptr = alloca i64, align 8
  %i_ptr = alloca i64, align 8
  %curr_ptr = alloca i64, align 8
  %nei_ptr = alloca i64, align 8
  store i64 0, i64* %i_ptr, align 8
  br label %init_loop_cond

init_loop_cond:
  %i_val = load i64, i64* %i_ptr, align 8
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %init_loop_body, label %init_done

init_loop_body:
  %v_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i_val
  store i32 0, i32* %v_i_ptr, align 4
  %next_i_ptr = getelementptr inbounds i64, i64* %next, i64 %i_val
  store i64 0, i64* %next_i_ptr, align 8
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i_ptr, align 8
  br label %init_loop_cond

init_done:
  store i64 0, i64* %sp_ptr, align 8
  store i64 0, i64* %out_count, align 8
  %sp0 = load i64, i64* %sp_ptr, align 8
  %sp1 = add i64 %sp0, 1
  store i64 %sp1, i64* %sp_ptr, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 %sp0
  store i64 %start, i64* %stack_slot0, align 8
  %vstart_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vstart_ptr, align 4
  %oldcnt0 = load i64, i64* %out_count, align 8
  %out_node_slot0 = getelementptr inbounds i64, i64* %out_nodes, i64 %oldcnt0
  store i64 %start, i64* %out_node_slot0, align 8
  %newcnt0 = add i64 %oldcnt0, 1
  store i64 %newcnt0, i64* %out_count, align 8
  br label %outer_cond

outer_cond:
  %sp_now0 = load i64, i64* %sp_ptr, align 8
  %is_empty = icmp eq i64 %sp_now0, 0
  br i1 %is_empty, label %end, label %outer_prep

outer_prep:
  %spm1 = add i64 %sp_now0, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %spm1
  %curr_val = load i64, i64* %top_ptr, align 8
  store i64 %curr_val, i64* %curr_ptr, align 8
  %next_curr_ptr = getelementptr inbounds i64, i64* %next, i64 %curr_val
  %nei0 = load i64, i64* %next_curr_ptr, align 8
  store i64 %nei0, i64* %nei_ptr, align 8
  br label %inner_cond

inner_cond:
  %nei_val = load i64, i64* %nei_ptr, align 8
  %nei_lt_n = icmp ult i64 %nei_val, %n
  br i1 %nei_lt_n, label %check_edge, label %after_inner

check_edge:
  %curr_val2 = load i64, i64* %curr_ptr, align 8
  %mul_idx = mul i64 %curr_val2, %n
  %lin_idx = add i64 %mul_idx, %nei_val
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %lin_idx
  %edge_val = load i32, i32* %adj_elem_ptr, align 4
  %edge_is_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_is_zero, label %neighbor_incr, label %check_visited

check_visited:
  %vnei_ptr = getelementptr inbounds i32, i32* %visited, i64 %nei_val
  %vnei_val = load i32, i32* %vnei_ptr, align 4
  %is_visited = icmp ne i32 %vnei_val, 0
  br i1 %is_visited, label %neighbor_incr, label %visit_and_push

visit_and_push:
  %nei_plus1 = add i64 %nei_val, 1
  %next_curr_ptr2 = getelementptr inbounds i64, i64* %next, i64 %curr_val2
  store i64 %nei_plus1, i64* %next_curr_ptr2, align 8
  store i32 1, i32* %vnei_ptr, align 4
  %oldcnt2 = load i64, i64* %out_count, align 8
  %out_node_slot = getelementptr inbounds i64, i64* %out_nodes, i64 %oldcnt2
  store i64 %nei_val, i64* %out_node_slot, align 8
  %newcnt2 = add i64 %oldcnt2, 1
  store i64 %newcnt2, i64* %out_count, align 8
  %sp_before = load i64, i64* %sp_ptr, align 8
  %push_slot = getelementptr inbounds i64, i64* %stack, i64 %sp_before
  store i64 %nei_val, i64* %push_slot, align 8
  %sp_after = add i64 %sp_before, 1
  store i64 %sp_after, i64* %sp_ptr, align 8
  br label %outer_cond

neighbor_incr:
  %nei_inc = add i64 %nei_val, 1
  store i64 %nei_inc, i64* %nei_ptr, align 8
  br label %inner_cond

after_inner:
  %sp_now1 = load i64, i64* %sp_ptr, align 8
  %sp_dec = add i64 %sp_now1, -1
  store i64 %sp_dec, i64* %sp_ptr, align 8
  br label %outer_cond

end:
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}