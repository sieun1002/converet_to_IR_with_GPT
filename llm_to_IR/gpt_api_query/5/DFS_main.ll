; ModuleID = 'dfs_module'
source_filename = "dfs.ll"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %visited_ptr = alloca i32*, align 8
  %next_ptr = alloca i64*, align 8
  %stack_ptr = alloca i64*, align 8
  %i = alloca i64, align 8
  %stack_size = alloca i64, align 8
  %current = alloca i64, align 8
  %neighbor = alloca i64, align 8

  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_return, label %alloc

early_return:                                     ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

alloc:                                            ; preds = %entry
  %sz4 = shl i64 %n, 2
  %p1 = call i8* @malloc(i64 %sz4)
  %visited = bitcast i8* %p1 to i32*
  store i32* %visited, i32** %visited_ptr, align 8

  %sz8 = shl i64 %n, 3
  %p2 = call i8* @malloc(i64 %sz8)
  %next = bitcast i8* %p2 to i64*
  store i64* %next, i64** %next_ptr, align 8

  %p3 = call i8* @malloc(i64 %sz8)
  %stack = bitcast i8* %p3 to i64*
  store i64* %stack, i64** %stack_ptr, align 8

  %visited_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %tmp1 = or i1 %visited_null, %next_null
  %anynull = or i1 %tmp1, %stack_null
  br i1 %anynull, label %alloc_fail, label %init_zero

alloc_fail:                                       ; preds = %alloc
  %p1_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %p1_i8)
  %p2_i8 = bitcast i64* %next to i8*
  call void @free(i8* %p2_i8)
  %p3_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %p3_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init_zero:                                        ; preds = %alloc
  store i64 0, i64* %i, align 8
  br label %init_loop_cond

init_loop_cond:                                   ; preds = %init_loop_body, %init_zero
  %i_val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i_val, %n
  br i1 %cmp, label %init_loop_body, label %after_init

init_loop_body:                                   ; preds = %init_loop_cond
  %vi_ptr0 = load i32*, i32** %visited_ptr, align 8
  %vi_elem_ptr = getelementptr inbounds i32, i32* %vi_ptr0, i64 %i_val
  store i32 0, i32* %vi_elem_ptr, align 4

  %nx_ptr0 = load i64*, i64** %next_ptr, align 8
  %nx_elem_ptr = getelementptr inbounds i64, i64* %nx_ptr0, i64 %i_val
  store i64 0, i64* %nx_elem_ptr, align 8

  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %init_loop_cond

after_init:                                       ; preds = %init_loop_cond
  store i64 0, i64* %stack_size, align 8
  store i64 0, i64* %out_count, align 8

  %ss0 = load i64, i64* %stack_size, align 8
  %stack0 = load i64*, i64** %stack_ptr, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stack0, i64 %ss0
  store i64 %start, i64* %stack_slot, align 8
  %ss1 = add i64 %ss0, 1
  store i64 %ss1, i64* %stack_size, align 8

  %vi0 = load i32*, i32** %visited_ptr, align 8
  %visited_start_ptr = getelementptr inbounds i32, i32* %vi0, i64 %start
  store i32 1, i32* %visited_start_ptr, align 4

  %count0 = load i64, i64* %out_count, align 8
  %out_elem_ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_elem_ptr, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_count, align 8

  br label %while_outer_cond

while_outer_cond:                                 ; preds = %pop_stack, %after_inner, %found_neighbor, %after_init
  %sz = load i64, i64* %stack_size, align 8
  %cond_nonzero = icmp ne i64 %sz, 0
  br i1 %cond_nonzero, label %while_outer_body, label %done

while_outer_body:                                 ; preds = %while_outer_cond
  %sz1 = load i64, i64* %stack_size, align 8
  %top_index = add i64 %sz1, -1
  %stackp = load i64*, i64** %stack_ptr, align 8
  %top_ptr = getelementptr inbounds i64, i64* %stackp, i64 %top_index
  %curval = load i64, i64* %top_ptr, align 8
  store i64 %curval, i64* %current, align 8

  %nextp = load i64*, i64** %next_ptr, align 8
  %curval2 = load i64, i64* %current, align 8
  %next_elem_ptr2 = getelementptr inbounds i64, i64* %nextp, i64 %curval2
  %neighbor0 = load i64, i64* %next_elem_ptr2, align 8
  store i64 %neighbor0, i64* %neighbor, align 8

  br label %while_inner_cond

while_inner_cond:                                 ; preds = %inc_neighbor, %while_outer_body
  %neigh = load i64, i64* %neighbor, align 8
  %lt = icmp ult i64 %neigh, %n
  br i1 %lt, label %while_inner_body, label %after_inner

while_inner_body:                                 ; preds = %while_inner_cond
  %cur3 = load i64, i64* %current, align 8
  %mul = mul i64 %cur3, %n
  %idx = add i64 %mul, %neigh
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  br i1 %adj_nonzero, label %check_visited, label %inc_neighbor

check_visited:                                    ; preds = %while_inner_body
  %visitedp = load i32*, i32** %visited_ptr, align 8
  %visited_elem_ptr = getelementptr inbounds i32, i32* %visitedp, i64 %neigh
  %v = load i32, i32* %visited_elem_ptr, align 4
  %is_zero = icmp eq i32 %v, 0
  br i1 %is_zero, label %found_neighbor, label %inc_neighbor

found_neighbor:                                   ; preds = %check_visited
  %np = load i64*, i64** %next_ptr, align 8
  %curr = load i64, i64* %current, align 8
  %next_slot = getelementptr inbounds i64, i64* %np, i64 %curr
  %neigh1 = load i64, i64* %neighbor, align 8
  %neigh_plus1 = add i64 %neigh1, 1
  store i64 %neigh_plus1, i64* %next_slot, align 8

  %visitedp2 = load i32*, i32** %visited_ptr, align 8
  %visit_slot2 = getelementptr inbounds i32, i32* %visitedp2, i64 %neigh1
  store i32 1, i32* %visit_slot2, align 4

  %cntA = load i64, i64* %out_count, align 8
  %out_slotA = getelementptr inbounds i64, i64* %out, i64 %cntA
  store i64 %neigh1, i64* %out_slotA, align 8
  %cntB = add i64 %cntA, 1
  store i64 %cntB, i64* %out_count, align 8

  %ssA = load i64, i64* %stack_size, align 8
  %stackpA = load i64*, i64** %stack_ptr, align 8
  %slotA = getelementptr inbounds i64, i64* %stackpA, i64 %ssA
  store i64 %neigh1, i64* %slotA, align 8
  %ssB = add i64 %ssA, 1
  store i64 %ssB, i64* %stack_size, align 8

  br label %while_outer_cond

inc_neighbor:                                     ; preds = %check_visited, %while_inner_body
  %nval = load i64, i64* %neighbor, align 8
  %nval1 = add i64 %nval, 1
  store i64 %nval1, i64* %neighbor, align 8
  br label %while_inner_cond

after_inner:                                      ; preds = %while_inner_cond
  %neigh_end = load i64, i64* %neighbor, align 8
  %is_end = icmp eq i64 %neigh_end, %n
  br i1 %is_end, label %pop_stack, label %while_outer_cond

pop_stack:                                        ; preds = %after_inner
  %ssC = load i64, i64* %stack_size, align 8
  %ssD = add i64 %ssC, -1
  store i64 %ssD, i64* %stack_size, align 8
  br label %while_outer_cond

done:                                             ; preds = %while_outer_cond
  %visited_final = load i32*, i32** %visited_ptr, align 8
  %p1final = bitcast i32* %visited_final to i8*
  call void @free(i8* %p1final)
  %next_final = load i64*, i64** %next_ptr, align 8
  %p2final = bitcast i64* %next_final to i8*
  call void @free(i8* %p2final)
  %stack_final = load i64*, i64** %stack_ptr, align 8
  %p3final = bitcast i64* %stack_final to i8*
  call void @free(i8* %p3final)
  ret void
}