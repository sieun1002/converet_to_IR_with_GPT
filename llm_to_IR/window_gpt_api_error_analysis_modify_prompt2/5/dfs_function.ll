; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %arg0, i64 %arg1, i64 %arg2, i64* %arg3, i64* %arg4) {
entry:
  %block = alloca i32*, align 8
  %arr28 = alloca i64*, align 8
  %arr30 = alloca i64*, align 8
  %i = alloca i64, align 8
  %stack_size = alloca i64, align 8
  %neighbor = alloca i64, align 8
  %current = alloca i64, align 8
  %cmp0 = icmp eq i64 %arg1, 0
  br i1 %cmp0, label %invalid, label %checkstart

checkstart:
  %cmp1 = icmp ult i64 %arg2, %arg1
  br i1 %cmp1, label %alloc, label %invalid

invalid:
  store i64 0, i64* %arg4, align 8
  br label %ret

alloc:
  %sizeBlock = shl i64 %arg1, 2
  %blkraw = call i8* @malloc(i64 %sizeBlock)
  %blk = bitcast i8* %blkraw to i32*
  store i32* %blk, i32** %block, align 8
  %size64 = shl i64 %arg1, 3
  %arr28raw = call i8* @malloc(i64 %size64)
  %arr28ptr = bitcast i8* %arr28raw to i64*
  store i64* %arr28ptr, i64** %arr28, align 8
  %arr30raw = call i8* @malloc(i64 %size64)
  %arr30ptr = bitcast i8* %arr30raw to i64*
  store i64* %arr30ptr, i64** %arr30, align 8
  %blk_isnull = icmp eq i32* %blk, null
  %arr28_isnull = icmp eq i64* %arr28ptr, null
  %arr30_isnull = icmp eq i64* %arr30ptr, null
  %anynull1 = or i1 %blk_isnull, %arr28_isnull
  %anynull = or i1 %anynull1, %arr30_isnull
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  %blkraw2 = bitcast i32* %blk to i8*
  call void @free(i8* %blkraw2)
  %arr28raw2 = bitcast i64* %arr28ptr to i8*
  call void @free(i8* %arr28raw2)
  %arr30raw2 = bitcast i64* %arr30ptr to i8*
  call void @free(i8* %arr30raw2)
  store i64 0, i64* %arg4, align 8
  br label %ret

init:
  store i64 0, i64* %i, align 8
  br label %init_loop_cond

init_loop_cond:
  %i_val = load i64, i64* %i, align 8
  %cond_init = icmp ult i64 %i_val, %arg1
  br i1 %cond_init, label %init_loop_body, label %after_init

init_loop_body:
  %blkptr1 = load i32*, i32** %block, align 8
  %gep_blk_i = getelementptr inbounds i32, i32* %blkptr1, i64 %i_val
  store i32 0, i32* %gep_blk_i, align 4
  %arr28ptr1 = load i64*, i64** %arr28, align 8
  %gep_arr28_i = getelementptr inbounds i64, i64* %arr28ptr1, i64 %i_val
  store i64 0, i64* %gep_arr28_i, align 8
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %init_loop_cond

after_init:
  store i64 0, i64* %stack_size, align 8
  store i64 0, i64* %arg4, align 8
  %ss0 = load i64, i64* %stack_size, align 8
  %ss_inc = add i64 %ss0, 1
  store i64 %ss_inc, i64* %stack_size, align 8
  %arr30ptr3 = load i64*, i64** %arr30, align 8
  %slot_ptr = getelementptr inbounds i64, i64* %arr30ptr3, i64 %ss0
  store i64 %arg2, i64* %slot_ptr, align 8
  %blkptr2 = load i32*, i32** %block, align 8
  %blk_at_start = getelementptr inbounds i32, i32* %blkptr2, i64 %arg2
  store i32 1, i32* %blk_at_start, align 4
  %count0 = load i64, i64* %arg4, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %arg4, align 8
  %out_idx_ptr = getelementptr inbounds i64, i64* %arg3, i64 %count0
  store i64 %arg2, i64* %out_idx_ptr, align 8
  br label %outer_check

outer_check:
  %ss_cur = load i64, i64* %stack_size, align 8
  %ss_nonzero = icmp ne i64 %ss_cur, 0
  br i1 %ss_nonzero, label %outer_body, label %cleanup

outer_body:
  %ss_cur2 = load i64, i64* %stack_size, align 8
  %idx_topm1 = add i64 %ss_cur2, -1
  %arr30ptr4 = load i64*, i64** %arr30, align 8
  %top_ptr = getelementptr inbounds i64, i64* %arr30ptr4, i64 %idx_topm1
  %top_val = load i64, i64* %top_ptr, align 8
  store i64 %top_val, i64* %current, align 8
  %arr28ptr4 = load i64*, i64** %arr28, align 8
  %cur_val = load i64, i64* %current, align 8
  %cur_nei_ptr = getelementptr inbounds i64, i64* %arr28ptr4, i64 %cur_val
  %nei0 = load i64, i64* %cur_nei_ptr, align 8
  store i64 %nei0, i64* %neighbor, align 8
  br label %inner_check

inner_check:
  %nei_cur = load i64, i64* %neighbor, align 8
  %nei_lt = icmp ult i64 %nei_cur, %arg1
  br i1 %nei_lt, label %inner_body, label %after_inner

inner_body:
  %cur_val2 = load i64, i64* %current, align 8
  %mul = mul i64 %cur_val2, %arg1
  %sum = add i64 %mul, %nei_cur
  %adj_ptr = getelementptr inbounds i32, i32* %arg0, i64 %sum
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %adj_val, 0
  br i1 %edge_zero, label %inc_neighbor, label %check_visited

check_visited:
  %blkptr3 = load i32*, i32** %block, align 8
  %blk_nei_ptr = getelementptr inbounds i32, i32* %blkptr3, i64 %nei_cur
  %blk_nei_val = load i32, i32* %blk_nei_ptr, align 4
  %visited = icmp ne i32 %blk_nei_val, 0
  br i1 %visited, label %inc_neighbor, label %found_unvisited

found_unvisited:
  %nei_plus1 = add i64 %nei_cur, 1
  store i64 %nei_plus1, i64* %cur_nei_ptr, align 8
  store i32 1, i32* %blk_nei_ptr, align 4
  %count_before = load i64, i64* %arg4, align 8
  %count_after = add i64 %count_before, 1
  store i64 %count_after, i64* %arg4, align 8
  %out_ptr2 = getelementptr inbounds i64, i64* %arg3, i64 %count_before
  store i64 %nei_cur, i64* %out_ptr2, align 8
  %ss_before = load i64, i64* %stack_size, align 8
  %ss_after = add i64 %ss_before, 1
  store i64 %ss_after, i64* %stack_size, align 8
  %arr30ptr5 = load i64*, i64** %arr30, align 8
  %push_slot = getelementptr inbounds i64, i64* %arr30ptr5, i64 %ss_before
  store i64 %nei_cur, i64* %push_slot, align 8
  br label %after_inner

inc_neighbor:
  %nei_plus = add i64 %nei_cur, 1
  store i64 %nei_plus, i64* %neighbor, align 8
  br label %inner_check

after_inner:
  %nei_end = load i64, i64* %neighbor, align 8
  %at_end = icmp eq i64 %nei_end, %arg1
  br i1 %at_end, label %pop, label %outer_check

pop:
  %ss3 = load i64, i64* %stack_size, align 8
  %ss_dec = add i64 %ss3, -1
  store i64 %ss_dec, i64* %stack_size, align 8
  br label %outer_check

cleanup:
  %blkptr_free = load i32*, i32** %block, align 8
  %blkraw_free = bitcast i32* %blkptr_free to i8*
  call void @free(i8* %blkraw_free)
  %arr28_free = load i64*, i64** %arr28, align 8
  %arr28raw_free = bitcast i64* %arr28_free to i8*
  call void @free(i8* %arr28raw_free)
  %arr30_free = load i64*, i64** %arr30, align 8
  %arr30raw_free = bitcast i64* %arr30_free to i8*
  call void @free(i8* %arr30raw_free)
  br label %ret

ret:
  ret void
}