; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %arg0, i64 %arg8, i64 %arg10, i64* %arg18, i64* %arg20) {
entry:
  %cmp_arg8_zero = icmp eq i64 %arg8, 0
  br i1 %cmp_arg8_zero, label %zero_return, label %check_start

check_start:
  %start_in_range = icmp ult i64 %arg10, %arg8
  br i1 %start_in_range, label %alloc, label %zero_return

zero_return:
  store i64 0, i64* %arg20, align 8
  br label %ret

alloc:
  %size_block = shl i64 %arg8, 2
  %blk_raw = call i8* @malloc(i64 %size_block)
  %blk = bitcast i8* %blk_raw to i32*
  %size_q = shl i64 %arg8, 3
  %arr28_raw = call i8* @malloc(i64 %size_q)
  %arr28 = bitcast i8* %arr28_raw to i64*
  %arr30_raw = call i8* @malloc(i64 %size_q)
  %arr30 = bitcast i8* %arr30_raw to i64*
  %blk_null = icmp eq i8* %blk_raw, null
  %a28_null = icmp eq i8* %arr28_raw, null
  %a30_null = icmp eq i8* %arr30_raw, null
  %tmp_any1 = or i1 %blk_null, %a28_null
  %any_null = or i1 %tmp_any1, %a30_null
  br i1 %any_null, label %alloc_fail, label %init_cond

alloc_fail:
  call void @free(i8* %blk_raw)
  call void @free(i8* %arr28_raw)
  call void @free(i8* %arr30_raw)
  store i64 0, i64* %arg20, align 8
  br label %ret

init_cond:
  %i = phi i64 [ 0, %alloc ], [ %i_next, %init_post ]
  %i_lt_n = icmp ult i64 %i, %arg8
  br i1 %i_lt_n, label %init_body, label %after_init

init_body:
  %blk_ptr_i = getelementptr inbounds i32, i32* %blk, i64 %i
  store i32 0, i32* %blk_ptr_i, align 4
  %arr28_ptr_i = getelementptr inbounds i64, i64* %arr28, i64 %i
  store i64 0, i64* %arr28_ptr_i, align 8
  br label %init_post

init_post:
  %i_next = add i64 %i, 1
  br label %init_cond

after_init:
  store i64 0, i64* %arg20, align 8
  %arr30_pos0 = getelementptr inbounds i64, i64* %arr30, i64 0
  store i64 %arg10, i64* %arr30_pos0, align 8
  %blk_start_ptr = getelementptr inbounds i32, i32* %blk, i64 %arg10
  store i32 1, i32* %blk_start_ptr, align 4
  %cnt0 = load i64, i64* %arg20, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %arg18, i64 %cnt0
  store i64 %arg10, i64* %out_ptr0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %arg20, align 8
  br label %loop_check

loop_check:
  %psize = phi i64 [ 1, %after_init ], [ %psize_next, %loop_iter_end ]
  %ps_nonzero = icmp ne i64 %psize, 0
  br i1 %ps_nonzero, label %loop_body, label %finalize

loop_body:
  %ps_minus1 = add i64 %psize, -1
  %top_ptr = getelementptr inbounds i64, i64* %arr30, i64 %ps_minus1
  %curr = load i64, i64* %top_ptr, align 8
  %next_ptr_curr = getelementptr inbounds i64, i64* %arr28, i64 %curr
  %j0 = load i64, i64* %next_ptr_curr, align 8
  br label %inner_cond

inner_cond:
  %j = phi i64 [ %j0, %loop_body ], [ %j_inc, %inner_continue ]
  %j_lt_n = icmp ult i64 %j, %arg8
  br i1 %j_lt_n, label %check_edge, label %inner_done

check_edge:
  %mul = mul i64 %curr, %arg8
  %sum = add i64 %mul, %j
  %adj_ptr = getelementptr inbounds i32, i32* %arg0, i64 %sum
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_is_zero = icmp eq i32 %adj_val, 0
  br i1 %edge_is_zero, label %inner_continue, label %check_visited

inner_continue:
  %j_inc = add i64 %j, 1
  br label %inner_cond

check_visited:
  %blk_j_ptr = getelementptr inbounds i32, i32* %blk, i64 %j
  %blk_j_val = load i32, i32* %blk_j_ptr, align 4
  %is_visited = icmp ne i32 %blk_j_val, 0
  br i1 %is_visited, label %inner_continue, label %found_neighbor

found_neighbor:
  %jp1 = add i64 %j, 1
  store i64 %jp1, i64* %next_ptr_curr, align 8
  store i32 1, i32* %blk_j_ptr, align 4
  %cnt2 = load i64, i64* %arg20, align 8
  %out_ptr = getelementptr inbounds i64, i64* %arg18, i64 %cnt2
  store i64 %j, i64* %out_ptr, align 8
  %cnt3 = add i64 %cnt2, 1
  store i64 %cnt3, i64* %arg20, align 8
  %push_ptr = getelementptr inbounds i64, i64* %arr30, i64 %psize
  store i64 %j, i64* %push_ptr, align 8
  %psize_plus1 = add i64 %psize, 1
  br label %loop_iter_end

inner_done:
  %psize_pop = add i64 %psize, -1
  br label %loop_iter_end

loop_iter_end:
  %psize_next = phi i64 [ %psize_plus1, %found_neighbor ], [ %psize_pop, %inner_done ]
  br label %loop_check

finalize:
  call void @free(i8* %blk_raw)
  call void @free(i8* %arr28_raw)
  call void @free(i8* %arr30_raw)
  br label %ret

ret:
  ret void
}