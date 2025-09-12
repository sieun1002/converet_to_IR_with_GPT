; LLVM 14 IR for: void dfs(i32* adj, i64 n, i64 start, i64* out, i64* pcount)

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %pcount) {
entry:
  %visited = alloca i32*, align 8
  %next = alloca i64*, align 8
  %stack = alloca i64*, align 8
  %i = alloca i64, align 8
  %depth = alloca i64, align 8
  %u = alloca i64, align 8
  %it = alloca i64, align 8

  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %pcount
  ret void

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %allocs, label %early_zero

allocs:
  %n4 = shl i64 %n, 2
  %p1 = call i8* @malloc(i64 %n4)
  %vis = bitcast i8* %p1 to i32*
  store i32* %vis, i32** %visited
  %n8 = shl i64 %n, 3
  %p2 = call i8* @malloc(i64 %n8)
  %nextArr = bitcast i8* %p2 to i64*
  store i64* %nextArr, i64** %next
  %p3 = call i8* @malloc(i64 %n8)
  %stackArr = bitcast i8* %p3 to i64*
  store i64* %stackArr, i64** %stack

  %vis_null = icmp eq i32* %vis, null
  %next_null = icmp eq i64* %nextArr, null
  %stack_null = icmp eq i64* %stackArr, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  %vis_i8 = bitcast i32* %vis to i8*
  call void @free(i8* %vis_i8)
  %next_i8 = bitcast i64* %nextArr to i8*
  call void @free(i8* %next_i8)
  %stack_i8 = bitcast i64* %stackArr to i8*
  call void @free(i8* %stack_i8)
  store i64 0, i64* %pcount
  ret void

init_loop:
  store i64 0, i64* %i
  br label %init_cond

init_cond:
  %i_val = load i64, i64* %i
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %init_body, label %post_init

init_body:
  %vis_ptr = load i32*, i32** %visited
  %vis_gep = getelementptr inbounds i32, i32* %vis_ptr, i64 %i_val
  store i32 0, i32* %vis_gep, align 4
  %next_ptr = load i64*, i64** %next
  %next_gep = getelementptr inbounds i64, i64* %next_ptr, i64 %i_val
  store i64 0, i64* %next_gep, align 8
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i
  br label %init_cond

post_init:
  store i64 0, i64* %depth
  store i64 0, i64* %pcount

  %depth0 = load i64, i64* %depth
  %stack_ptr = load i64*, i64** %stack
  %stack_slot = getelementptr inbounds i64, i64* %stack_ptr, i64 %depth0
  store i64 %start, i64* %stack_slot, align 8
  %depth1 = add i64 %depth0, 1
  store i64 %depth1, i64* %depth

  %vis_ptr2 = load i32*, i32** %visited
  %vis_start = getelementptr inbounds i32, i32* %vis_ptr2, i64 %start
  store i32 1, i32* %vis_start, align 4

  %cnt0 = load i64, i64* %pcount
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_slot, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %pcount

  br label %outer_check

outer_check:
  %depth_cur = load i64, i64* %depth
  %depth_nonzero = icmp ne i64 %depth_cur, 0
  br i1 %depth_nonzero, label %outer_body, label %cleanup

outer_body:
  %dm1 = add i64 %depth_cur, -1
  %stack_ptr3 = load i64*, i64** %stack
  %u_ptr = getelementptr inbounds i64, i64* %stack_ptr3, i64 %dm1
  %u_val = load i64, i64* %u_ptr, align 8
  store i64 %u_val, i64* %u

  %next_ptr3 = load i64*, i64** %next
  %next_u_ptr = getelementptr inbounds i64, i64* %next_ptr3, i64 %u_val
  %it_val = load i64, i64* %next_u_ptr, align 8
  store i64 %it_val, i64* %it
  br label %inner_check

inner_check:
  %it_cur = load i64, i64* %it
  %it_lt_n = icmp ult i64 %it_cur, %n
  br i1 %it_lt_n, label %inner_body, label %after_inner

inner_body:
  %u_val2 = load i64, i64* %u
  %mul = mul i64 %u_val2, %n
  %idx = add i64 %mul, %it_cur
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge_val = load i32, i32* %adj_elem_ptr, align 4
  %edge_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_zero, label %inner_inc, label %check_unvisited

check_unvisited:
  %vis_ptr3 = load i32*, i32** %visited
  %vis_it_ptr = getelementptr inbounds i32, i32* %vis_ptr3, i64 %it_cur
  %vis_it = load i32, i32* %vis_it_ptr, align 4
  %vis_is_zero = icmp eq i32 %vis_it, 0
  br i1 %vis_is_zero, label %take_edge, label %inner_inc

take_edge:
  %it_plus1 = add i64 %it_cur, 1
  store i64 %it_plus1, i64* %next_u_ptr

  store i32 1, i32* %vis_it_ptr, align 4

  %cntA = load i64, i64* %pcount
  %out_slotA = getelementptr inbounds i64, i64* %out, i64 %cntA
  store i64 %it_cur, i64* %out_slotA, align 8
  %cntA1 = add i64 %cntA, 1
  store i64 %cntA1, i64* %pcount

  %stack_ptrA = load i64*, i64** %stack
  %stack_at_depth = getelementptr inbounds i64, i64* %stack_ptrA, i64 %depth_cur
  store i64 %it_cur, i64* %stack_at_depth, align 8
  %depth_inc = add i64 %depth_cur, 1
  store i64 %depth_inc, i64* %depth

  br label %outer_check

inner_inc:
  %it_next = add i64 %it_cur, 1
  store i64 %it_next, i64* %it
  br label %inner_check

after_inner:
  %it_end = load i64, i64* %it
  %it_eq_n = icmp eq i64 %it_end, %n
  br i1 %it_eq_n, label %pop, label %outer_check

pop:
  %depth_dec = add i64 %depth_cur, -1
  store i64 %depth_dec, i64* %depth
  br label %outer_check

cleanup:
  %vis_p = load i32*, i32** %visited
  %vis_p_i8 = bitcast i32* %vis_p to i8*
  call void @free(i8* %vis_p_i8)
  %next_p = load i64*, i64** %next
  %next_p_i8 = bitcast i64* %next_p to i8*
  call void @free(i8* %next_p_i8)
  %stack_p = load i64*, i64** %stack
  %stack_p_i8 = bitcast i64* %stack_p to i8*
  call void @free(i8* %stack_p_i8)
  ret void
}