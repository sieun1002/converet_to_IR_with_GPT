; ModuleID = 'dfs'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %arg0, i64 %arg1, i64 %arg2, i64* %arg3, i64* %arg4) {
entry:
  %visited = alloca i32*, align 8
  %iter = alloca i64*, align 8
  %stack = alloca i64*, align 8
  %sp = alloca i64, align 8
  %i = alloca i64, align 8
  %neighbor = alloca i64, align 8
  %curr = alloca i64, align 8
  %cmp0 = icmp eq i64 %arg1, 0
  br i1 %cmp0, label %init_fail, label %check_start

check_start:
  %cmp1 = icmp ult i64 %arg2, %arg1
  br i1 %cmp1, label %allocs, label %init_fail

init_fail:
  store i64 0, i64* %arg4, align 8
  br label %exit

allocs:
  %size_block = shl i64 %arg1, 2
  %m1 = call i8* @malloc(i64 %size_block)
  %p1c = bitcast i8* %m1 to i32*
  store i32* %p1c, i32** %visited, align 8
  %size_iter = shl i64 %arg1, 3
  %m2 = call i8* @malloc(i64 %size_iter)
  %p2c = bitcast i8* %m2 to i64*
  store i64* %p2c, i64** %iter, align 8
  %m3 = call i8* @malloc(i64 %size_iter)
  %p3c = bitcast i8* %m3 to i64*
  store i64* %p3c, i64** %stack, align 8
  %isnull1 = icmp eq i32* %p1c, null
  %isnull2 = icmp eq i64* %p2c, null
  %isnull3 = icmp eq i64* %p3c, null
  %tmp_or = or i1 %isnull1, %isnull2
  %anynull = or i1 %tmp_or, %isnull3
  br i1 %anynull, label %alloc_fail, label %init_loop_start

alloc_fail:
  %bc1 = bitcast i32* %p1c to i8*
  call void @free(i8* %bc1)
  %bc2 = bitcast i64* %p2c to i8*
  call void @free(i8* %bc2)
  %bc3 = bitcast i64* %p3c to i8*
  call void @free(i8* %bc3)
  store i64 0, i64* %arg4, align 8
  br label %exit

init_loop_start:
  store i64 0, i64* %i, align 8
  br label %loop_i_cmp

loop_i_cmp:
  %ival = load i64, i64* %i, align 8
  %cond = icmp ult i64 %ival, %arg1
  br i1 %cond, label %loop_i_body, label %after_init

loop_i_body:
  %vptr = load i32*, i32** %visited, align 8
  %v_elem_ptr = getelementptr inbounds i32, i32* %vptr, i64 %ival
  store i32 0, i32* %v_elem_ptr, align 4
  %itptr = load i64*, i64** %iter, align 8
  %it_elem_ptr = getelementptr inbounds i64, i64* %itptr, i64 %ival
  store i64 0, i64* %it_elem_ptr, align 8
  %inc = add i64 %ival, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_i_cmp

after_init:
  store i64 0, i64* %sp, align 8
  store i64 0, i64* %arg4, align 8
  %oldsp = load i64, i64* %sp, align 8
  %newsp = add i64 %oldsp, 1
  store i64 %newsp, i64* %sp, align 8
  %stackptr = load i64*, i64** %stack, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stackptr, i64 %oldsp
  store i64 %arg2, i64* %stack_slot, align 8
  %vptr2 = load i32*, i32** %visited, align 8
  %vstartptr = getelementptr inbounds i32, i32* %vptr2, i64 %arg2
  store i32 1, i32* %vstartptr, align 4
  %count_old = load i64, i64* %arg4, align 8
  %count_new = add i64 %count_old, 1
  store i64 %count_new, i64* %arg4, align 8
  %out_ptr = getelementptr inbounds i64, i64* %arg3, i64 %count_old
  store i64 %arg2, i64* %out_ptr, align 8
  br label %while_cmp

while_cmp:
  %spval = load i64, i64* %sp, align 8
  %has = icmp ne i64 %spval, 0
  br i1 %has, label %loop_top, label %cleanup

loop_top:
  %idxm1 = add i64 %spval, -1
  %stptr = load i64*, i64** %stack, align 8
  %tos_ptr = getelementptr inbounds i64, i64* %stptr, i64 %idxm1
  %tos = load i64, i64* %tos_ptr, align 8
  store i64 %tos, i64* %curr, align 8
  %itptr2 = load i64*, i64** %iter, align 8
  %it_elem_ptr2 = getelementptr inbounds i64, i64* %itptr2, i64 %tos
  %next = load i64, i64* %it_elem_ptr2, align 8
  store i64 %next, i64* %neighbor, align 8
  br label %for_cmp

for_cmp:
  %neighbor_val = load i64, i64* %neighbor, align 8
  %cond2 = icmp ult i64 %neighbor_val, %arg1
  br i1 %cond2, label %for_body, label %after_for

for_body:
  %curr_val = load i64, i64* %curr, align 8
  %mul = mul i64 %curr_val, %arg1
  %sum = add i64 %mul, %neighbor_val
  %adj_ptr = getelementptr inbounds i32, i32* %arg0, i64 %sum
  %adj = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj, 0
  br i1 %is_zero, label %inc_neighbor, label %check_visited

check_visited:
  %vptr3 = load i32*, i32** %visited, align 8
  %vnb_ptr = getelementptr inbounds i32, i32* %vptr3, i64 %neighbor_val
  %vis = load i32, i32* %vnb_ptr, align 4
  %vis_bool = icmp ne i32 %vis, 0
  br i1 %vis_bool, label %inc_neighbor, label %found_neighbor

found_neighbor:
  %np1 = add i64 %neighbor_val, 1
  store i64 %np1, i64* %it_elem_ptr2, align 8
  store i32 1, i32* %vnb_ptr, align 4
  %oldcnt2 = load i64, i64* %arg4, align 8
  %newcnt2 = add i64 %oldcnt2, 1
  store i64 %newcnt2, i64* %arg4, align 8
  %out_ptr2 = getelementptr inbounds i64, i64* %arg3, i64 %oldcnt2
  store i64 %neighbor_val, i64* %out_ptr2, align 8
  %sp_before_push = load i64, i64* %sp, align 8
  %sp_after_push = add i64 %sp_before_push, 1
  store i64 %sp_after_push, i64* %sp, align 8
  %stackptr2 = load i64*, i64** %stack, align 8
  %slot2 = getelementptr inbounds i64, i64* %stackptr2, i64 %sp_before_push
  store i64 %neighbor_val, i64* %slot2, align 8
  br label %after_for

inc_neighbor:
  %incn = add i64 %neighbor_val, 1
  store i64 %incn, i64* %neighbor, align 8
  br label %for_cmp

after_for:
  %neighbor_final = load i64, i64* %neighbor, align 8
  %eqN = icmp eq i64 %neighbor_final, %arg1
  br i1 %eqN, label %pop, label %while_cmp

pop:
  %sp_now = load i64, i64* %sp, align 8
  %sp_dec = sub i64 %sp_now, 1
  store i64 %sp_dec, i64* %sp, align 8
  br label %while_cmp

cleanup:
  %vp = load i32*, i32** %visited, align 8
  %ip = load i64*, i64** %iter, align 8
  %sptr = load i64*, i64** %stack, align 8
  %vpi8 = bitcast i32* %vp to i8*
  call void @free(i8* %vpi8)
  %ipi8 = bitcast i64* %ip to i8*
  call void @free(i8* %ipi8)
  %sptri8 = bitcast i64* %sptr to i8*
  call void @free(i8* %sptri8)
  ret void

exit:
  ret void
}