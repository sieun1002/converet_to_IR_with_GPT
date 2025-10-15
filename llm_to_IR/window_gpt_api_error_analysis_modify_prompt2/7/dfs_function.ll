; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %outPath, i64* %outLen) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early_ret, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %allocs, label %early_ret

early_ret:
  store i64 0, i64* %outLen, align 8
  ret void

allocs:
  %size4 = shl i64 %n, 2
  %p_block_i8 = call i8* @malloc(i64 %size4)
  %block = bitcast i8* %p_block_i8 to i32*
  %size8 = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size8)
  %next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %null_block = icmp eq i8* %p_block_i8, null
  %null_next = icmp eq i8* %p_next_i8, null
  %null_stack = icmp eq i8* %p_stack_i8, null
  %anynull1 = or i1 %null_block, %null_next
  %anynull = or i1 %anynull1, %null_stack
  br i1 %anynull, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %p_block_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  store i64 0, i64* %outLen, align 8
  br label %cleanup_ret

init_loop:
  br label %init_cond

init_cond:
  %i_init = phi i64 [ 0, %init_loop ], [ %i_next, %init_body ]
  %cond_init = icmp ult i64 %i_init, %n
  br i1 %cond_init, label %init_body, label %post_init

init_body:
  %gep_block_i = getelementptr inbounds i32, i32* %block, i64 %i_init
  store i32 0, i32* %gep_block_i, align 4
  %gep_next_i = getelementptr inbounds i64, i64* %next, i64 %i_init
  store i64 0, i64* %gep_next_i, align 8
  %i_next = add i64 %i_init, 1
  br label %init_cond

post_init:
  store i64 0, i64* %outLen, align 8
  %old_size0 = add i64 0, 0
  %idx_stack0 = getelementptr inbounds i64, i64* %stack, i64 %old_size0
  store i64 %start, i64* %idx_stack0, align 8
  %gep_block_start = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %gep_block_start, align 4
  %old_outlen0 = load i64, i64* %outLen, align 8
  %new_outlen0 = add i64 %old_outlen0, 1
  store i64 %new_outlen0, i64* %outLen, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %outPath, i64 %old_outlen0
  store i64 %start, i64* %out_slot0, align 8
  %size1 = add i64 %old_size0, 1
  br label %while_check

while_check:
  %size_phi = phi i64 [ %size1, %post_init ], [ %size_next, %after_neighbor ]
  %nz = icmp ne i64 %size_phi, 0
  br i1 %nz, label %loop_top, label %free_and_ret

loop_top:
  %top_index = add i64 %size_phi, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %curr = load i64, i64* %top_ptr, align 8
  %next_ptr_curr = getelementptr inbounds i64, i64* %next, i64 %curr
  %next_idx = load i64, i64* %next_ptr_curr, align 8
  br label %neighbor_cond

neighbor_cond:
  %v18_phi = phi i64 [ %next_idx, %loop_top ], [ %v18_inc, %inc_neighbor ], [ %v18_phi_succ, %push_success ]
  %size_unmod = phi i64 [ %size_phi, %loop_top ], [ %size_unmod2, %inc_neighbor ], [ %size_succ, %push_success ]
  %lt_n = icmp ult i64 %v18_phi, %n
  br i1 %lt_n, label %neighbor_body, label %after_neighbor

neighbor_body:
  %mul = mul i64 %curr, %n
  %idx = add i64 %mul, %v18_phi
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj_val, 0
  br i1 %is_zero, label %inc_neighbor, label %check_visited

check_visited:
  %vis_ptr = getelementptr inbounds i32, i32* %block, i64 %v18_phi
  %vis_val = load i32, i32* %vis_ptr, align 4
  %is_vis = icmp ne i32 %vis_val, 0
  br i1 %is_vis, label %inc_neighbor, label %push_success

inc_neighbor:
  %v18_inc = add i64 %v18_phi, 1
  %size_unmod2 = add i64 %size_unmod, 0
  br label %neighbor_cond

push_success:
  %v18_plus1 = add i64 %v18_phi, 1
  store i64 %v18_plus1, i64* %next_ptr_curr, align 8
  store i32 1, i32* %vis_ptr, align 4
  %old_outlen = load i64, i64* %outLen, align 8
  %new_outlen = add i64 %old_outlen, 1
  store i64 %new_outlen, i64* %outLen, align 8
  %out_slot = getelementptr inbounds i64, i64* %outPath, i64 %old_outlen
  store i64 %v18_phi, i64* %out_slot, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %size_unmod
  store i64 %v18_phi, i64* %stack_slot, align 8
  %size_succ = add i64 %size_unmod, 1
  %v18_phi_succ = add i64 %v18_phi, 0
  br label %neighbor_cond

after_neighbor:
  %eq_n = icmp eq i64 %v18_phi, %n
  %size_dec = add i64 %size_unmod, -1
  %size_next = select i1 %eq_n, i64 %size_dec, i64 %size_unmod
  br label %while_check

free_and_ret:
  call void @free(i8* %p_block_i8)
  call void @free(i8* %p_next_i8)
  call void @free(i8* %p_stack_i8)
  br label %cleanup_ret

cleanup_ret:
  ret void
}