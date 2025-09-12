; ModuleID = 'dfs_from_binary'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) {
entry:
  %n_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_zero, %start_ge_n
  br i1 %bad, label %early_ret, label %alloc

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

alloc:
  %size_vis = mul i64 %n, 4
  %vis_raw = call i8* @malloc(i64 %size_vis)
  %size64 = mul i64 %n, 8
  %next_raw = call i8* @malloc(i64 %size64)
  %stack_raw = call i8* @malloc(i64 %size64)
  %vis = bitcast i8* %vis_raw to i32*
  %next = bitcast i8* %next_raw to i64*
  %stack = bitcast i8* %stack_raw to i64*
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_body ]
  %init_cond = icmp ult i64 %i, %n
  br i1 %init_cond, label %init_body, label %after_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  store i64 0, i64* %out_count, align 8
  %stack0_ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0_ptr, align 8
  %vis_start = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start, align 4
  %oldcnt0 = load i64, i64* %out_count, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %oldcnt0
  store i64 %start, i64* %out_ptr0, align 8
  %newcnt0 = add i64 %oldcnt0, 1
  store i64 %newcnt0, i64* %out_count, align 8
  br label %outer_loop_header

outer_loop_header:
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size_inc, %found_neighbor ], [ %stack_size_dec, %after_inner ]
  %nonempty = icmp ne i64 %stack_size, 0
  br i1 %nonempty, label %outer_body, label %cleanup

outer_body:
  %top_idx = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %top = load i64, i64* %top_ptr, align 8
  %next_top_ptr = getelementptr inbounds i64, i64* %next, i64 %top
  %i0 = load i64, i64* %next_top_ptr, align 8
  br label %inner_header

inner_header:
  %i_cur = phi i64 [ %i0, %outer_body ], [ %i_next, %inner_step ]
  %cond_i = icmp ult i64 %i_cur, %n
  br i1 %cond_i, label %check_edge, label %after_inner

check_edge:
  %mul = mul i64 %top, %n
  %idx = add i64 %mul, %i_cur
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_nonzero = icmp ne i32 %adj_val, 0
  br i1 %edge_nonzero, label %check_visited, label %inner_step

check_visited:
  %vis_i_ptr = getelementptr inbounds i32, i32* %vis, i64 %i_cur
  %vis_i = load i32, i32* %vis_i_ptr, align 4
  %not_visited = icmp eq i32 %vis_i, 0
  br i1 %not_visited, label %found_neighbor, label %inner_step

found_neighbor:
  %i_plus1 = add i64 %i_cur, 1
  store i64 %i_plus1, i64* %next_top_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %oldcnt = load i64, i64* %out_count, align 8
  %out_ptr_i = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %i_cur, i64* %out_ptr_i, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %out_count, align 8
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %i_cur, i64* %stack_top_ptr, align 8
  %stack_size_inc = add i64 %stack_size, 1
  br label %outer_loop_header

inner_step:
  %i_next = add i64 %i_cur, 1
  br label %inner_header

after_inner:
  %stack_size_dec = add i64 %stack_size, -1
  br label %outer_loop_header

cleanup:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}