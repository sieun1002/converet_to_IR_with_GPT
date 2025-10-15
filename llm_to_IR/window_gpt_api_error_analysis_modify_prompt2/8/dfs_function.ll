; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early_zero, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %early_zero

early_zero:
  store i64 0, i64* %outCount, align 8
  ret void

alloc:
  %size_block = shl i64 %n, 2
  %p_block_i8 = call i8* @malloc(i64 %size_block)
  %block = bitcast i8* %p_block_i8 to i32*
  %size_arr = shl i64 %n, 3
  %p_next_i8 = call i8* @malloc(i64 %size_arr)
  %next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call i8* @malloc(i64 %size_arr)
  %stack = bitcast i8* %p_stack_i8 to i64*
  %block_null = icmp eq i32* %block, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %tmp_or1 = or i1 %block_null, %next_null
  %any_null = or i1 %tmp_or1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  %p_block_i8_cast = bitcast i32* %block to i8*
  call void @free(i8* %p_block_i8_cast)
  %p_next_i8_cast = bitcast i64* %next to i8*
  call void @free(i8* %p_next_i8_cast)
  %p_stack_i8_cast = bitcast i64* %stack to i8*
  call void @free(i8* %p_stack_i8_cast)
  store i64 0, i64* %outCount, align 8
  ret void

init_loop:
  br label %init_cond

init_cond:
  %i = phi i64 [ 0, %init_loop ], [ %i_next, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %init_done

init_body:
  %block_i_ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block_i_ptr, align 4
  %next_i_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_i_ptr, align 8
  %i_next = add i64 %i, 1
  br label %init_cond

init_done:
  store i64 0, i64* %outCount, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  %block_start_ptr = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %block_start_ptr, align 4
  %oldc = load i64, i64* %outCount, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %outCount, align 8
  %out_c_ptr = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %start, i64* %out_c_ptr, align 8
  br label %outer_cond

outer_cond:
  %top = phi i64 [ 1, %init_done ], [ %top_pop, %pop_block ], [ %top_after_push, %after_inner ]
  %top_nz = icmp ne i64 %top, 0
  br i1 %top_nz, label %outer_body, label %cleanup

outer_body:
  %top_minus1 = add i64 %top, -1
  %stack_topm1_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_minus1
  %cur = load i64, i64* %stack_topm1_ptr, align 8
  %next_cur_ptr = getelementptr inbounds i64, i64* %next, i64 %cur
  %nbr_init = load i64, i64* %next_cur_ptr, align 8
  br label %inner_cond

inner_cond:
  %nbr = phi i64 [ %nbr_init, %outer_body ], [ %nbr_inc, %inner_continue ]
  %nbr_lt_n = icmp ult i64 %nbr, %n
  br i1 %nbr_lt_n, label %inner_body, label %no_more_nbrs

inner_body:
  %mul = mul i64 %cur, %n
  %idx = add i64 %mul, %nbr
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat_val = load i32, i32* %mat_ptr, align 4
  %mat_zero = icmp eq i32 %mat_val, 0
  br i1 %mat_zero, label %inner_continue, label %check_block

check_block:
  %block_nbr_ptr = getelementptr inbounds i32, i32* %block, i64 %nbr
  %blk_val = load i32, i32* %block_nbr_ptr, align 4
  %blk_zero = icmp eq i32 %blk_val, 0
  br i1 %blk_zero, label %found_nbr, label %inner_continue

inner_continue:
  %nbr_inc = add i64 %nbr, 1
  br label %inner_cond

found_nbr:
  %nbr_plus1 = add i64 %nbr, 1
  store i64 %nbr_plus1, i64* %next_cur_ptr, align 8
  store i32 1, i32* %block_nbr_ptr, align 4
  %oldc2 = load i64, i64* %outCount, align 8
  %newc2 = add i64 %oldc2, 1
  store i64 %newc2, i64* %outCount, align 8
  %out_ptr2 = getelementptr inbounds i64, i64* %out, i64 %oldc2
  store i64 %nbr, i64* %out_ptr2, align 8
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top
  store i64 %nbr, i64* %stack_top_ptr, align 8
  %top_after_push = add i64 %top, 1
  br label %after_push_break

after_push_break:
  br label %after_inner

no_more_nbrs:
  %top_pop = add i64 %top, -1
  br label %pop_block

pop_block:
  br label %outer_cond

after_inner:
  br label %outer_cond

cleanup:
  %p_block_i8_cast2 = bitcast i32* %block to i8*
  call void @free(i8* %p_block_i8_cast2)
  %p_next_i8_cast2 = bitcast i64* %next to i8*
  call void @free(i8* %p_next_i8_cast2)
  %p_stack_i8_cast2 = bitcast i64* %stack to i8*
  call void @free(i8* %p_stack_i8_cast2)
  ret void
}