; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %out_len_ptr) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_exit, label %alloc

early_exit:
  store i64 0, i64* %out_len_ptr, align 8
  ret void

alloc:
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call noalias i8* @malloc(i64 %size_vis)
  %p_vis = bitcast i8* %p_vis_i8 to i32*
  %size_next = shl i64 %n, 3
  %p_next_i8 = call noalias i8* @malloc(i64 %size_next)
  %p_next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call noalias i8* @malloc(i64 %size_next)
  %p_stack = bitcast i8* %p_stack_i8 to i64*
  %vis_null = icmp eq i8* %p_vis_i8, null
  %next_null = icmp eq i8* %p_next_i8, null
  %stack_null = icmp eq i8* %p_stack_i8, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %out_len_ptr, align 8
  ret void

init_loop:
  br label %init_cond

init_cond:
  %i = phi i64 [ 0, %init_loop ], [ %i_next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %p_vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %p_next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_cond

after_init:
  store i64 0, i64* %out_len_ptr, align 8
  %k0 = add i64 0, 0
  %k1 = add i64 %k0, 1
  %stack_slot0 = getelementptr inbounds i64, i64* %p_stack, i64 %k0
  store i64 %start, i64* %stack_slot0, align 8
  %start_vis_ptr = getelementptr inbounds i32, i32* %p_vis, i64 %start
  store i32 1, i32* %start_vis_ptr, align 4
  %len0 = load i64, i64* %out_len_ptr, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out_slot0, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len_ptr, align 8
  br label %while_check

while_check:
  %k = phi i64 [ %k1, %after_init ], [ %k_next_from_found, %found_push_to_check ], [ %k_pop, %after_scan ]
  %cond_k = icmp ne i64 %k, 0
  br i1 %cond_k, label %loop_top, label %cleanup

loop_top:
  %k_minus1 = add i64 %k, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %p_stack, i64 %k_minus1
  %topnode = load i64, i64* %stack_top_ptr, align 8
  %next_ptr_top = getelementptr inbounds i64, i64* %p_next, i64 %topnode
  %neighbor_init = load i64, i64* %next_ptr_top, align 8
  br label %for_cond

for_cond:
  %neighbor = phi i64 [ %neighbor_init, %loop_top ], [ %neighbor_inc1, %inc_neighbor_edge_zero ], [ %neighbor_inc2, %inc_neighbor_visited ]
  %cmp_neighbor = icmp ult i64 %neighbor, %n
  br i1 %cmp_neighbor, label %check_edge, label %after_scan

check_edge:
  %mul = mul i64 %topnode, %n
  %idx = add i64 %mul, %neighbor
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat_val = load i32, i32* %mat_ptr, align 4
  %has_edge = icmp ne i32 %mat_val, 0
  br i1 %has_edge, label %check_visited, label %inc_neighbor_edge_zero

inc_neighbor_edge_zero:
  %neighbor_inc1 = add i64 %neighbor, 1
  br label %for_cond

check_visited:
  %vis_ptr2 = getelementptr inbounds i32, i32* %p_vis, i64 %neighbor
  %vis_val = load i32, i32* %vis_ptr2, align 4
  %unvisited = icmp eq i32 %vis_val, 0
  br i1 %unvisited, label %found, label %inc_neighbor_visited

inc_neighbor_visited:
  %neighbor_inc2 = add i64 %neighbor, 1
  br label %for_cond

found:
  %neighbor_plus1 = add i64 %neighbor, 1
  store i64 %neighbor_plus1, i64* %next_ptr_top, align 8
  store i32 1, i32* %vis_ptr2, align 4
  %len_before = load i64, i64* %out_len_ptr, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len_before
  store i64 %neighbor, i64* %out_slot, align 8
  %len_after = add i64 %len_before, 1
  store i64 %len_after, i64* %out_len_ptr, align 8
  %stack_slot = getelementptr inbounds i64, i64* %p_stack, i64 %k
  store i64 %neighbor, i64* %stack_slot, align 8
  %k_next_from_found = add i64 %k, 1
  br label %found_push_to_check

found_push_to_check:
  br label %while_check

after_scan:
  %k_pop = add i64 %k, -1
  br label %while_check

cleanup:
  call void @free(i8* %p_vis_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  ret void
}