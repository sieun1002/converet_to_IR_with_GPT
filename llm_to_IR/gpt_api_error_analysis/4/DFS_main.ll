; ModuleID = 'dfs_module'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_path, i64* %out_count) local_unnamed_addr nounwind {
entry:
  %visited.ptr = alloca i32*, align 8
  %next.ptr = alloca i64*, align 8
  %stack.ptr = alloca i64*, align 8
  %ssz = alloca i64, align 8
  %i = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %zero_ret, label %check_start

check_start:                                          ; preds = %entry
  %cmp_start = icmp uge i64 %start, %n
  br i1 %cmp_start, label %zero_ret, label %allocs

zero_ret:                                             ; preds = %check_start, %entry
  store i64 0, i64* %out_count, align 8
  br label %ret

allocs:                                               ; preds = %check_start
  %s1 = shl i64 %n, 2
  %p1 = call noalias i8* @malloc(i64 %s1)
  %v_c = bitcast i8* %p1 to i32*
  store i32* %v_c, i32** %visited.ptr, align 8
  %s2 = shl i64 %n, 3
  %p2 = call noalias i8* @malloc(i64 %s2)
  %n_c = bitcast i8* %p2 to i64*
  store i64* %n_c, i64** %next.ptr, align 8
  %s3 = shl i64 %n, 3
  %p3 = call noalias i8* @malloc(i64 %s3)
  %stk_c = bitcast i8* %p3 to i64*
  store i64* %stk_c, i64** %stack.ptr, align 8
  %visited_loaded = load i32*, i32** %visited.ptr, align 8
  %isnull_v = icmp eq i32* %visited_loaded, null
  %next_loaded = load i64*, i64** %next.ptr, align 8
  %isnull_n = icmp eq i64* %next_loaded, null
  %stack_loaded = load i64*, i64** %stack.ptr, align 8
  %isnull_s = icmp eq i64* %stack_loaded, null
  %anynull1 = or i1 %isnull_v, %isnull_n
  %anynull = or i1 %anynull1, %isnull_s
  br i1 %anynull, label %alloc_fail, label %init_loop_init

alloc_fail:                                           ; preds = %allocs
  br label %free_visited

free_visited:                                         ; preds = %alloc_fail
  %vptr1 = load i32*, i32** %visited.ptr, align 8
  %isnull_v2 = icmp eq i32* %vptr1, null
  br i1 %isnull_v2, label %free_next, label %do_free_v

do_free_v:                                            ; preds = %free_visited
  %vptr1_i8 = bitcast i32* %vptr1 to i8*
  call void @free(i8* %vptr1_i8)
  br label %free_next

free_next:                                            ; preds = %do_free_v, %free_visited
  %nptr1 = load i64*, i64** %next.ptr, align 8
  %isnull_n2 = icmp eq i64* %nptr1, null
  br i1 %isnull_n2, label %free_stack, label %do_free_n

do_free_n:                                            ; preds = %free_next
  %nptr1_i8 = bitcast i64* %nptr1 to i8*
  call void @free(i8* %nptr1_i8)
  br label %free_stack

free_stack:                                           ; preds = %do_free_n, %free_next
  %sptr1 = load i64*, i64** %stack.ptr, align 8
  %isnull_s2 = icmp eq i64* %sptr1, null
  br i1 %isnull_s2, label %after_fail_free, label %do_free_s

do_free_s:                                            ; preds = %free_stack
  %sptr1_i8 = bitcast i64* %sptr1 to i8*
  call void @free(i8* %sptr1_i8)
  br label %after_fail_free

after_fail_free:                                      ; preds = %do_free_s, %free_stack
  store i64 0, i64* %out_count, align 8
  br label %ret

init_loop_init:                                       ; preds = %allocs
  store i64 0, i64* %i, align 8
  br label %init_loop_cond

init_loop_cond:                                       ; preds = %init_loop_body, %init_loop_init
  %idx = load i64, i64* %i, align 8
  %cond_i = icmp ult i64 %idx, %n
  br i1 %cond_i, label %init_loop_body, label %after_init

init_loop_body:                                       ; preds = %init_loop_cond
  %vbase = load i32*, i32** %visited.ptr, align 8
  %vptr_gep = getelementptr i32, i32* %vbase, i64 %idx
  store i32 0, i32* %vptr_gep, align 4
  %nbase2 = load i64*, i64** %next.ptr, align 8
  %nptr_gep = getelementptr i64, i64* %nbase2, i64 %idx
  store i64 0, i64* %nptr_gep, align 8
  %idx1 = add i64 %idx, 1
  store i64 %idx1, i64* %i, align 8
  br label %init_loop_cond

after_init:                                           ; preds = %init_loop_cond
  store i64 0, i64* %ssz, align 8
  store i64 0, i64* %out_count, align 8
  %ssz0 = load i64, i64* %ssz, align 8
  %stack_base = load i64*, i64** %stack.ptr, align 8
  %stack_gep = getelementptr i64, i64* %stack_base, i64 %ssz0
  store i64 %start, i64* %stack_gep, align 8
  %ssz1 = add i64 %ssz0, 1
  store i64 %ssz1, i64* %ssz, align 8
  %vbase2 = load i32*, i32** %visited.ptr, align 8
  %v_gep_s = getelementptr i32, i32* %vbase2, i64 %start
  store i32 1, i32* %v_gep_s, align 4
  %cnt0 = load i64, i64* %out_count, align 8
  %opath_gep0 = getelementptr i64, i64* %out_path, i64 %cnt0
  store i64 %start, i64* %opath_gep0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  br label %outer_cond

outer_cond:                                           ; preds = %after_inner, %found_neighbor, %after_init
  %ssz_load = load i64, i64* %ssz, align 8
  %has_items = icmp ne i64 %ssz_load, 0
  br i1 %has_items, label %outer_body, label %cleanup

outer_body:                                           ; preds = %outer_cond
  %ssz_dec1 = add i64 %ssz_load, -1
  %stack_base2 = load i64*, i64** %stack.ptr, align 8
  %stack_top_ptr = getelementptr i64, i64* %stack_base2, i64 %ssz_dec1
  %uval = load i64, i64* %stack_top_ptr, align 8
  store i64 %uval, i64* %u, align 8
  %next_base3 = load i64*, i64** %next.ptr, align 8
  %next_u_ptr = getelementptr i64, i64* %next_base3, i64 %uval
  %v_from_next = load i64, i64* %next_u_ptr, align 8
  store i64 %v_from_next, i64* %v, align 8
  br label %inner_cond

inner_cond:                                           ; preds = %v_inc, %outer_body
  %v_cur = load i64, i64* %v, align 8
  %v_lt = icmp ult i64 %v_cur, %n
  br i1 %v_lt, label %check_neighbor, label %after_inner

check_neighbor:                                       ; preds = %inner_cond
  %mul = mul i64 %uval, %n
  %sum = add i64 %mul, %v_cur
  %adj_gep = getelementptr i32, i32* %adj, i64 %sum
  %adj_val = load i32, i32* %adj_gep, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %v_inc, label %check_visited

check_visited:                                        ; preds = %check_neighbor
  %vbase3 = load i32*, i32** %visited.ptr, align 8
  %v_ptr2 = getelementptr i32, i32* %vbase3, i64 %v_cur
  %vis_val = load i32, i32* %v_ptr2, align 4
  %is_vis = icmp ne i32 %vis_val, 0
  br i1 %is_vis, label %v_inc, label %found_neighbor

found_neighbor:                                       ; preds = %check_visited
  %v_plus1 = add i64 %v_cur, 1
  store i64 %v_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %v_ptr2, align 4
  %cnt2 = load i64, i64* %out_count, align 8
  %opath_ptr2 = getelementptr i64, i64* %out_path, i64 %cnt2
  store i64 %v_cur, i64* %opath_ptr2, align 8
  %cnt3 = add i64 %cnt2, 1
  store i64 %cnt3, i64* %out_count, align 8
  %ssz_curr = load i64, i64* %ssz, align 8
  %stack_push_ptr = getelementptr i64, i64* %stack_base2, i64 %ssz_curr
  store i64 %v_cur, i64* %stack_push_ptr, align 8
  %ssz_new = add i64 %ssz_curr, 1
  store i64 %ssz_new, i64* %ssz, align 8
  br label %outer_cond

v_inc:                                                ; preds = %check_visited, %check_neighbor
  %v_next = add i64 %v_cur, 1
  store i64 %v_next, i64* %v, align 8
  br label %inner_cond

after_inner:                                          ; preds = %inner_cond
  %ssz_pop = add i64 %ssz_load, -1
  store i64 %ssz_pop, i64* %ssz, align 8
  br label %outer_cond

cleanup:                                              ; preds = %outer_cond
  %vptr_free = load i32*, i32** %visited.ptr, align 8
  %vptr_free_i8 = bitcast i32* %vptr_free to i8*
  call void @free(i8* %vptr_free_i8)
  %nptr_free = load i64*, i64** %next.ptr, align 8
  %nptr_free_i8 = bitcast i64* %nptr_free to i8*
  call void @free(i8* %nptr_free_i8)
  %sptr_free = load i64*, i64** %stack.ptr, align 8
  %sptr_free_i8 = bitcast i64* %sptr_free to i8*
  call void @free(i8* %sptr_free_i8)
  br label %ret

ret:                                                  ; preds = %cleanup, %after_fail_free, %zero_ret
  ret void
}