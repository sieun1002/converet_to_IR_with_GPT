; ModuleID = 'dfs_module'
source_filename = "dfs.ll"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %countRef) {
entry:
  %stackSize = alloca i64, align 8
  %cur = alloca i64, align 8
  %neighbor = alloca i64, align 8
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early, label %alloc

early:
  store i64 0, i64* %countRef, align 8
  ret void

alloc:
  %size_block_bytes = shl i64 %n, 2
  %raw_block = call i8* @malloc(i64 %size_block_bytes)
  %block = bitcast i8* %raw_block to i32*
  %size_next_bytes = shl i64 %n, 3
  %raw_next = call i8* @malloc(i64 %size_next_bytes)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call i8* @malloc(i64 %size_next_bytes)
  %stack = bitcast i8* %raw_stack to i64*
  %block_is_null = icmp eq i32* %block, null
  %next_is_null = icmp eq i64* %next, null
  %stack_is_null = icmp eq i64* %stack, null
  %any_null_a = or i1 %block_is_null, %next_is_null
  %any_null = or i1 %any_null_a, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  %raw_block2 = bitcast i32* %block to i8*
  call void @free(i8* %raw_block2)
  %raw_next2 = bitcast i64* %next to i8*
  call void @free(i8* %raw_next2)
  %raw_stack2 = bitcast i64* %stack to i8*
  call void @free(i8* %raw_stack2)
  store i64 0, i64* %countRef, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i_next, %init_loop_body_end ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %after_init

init_loop_body:
  %visited_ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %visited_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_loop_body_end

init_loop_body_end:
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:
  store i64 0, i64* %stackSize, align 8
  store i64 0, i64* %countRef, align 8
  %sp0 = load i64, i64* %stackSize, align 8
  %stack_slot_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp0
  store i64 %start, i64* %stack_slot_ptr, align 8
  %sp1 = add i64 %sp0, 1
  store i64 %sp1, i64* %stackSize, align 8
  %visit_start_ptr = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %visit_start_ptr, align 4
  %count0 = load i64, i64* %countRef, align 8
  %out_idx_ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_idx_ptr, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %countRef, align 8
  br label %outer_cond

outer_cond:
  %sp_cur = load i64, i64* %stackSize, align 8
  %stack_not_zero = icmp ne i64 %sp_cur, 0
  br i1 %stack_not_zero, label %outer_loop, label %cleanup

outer_loop:
  %sp_minus1 = add i64 %sp_cur, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_minus1
  %cur_val = load i64, i64* %top_ptr, align 8
  store i64 %cur_val, i64* %cur, align 8
  %next_ptr2 = getelementptr inbounds i64, i64* %next, i64 %cur_val
  %neighbor_start = load i64, i64* %next_ptr2, align 8
  store i64 %neighbor_start, i64* %neighbor, align 8
  br label %inner_cond

inner_cond:
  %neighbor_val = load i64, i64* %neighbor, align 8
  %neighbor_lt_n = icmp ult i64 %neighbor_val, %n
  br i1 %neighbor_lt_n, label %inner_body_check, label %after_inner

inner_body_check:
  %cur_val2 = load i64, i64* %cur, align 8
  %mul = mul i64 %cur_val2, %n
  %idx = add i64 %mul, %neighbor_val
  %adj_idx_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_idx_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  %visit_neighbor_ptr = getelementptr inbounds i32, i32* %block, i64 %neighbor_val
  %visit_neighbor_val = load i32, i32* %visit_neighbor_ptr, align 4
  %not_visited = icmp eq i32 %visit_neighbor_val, 0
  %can_push = and i1 %adj_nonzero, %not_visited
  br i1 %can_push, label %push_neighbor, label %inc_neighbor

push_neighbor:
  %neighbor_plus1 = add i64 %neighbor_val, 1
  %cur_val3 = load i64, i64* %cur, align 8
  %next_cur_ptr = getelementptr inbounds i64, i64* %next, i64 %cur_val3
  store i64 %neighbor_plus1, i64* %next_cur_ptr, align 8
  store i32 1, i32* %visit_neighbor_ptr, align 4
  %count_old = load i64, i64* %countRef, align 8
  %out_ptr2 = getelementptr inbounds i64, i64* %out, i64 %count_old
  store i64 %neighbor_val, i64* %out_ptr2, align 8
  %count_new = add i64 %count_old, 1
  store i64 %count_new, i64* %countRef, align 8
  %sp_val2 = load i64, i64* %stackSize, align 8
  %stack_slot_ptr2 = getelementptr inbounds i64, i64* %stack, i64 %sp_val2
  store i64 %neighbor_val, i64* %stack_slot_ptr2, align 8
  %sp_inc = add i64 %sp_val2, 1
  store i64 %sp_inc, i64* %stackSize, align 8
  br label %outer_cond

inc_neighbor:
  %neighbor_inc = add i64 %neighbor_val, 1
  store i64 %neighbor_inc, i64* %neighbor, align 8
  br label %inner_cond

after_inner:
  %sp_val3 = load i64, i64* %stackSize, align 8
  %sp_dec = add i64 %sp_val3, -1
  store i64 %sp_dec, i64* %stackSize, align 8
  br label %outer_cond

cleanup:
  %raw_block_free = bitcast i32* %block to i8*
  call void @free(i8* %raw_block_free)
  %raw_next_free = bitcast i64* %next to i8*
  call void @free(i8* %raw_next_free)
  %raw_stack_free = bitcast i64* %stack to i8*
  call void @free(i8* %raw_stack_free)
  ret void
}