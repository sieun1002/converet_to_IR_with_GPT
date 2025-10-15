; ModuleID: bfs_module
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @sub_140001450(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %outArr, i64* %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %bad, label %early_exit, label %init_loop_header

early_exit:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop_header:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_loop_header ], [ %i_next, %init_store ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_store, label %post_init

init_store:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %init_loop

post_init:
  %malloc_size = mul i64 %n, 8
  %raw_block = call i8* @malloc(i64 %malloc_size)
  %block = bitcast i8* %raw_block to i64*
  %block_is_null = icmp eq i64* %block, null
  br i1 %block_is_null, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

after_malloc:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %block_slot0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %block_slot0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_check

outer_check:
  %readIdx = phi i64 [ 0, %after_malloc ], [ %readIdx_next, %after_inner ]
  %writeIdx = phi i64 [ 1, %after_malloc ], [ %writeIdx_carry_exit, %after_inner ]
  %has_items = icmp ult i64 %readIdx, %writeIdx
  br i1 %has_items, label %process, label %done

process:
  %cur_ptr = getelementptr inbounds i64, i64* %block, i64 %readIdx
  %cur = load i64, i64* %cur_ptr, align 8
  %readIdx_next = add i64 %readIdx, 1
  %oldCount = load i64, i64* %outCount, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %outCount, align 8
  %out_slot = getelementptr inbounds i64, i64* %outArr, i64 %oldCount
  store i64 %cur, i64* %out_slot, align 8
  br label %inner_check

inner_check:
  %var = phi i64 [ 0, %process ], [ %var_next, %inner_join ]
  %writeIdx_carry = phi i64 [ %writeIdx, %process ], [ %writeIdx_new, %inner_join ]
  %var_lt_n = icmp ult i64 %var, %n
  br i1 %var_lt_n, label %inner_body, label %after_inner

inner_body:
  %cur_mul_n = mul i64 %cur, %n
  %idx = add i64 %cur_mul_n, %var
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat_val = load i32, i32* %mat_ptr, align 4
  %mat_is_zero = icmp eq i32 %mat_val, 0
  br i1 %mat_is_zero, label %inner_no, label %check_dist

check_dist:
  %dist_var_ptr = getelementptr inbounds i32, i32* %dist, i64 %var
  %dist_var_val = load i32, i32* %dist_var_ptr, align 4
  %is_unseen = icmp eq i32 %dist_var_val, -1
  br i1 %is_unseen, label %do_update, label %inner_no

do_update:
  %dist_cur_ptr = getelementptr inbounds i32, i32* %dist, i64 %cur
  %dist_cur_val = load i32, i32* %dist_cur_ptr, align 4
  %dist_cur_plus1 = add i32 %dist_cur_val, 1
  store i32 %dist_cur_plus1, i32* %dist_var_ptr, align 4
  %enqueue_slot = getelementptr inbounds i64, i64* %block, i64 %writeIdx_carry
  store i64 %var, i64* %enqueue_slot, align 8
  %writeIdx_incr = add i64 %writeIdx_carry, 1
  br label %inner_join

inner_no:
  br label %inner_join

inner_join:
  %writeIdx_new = phi i64 [ %writeIdx_carry, %inner_no ], [ %writeIdx_incr, %do_update ]
  %var_next = add i64 %var, 1
  br label %inner_check

after_inner:
  %writeIdx_carry_exit = phi i64 [ %writeIdx_carry, %inner_check ]
  br label %outer_check

done:
  %raw_block_free = bitcast i64* %block to i8*
  call void @free(i8* %raw_block_free)
  ret void
}