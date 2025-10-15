; ModuleID = 'dfs.ll'
source_filename = "dfs.ll"
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %countptr) {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %bad_or = or i1 %cmp_n0, %cmp_start_ge_n
  br i1 %bad_or, label %early_ret, label %alloc

early_ret:
  store i64 0, i64* %countptr, align 8
  ret void

alloc:
  %size_v = mul i64 %n, 4
  %mem_v = call i8* @malloc(i64 %size_v)
  %visited = bitcast i8* %mem_v to i32*
  %size8 = shl i64 %n, 3
  %mem_next = call i8* @malloc(i64 %size8)
  %next = bitcast i8* %mem_next to i64*
  %mem_stack = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %mem_stack to i64*
  %v_is_null = icmp eq i8* %mem_v, null
  %next_is_null = icmp eq i8* %mem_next, null
  %stack_is_null = icmp eq i8* %mem_stack, null
  %tmp_or1 = or i1 %v_is_null, %next_is_null
  %any_null = or i1 %tmp_or1, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init_for

alloc_fail:
  br i1 %v_is_null, label %af_skip_v, label %af_do_v
af_do_v:
  call void @free(i8* %mem_v)
  br label %af_skip_v
af_skip_v:
  br i1 %next_is_null, label %af_skip_next, label %af_do_next
af_do_next:
  call void @free(i8* %mem_next)
  br label %af_skip_next
af_skip_next:
  br i1 %stack_is_null, label %af_done, label %af_do_stack
af_do_stack:
  call void @free(i8* %mem_stack)
  br label %af_done
af_done:
  store i64 0, i64* %countptr, align 8
  ret void

init_for:
  br label %init_for_cond

init_for_cond:
  %i = phi i64 [ 0, %init_for ], [ %i_next, %init_for_body ]
  %cmp_i_n = icmp ult i64 %i, %n
  br i1 %cmp_i_n, label %init_for_body, label %after_init

init_for_body:
  %v_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %v_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_for_cond

after_init:
  store i64 0, i64* %countptr, align 8
  %stack_idx0_ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_idx0_ptr, align 8
  %start_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %start_v_ptr, align 4
  %oldcnt0 = load i64, i64* %countptr, align 8
  %out_elem0 = getelementptr inbounds i64, i64* %out, i64 %oldcnt0
  store i64 %start, i64* %out_elem0, align 8
  %newcnt0 = add i64 %oldcnt0, 1
  store i64 %newcnt0, i64* %countptr, align 8
  br label %outer_cond

outer_cond:
  %stackSize = phi i64 [ 1, %after_init ], [ %stackSize_after_pop, %neighbor_done ], [ %stackSize_push, %found_neighbor ]
  %cmp_stack_nonzero = icmp ne i64 %stackSize, 0
  br i1 %cmp_stack_nonzero, label %outer_body, label %finish

outer_body:
  %top_index = add i64 %stackSize, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %current = load i64, i64* %stack_top_ptr, align 8
  %next_idx_ptr_for_current = getelementptr inbounds i64, i64* %next, i64 %current
  %idx_init = load i64, i64* %next_idx_ptr_for_current, align 8
  br label %neighbor_cond

neighbor_cond:
  %idx = phi i64 [ %idx_init, %outer_body ], [ %idx_next, %inc_idx ]
  %cmp_idx_n = icmp ult i64 %idx, %n
  br i1 %cmp_idx_n, label %neighbor_body, label %neighbor_done

neighbor_body:
  %mul = mul i64 %current, %n
  %sum = add i64 %mul, %idx
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj_val, 0
  br i1 %is_zero, label %inc_idx, label %check_visited

check_visited:
  %v_idx_ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis = load i32, i32* %v_idx_ptr, align 4
  %vis_nonzero = icmp ne i32 %vis, 0
  br i1 %vis_nonzero, label %inc_idx, label %found_neighbor

found_neighbor:
  %idx_plus1 = add i64 %idx, 1
  store i64 %idx_plus1, i64* %next_idx_ptr_for_current, align 8
  store i32 1, i32* %v_idx_ptr, align 4
  %oldcnt1 = load i64, i64* %countptr, align 8
  %out_elem1 = getelementptr inbounds i64, i64* %out, i64 %oldcnt1
  store i64 %idx, i64* %out_elem1, align 8
  %newcnt1 = add i64 %oldcnt1, 1
  store i64 %newcnt1, i64* %countptr, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stackSize
  store i64 %idx, i64* %stack_push_ptr, align 8
  %stackSize_push = add i64 %stackSize, 1
  br label %outer_cond

inc_idx:
  %idx_next = add i64 %idx, 1
  br label %neighbor_cond

neighbor_done:
  %stackSize_after_pop = add i64 %stackSize, -1
  br label %outer_cond

finish:
  call void @free(i8* %mem_v)
  call void @free(i8* %mem_next)
  call void @free(i8* %mem_stack)
  ret void
}