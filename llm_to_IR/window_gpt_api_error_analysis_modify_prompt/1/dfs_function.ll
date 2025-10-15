; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @malloc(i64 noundef)
declare dso_local void @free(i8* noundef)

define dso_local void @dfs(i32* noundef %adj, i64 noundef %n, i64 noundef %start, i64* noundef %outArr, i64* noundef %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %early_or = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %early_or, label %early, label %alloc

early:
  store i64 0, i64* %outCount, align 8
  ret void

alloc:
  %size_vis = mul i64 %n, 4
  %malloc_vis = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %malloc_vis to i32*
  %size64 = shl i64 %n, 3
  %malloc_next = call i8* @malloc(i64 %size64)
  %nextIdx = bitcast i8* %malloc_next to i64*
  %malloc_stack = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %malloc_stack to i64*
  %vis_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %nextIdx, null
  %stack_null = icmp eq i64* %stack, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  %vis_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8)
  %next_i8 = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_i8)
  %stack_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8)
  store i64 0, i64* %outCount, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body_end ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %post_init

init_loop_body:
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %next.ptr, align 8
  br label %init_loop_body_end

init_loop_body_end:
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %outCount, align 8
  %stack.slot0.ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.slot0.ptr, align 8
  %sp1 = add i64 0, 1
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  %oldc0 = load i64, i64* %outCount, align 8
  %newc0 = add i64 %oldc0, 1
  store i64 %newc0, i64* %outCount, align 8
  %out.ptr0 = getelementptr inbounds i64, i64* %outArr, i64 %oldc0
  store i64 %start, i64* %out.ptr0, align 8
  br label %outer_check

outer_check:
  %sp.phi = phi i64 [ %sp1, %post_init ], [ %sp.cont, %outer_cont ]
  %cmpsp = icmp ne i64 %sp.phi, 0
  br i1 %cmpsp, label %outer_body, label %cleanup

outer_body:
  %spm1 = add i64 %sp.phi, -1
  %cur.ptr = getelementptr inbounds i64, i64* %stack, i64 %spm1
  %cur = load i64, i64* %cur.ptr, align 8
  %j0.ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %cur
  %j0 = load i64, i64* %j0.ptr, align 8
  br label %inner_loop_check

inner_loop_check:
  %j = phi i64 [ %j0, %outer_body ], [ %j.inc, %inner_loop_continue ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner_body, label %after_inner

inner_body:
  %mul = mul i64 %cur, %n
  %sum = add i64 %mul, %j
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %adj.ptr, align 4
  %isZeroEdge = icmp eq i32 %edge, 0
  br i1 %isZeroEdge, label %inner_if_else_inc, label %checkvisited

checkvisited:
  %vjp = getelementptr inbounds i32, i32* %visited, i64 %j
  %vj = load i32, i32* %vjp, align 4
  %vjzero = icmp eq i32 %vj, 0
  br i1 %vjzero, label %found_neighbor, label %inner_if_else_inc

found_neighbor:
  %jplus1 = add i64 %j, 1
  store i64 %jplus1, i64* %j0.ptr, align 8
  store i32 1, i32* %vjp, align 4
  %oldc1 = load i64, i64* %outCount, align 8
  %newc1 = add i64 %oldc1, 1
  store i64 %newc1, i64* %outCount, align 8
  %out.ptr1 = getelementptr inbounds i64, i64* %outArr, i64 %oldc1
  store i64 %j, i64* %out.ptr1, align 8
  %stack.slot = getelementptr inbounds i64, i64* %stack, i64 %sp.phi
  store i64 %j, i64* %stack.slot, align 8
  %sp.new = add i64 %sp.phi, 1
  br label %outer_cont

inner_if_else_inc:
  %j.inc = add i64 %j, 1
  br label %inner_loop_continue

inner_loop_continue:
  br label %inner_loop_check

after_inner:
  %eqn = icmp eq i64 %j, %n
  %sp.dec = add i64 %sp.phi, -1
  %sp.after = select i1 %eqn, i64 %sp.dec, i64 %sp.phi
  br label %outer_cont

outer_cont:
  %sp.cont = phi i64 [ %sp.new, %found_neighbor ], [ %sp.after, %after_inner ]
  br label %outer_check

cleanup:
  %vis_i8c = bitcast i32* %visited to i8*
  call void @free(i8* %vis_i8c)
  %next_i8c = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_i8c)
  %stack_i8c = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8c)
  ret void
}