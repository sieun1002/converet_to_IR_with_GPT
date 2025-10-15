; ModuleID = 'dfs'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %or_fail = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %or_fail, label %early_fail, label %alloc

early_fail:
  store i64 0, i64* %outCount, align 8
  br label %ret

alloc:
  %size_block_shl = shl i64 %n, 2
  %malloc_block = call i8* @malloc(i64 %size_block_shl)
  %block = bitcast i8* %malloc_block to i32*
  %size_next_shl = shl i64 %n, 3
  %malloc_next = call i8* @malloc(i64 %size_next_shl)
  %next = bitcast i8* %malloc_next to i64*
  %size_stack_shl = shl i64 %n, 3
  %malloc_stack = call i8* @malloc(i64 %size_stack_shl)
  %stack = bitcast i8* %malloc_stack to i64*
  %is_block_null = icmp eq i8* %malloc_block, null
  %is_next_null = icmp eq i8* %malloc_next, null
  %is_stack_null = icmp eq i8* %malloc_stack, null
  %any_null1 = or i1 %is_block_null, %is_next_null
  %any_null = or i1 %any_null1, %is_stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %malloc_block)
  call void @free(i8* %malloc_next)
  call void @free(i8* %malloc_stack)
  store i64 0, i64* %outCount, align 8
  br label %ret

init_loop:
  br label %init_cond

init_cond:
  %i_phi = phi i64 [ 0, %init_loop ], [ %i_next, %init_body ]
  %cmp_i_n = icmp ult i64 %i_phi, %n
  br i1 %cmp_i_n, label %init_body, label %after_init

init_body:
  %gep_block_i = getelementptr inbounds i32, i32* %block, i64 %i_phi
  store i32 0, i32* %gep_block_i, align 4
  %gep_next_i = getelementptr inbounds i64, i64* %next, i64 %i_phi
  store i64 0, i64* %gep_next_i, align 8
  %i_next = add i64 %i_phi, 1
  br label %init_cond

after_init:
  store i64 0, i64* %outCount, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  %gep_block_start = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %gep_block_start, align 4
  %cnt0 = load i64, i64* %outCount, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %outCount, align 8
  %out_pos0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_pos0, align 8
  br label %outer_check

outer_check:
  %sp_phi = phi i64 [ 1, %after_init ], [ %sp_next_from_found, %found_neighbor ], [ %sp_dec, %no_neighbor ]
  %cmp_sp_zero = icmp ne i64 %sp_phi, 0
  br i1 %cmp_sp_zero, label %outer_body, label %cleanup

outer_body:
  %sp_minus1 = add i64 %sp_phi, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_minus1
  %node = load i64, i64* %top_ptr, align 8
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %node
  %idx0 = load i64, i64* %next_ptr, align 8
  br label %inner_cond

inner_cond:
  %idx_phi = phi i64 [ %idx0, %outer_body ], [ %idx_inc, %inc_idx ]
  %cmp_idx_n = icmp ult i64 %idx_phi, %n
  br i1 %cmp_idx_n, label %check_adj, label %no_neighbor

check_adj:
  %mul = mul i64 %node, %n
  %sum = add i64 %mul, %idx_phi
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  br i1 %adj_nonzero, label %check_block, label %inc_idx

check_block:
  %blk_idx_ptr = getelementptr inbounds i32, i32* %block, i64 %idx_phi
  %blk_val = load i32, i32* %blk_idx_ptr, align 4
  %blk_is_zero = icmp eq i32 %blk_val, 0
  br i1 %blk_is_zero, label %found_neighbor, label %inc_idx

found_neighbor:
  %idx_plus1 = add i64 %idx_phi, 1
  store i64 %idx_plus1, i64* %next_ptr, align 8
  store i32 1, i32* %blk_idx_ptr, align 4
  %cntA = load i64, i64* %outCount, align 8
  %cntA1 = add i64 %cntA, 1
  store i64 %cntA1, i64* %outCount, align 8
  %out_posA = getelementptr inbounds i64, i64* %out, i64 %cntA
  store i64 %idx_phi, i64* %out_posA, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_phi
  store i64 %idx_phi, i64* %stack_push_ptr, align 8
  %sp_next_from_found = add i64 %sp_phi, 1
  br label %outer_check

inc_idx:
  %idx_inc = add i64 %idx_phi, 1
  br label %inner_cond

no_neighbor:
  %sp_dec = add i64 %sp_phi, -1
  br label %outer_check

cleanup:
  call void @free(i8* %malloc_block)
  call void @free(i8* %malloc_next)
  call void @free(i8* %malloc_stack)
  br label %ret

ret:
  ret void
}