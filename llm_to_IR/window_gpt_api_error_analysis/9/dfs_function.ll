; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %countptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %checkstart

checkstart:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %early

early:
  store i64 0, i64* %countptr, align 8
  ret void

alloc:
  %size_block_bytes = shl i64 %n, 2
  %ptr_block_i8 = call noalias i8* @malloc(i64 %size_block_bytes)
  %block = bitcast i8* %ptr_block_i8 to i32*
  %size_n8 = shl i64 %n, 3
  %ptr_next_i8 = call noalias i8* @malloc(i64 %size_n8)
  %next = bitcast i8* %ptr_next_i8 to i64*
  %ptr_stack_i8 = call noalias i8* @malloc(i64 %size_n8)
  %stack = bitcast i8* %ptr_stack_i8 to i64*
  %block_null = icmp eq i32* %block, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %tmp_or = or i1 %block_null, %next_null
  %anynull = or i1 %tmp_or, %stack_null
  br i1 %anynull, label %alloc_fail, label %init_loop

alloc_fail:
  %b_i8_fail = bitcast i32* %block to i8*
  call void @free(i8* %b_i8_fail)
  %n_i8_fail = bitcast i64* %next to i8*
  call void @free(i8* %n_i8_fail)
  %s_i8_fail = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8_fail)
  store i64 0, i64* %countptr, align 8
  ret void

init_loop:
  %i = phi i64 [ 0, %alloc ], [ %i.next, %init_body ]
  %cmp_init = icmp ult i64 %i, %n
  br i1 %cmp_init, label %init_body, label %after_init

init_body:
  %block_ptr_i = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block_ptr_i, align 4
  %next_ptr_i = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr_i, align 8
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  store i64 0, i64* %countptr, align 8
  %visited_start_ptr = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %visited_start_ptr, align 4
  %count_old0 = load i64, i64* %countptr, align 8
  %count_new0 = add i64 %count_old0, 1
  store i64 %count_new0, i64* %countptr, align 8
  %out_idx_ptr0 = getelementptr inbounds i64, i64* %out, i64 %count_old0
  store i64 %start, i64* %out_idx_ptr0, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  br label %main_loop

main_loop:
  %sp = phi i64 [ 1, %after_init ], [ %sp2, %after_inner_pop ]
  %sp_nonzero = icmp ne i64 %sp, 0
  br i1 %sp_nonzero, label %process_top, label %cleanup

process_top:
  %sp_minus1 = add i64 %sp, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_minus1
  %top = load i64, i64* %top_ptr, align 8
  %next_ptr_top = getelementptr inbounds i64, i64* %next, i64 %top
  %nbr_index0 = load i64, i64* %next_ptr_top, align 8
  br label %inner_loop

inner_loop:
  %nbr_index = phi i64 [ %nbr_index0, %process_top ], [ %nbr_index_inc, %skip_or_visited ]
  %has_more = icmp ult i64 %nbr_index, %n
  br i1 %has_more, label %check_edge, label %maybe_pop

check_edge:
  %mul = mul i64 %top, %n
  %lin = add i64 %mul, %nbr_index
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %lin
  %edge = load i32, i32* %adj_elem_ptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %skip_or_visited, label %check_visited

skip_or_visited:
  %nbr_index_inc = add i64 %nbr_index, 1
  br label %inner_loop

check_visited:
  %visited_ptr = getelementptr inbounds i32, i32* %block, i64 %nbr_index
  %visited_val = load i32, i32* %visited_ptr, align 4
  %is_visited = icmp ne i32 %visited_val, 0
  br i1 %is_visited, label %skip_or_visited, label %visit_new

visit_new:
  %nbr_plus1 = add i64 %nbr_index, 1
  store i64 %nbr_plus1, i64* %next_ptr_top, align 8
  store i32 1, i32* %visited_ptr, align 4
  %count_old = load i64, i64* %countptr, align 8
  %count_new = add i64 %count_old, 1
  store i64 %count_new, i64* %countptr, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out, i64 %count_old
  store i64 %nbr_index, i64* %out_pos_ptr, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %sp
  store i64 %nbr_index, i64* %stack_slot, align 8
  %sp_inc = add i64 %sp, 1
  br label %after_inner_pop

maybe_pop:
  %sp_dec = add i64 %sp, -1
  br label %after_inner_pop

after_inner_pop:
  %sp2 = phi i64 [ %sp_inc, %visit_new ], [ %sp_dec, %maybe_pop ]
  br label %main_loop

cleanup:
  %b_i8 = bitcast i32* %block to i8*
  call void @free(i8* %b_i8)
  %n_i8 = bitcast i64* %next to i8*
  call void @free(i8* %n_i8)
  %s_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8)
  ret void
}