; ModuleID = 'dfs_module'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define void @dfs(i32* nocapture readonly %matrix, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %countp) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %countp, align 8
  ret void

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero2, label %alloc

early_zero2:
  store i64 0, i64* %countp, align 8
  ret void

alloc:
  %size_vis = mul i64 %n, 4
  %raw_vis = call i8* @malloc(i64 %size_vis)
  %vis = bitcast i8* %raw_vis to i32*
  %size64 = mul i64 %n, 8
  %raw_next = call i8* @malloc(i64 %size64)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i32* %vis, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %malloc_fail, label %init_i

malloc_fail:
  br i1 %vis_null, label %skip_free_vis, label %free_vis
free_vis:
  %vis_bc = bitcast i32* %vis to i8*
  call void @free(i8* %vis_bc)
  br label %skip_free_vis
skip_free_vis:
  br i1 %next_null, label %skip_free_next, label %free_next
free_next:
  %next_bc = bitcast i64* %next to i8*
  call void @free(i8* %next_bc)
  br label %skip_free_next
skip_free_next:
  br i1 %stack_null, label %after_free_all, label %free_stack
free_stack:
  %stack_bc = bitcast i64* %stack to i8*
  call void @free(i8* %stack_bc)
  br label %after_free_all
after_free_all:
  store i64 0, i64* %countp, align 8
  ret void

init_i:
  br label %init_header

init_header:
  %i = phi i64 [ 0, %init_i ], [ %i_next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr0 = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr0, align 8
  %i_next = add i64 %i, 1
  br label %init_header

after_init:
  store i64 0, i64* %countp, align 8
  %stack_ptr0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_ptr0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %c_old0 = load i64, i64* %countp, align 8
  %c_new0 = add i64 %c_old0, 1
  store i64 %c_new0, i64* %countp, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %c_old0
  store i64 %start, i64* %out_ptr0, align 8
  %sp_entry = add i64 0, 1
  br label %loop_header

loop_header:
  %sp_phi = phi i64 [ %sp_entry, %after_init ], [ %sp_next, %after_loop_iter ]
  %sp_is_zero = icmp eq i64 %sp_phi, 0
  br i1 %sp_is_zero, label %cleanup, label %process_top

process_top:
  %top_index = add i64 %sp_phi, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %current = load i64, i64* %top_ptr, align 8
  %next_ptr_cur = getelementptr inbounds i64, i64* %next, i64 %current
  %idx0 = load i64, i64* %next_ptr_cur, align 8
  br label %neighbor_header

neighbor_header:
  %idx_phi = phi i64 [ %idx0, %process_top ], [ %idx_inc, %neighbor_continue ]
  %idx_lt_n = icmp ult i64 %idx_phi, %n
  br i1 %idx_lt_n, label %check_adj, label %no_more_neighbors

check_adj:
  %row_mul = mul i64 %current, %n
  %lin_idx = add i64 %row_mul, %idx_phi
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %lin_idx
  %mat_elem = load i32, i32* %mat_elem_ptr, align 4
  %is_edge = icmp ne i32 %mat_elem, 0
  br i1 %is_edge, label %check_visited, label %neighbor_continue

check_visited:
  %vis_idx_ptr = getelementptr inbounds i32, i32* %vis, i64 %idx_phi
  %vis_val = load i32, i32* %vis_idx_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_val, 0
  br i1 %is_unvisited, label %visit_neighbor, label %neighbor_continue

visit_neighbor:
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

neighbor_continue:
  %idx_inc = add i64 %idx_phi, 1
  br label %neighbor_header

no_more_neighbors:
  %sp_after_pop = add i64 %sp_phi, -1
  br label %after_loop_iter

after_loop_iter:
  %sp_next = phi i64 [ %sp_after_push, %visit_neighbor ], [ %sp_after_pop, %no_more_neighbors ]
  br label %loop_header

cleanup:
  %vis_bc2 = bitcast i32* %vis to i8*
  call void @free(i8* %vis_bc2)
  %next_bc2 = bitcast i64* %next to i8*
  call void @free(i8* %next_bc2)
  %stack_bc2 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_bc2)
  ret void
}