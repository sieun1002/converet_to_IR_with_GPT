; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %countptr) {
entry:
  %i = alloca i64, align 8
  %sp = alloca i64, align 8
  %neiVar = alloca i64, align 8

  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %early_zero

early_zero:
  store i64 0, i64* %countptr, align 8
  br label %exit

alloc:
  %size_vis = shl i64 %n, 2
  %p1 = call i8* @malloc(i64 %size_vis)
  %visitedp = bitcast i8* %p1 to i32*

  %size_q = shl i64 %n, 3
  %p2 = call i8* @malloc(i64 %size_q)
  %nextp = bitcast i8* %p2 to i64*

  %p3 = call i8* @malloc(i64 %size_q)
  %stackp = bitcast i8* %p3 to i64*

  %c1 = icmp eq i8* %p1, null
  %c2 = icmp eq i8* %p2, null
  %c3 = icmp eq i8* %p3, null
  %t1 = or i1 %c1, %c2
  %anynull = or i1 %t1, %c3
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  store i64 0, i64* %countptr, align 8
  br label %exit

init:
  store i64 0, i64* %i, align 8
  br label %init_loop

init_loop:
  %i_val = load i64, i64* %i, align 8
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %init_body, label %init_done

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visitedp, i64 %i_val
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextp, i64 %i_val
  store i64 0, i64* %next_ptr, align 8
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i, align 8
  br label %init_loop

init_done:
  store i64 0, i64* %sp, align 8
  store i64 0, i64* %countptr, align 8

  %sp_old = load i64, i64* %sp, align 8
  %sp_new = add i64 %sp_old, 1
  store i64 %sp_new, i64* %sp, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stackp, i64 %sp_old
  store i64 %start, i64* %stack_slot, align 8

  %visit_start_ptr = getelementptr inbounds i32, i32* %visitedp, i64 %start
  store i32 1, i32* %visit_start_ptr, align 4

  %oldcnt = load i64, i64* %countptr, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %countptr, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %start, i64* %out_slot, align 8

  br label %loop_check

loop_check:
  %sp_now = load i64, i64* %sp, align 8
  %sp_is_zero = icmp eq i64 %sp_now, 0
  br i1 %sp_is_zero, label %cleanup, label %loop_top

loop_top:
  %sp_now2 = load i64, i64* %sp, align 8
  %top_index = add i64 %sp_now2, -1
  %top_ptr = getelementptr inbounds i64, i64* %stackp, i64 %top_index
  %current = load i64, i64* %top_ptr, align 8

  %next_cur_ptr = getelementptr inbounds i64, i64* %nextp, i64 %current
  %nei0 = load i64, i64* %next_cur_ptr, align 8
  store i64 %nei0, i64* %neiVar, align 8

  br label %nei_loop_check

nei_loop_check:
  %nei = load i64, i64* %neiVar, align 8
  %has_more = icmp ult i64 %nei, %n
  br i1 %has_more, label %nei_check_edge, label %after_nei_loop

nei_check_edge:
  %mul = mul i64 %current, %n
  %sum = add i64 %mul, %nei
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %sum
  %edge_val = load i32, i32* %mat_ptr, align 4
  %edge_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_zero, label %nei_increment, label %check_visited

check_visited:
  %vis_ptr2 = getelementptr inbounds i32, i32* %visitedp, i64 %nei
  %vis_val = load i32, i32* %vis_ptr2, align 4
  %is_vis = icmp ne i32 %vis_val, 0
  br i1 %is_vis, label %nei_increment, label %found_neighbor

found_neighbor:
  %nei_plus1 = add i64 %nei, 1
  store i64 %nei_plus1, i64* %next_cur_ptr, align 8

  store i32 1, i32* %vis_ptr2, align 4

  %oldcnt2 = load i64, i64* %countptr, align 8
  %newcnt2 = add i64 %oldcnt2, 1
  store i64 %newcnt2, i64* %countptr, align 8
  %out_slot2 = getelementptr inbounds i64, i64* %out, i64 %oldcnt2
  store i64 %nei, i64* %out_slot2, align 8

  %sp_old2 = load i64, i64* %sp, align 8
  %sp_new2 = add i64 %sp_old2, 1
  store i64 %sp_new2, i64* %sp, align 8
  %stack_slot2 = getelementptr inbounds i64, i64* %stackp, i64 %sp_old2
  store i64 %nei, i64* %stack_slot2, align 8

  br label %compare_nei_then_maybe_pop

nei_increment:
  %nei_cur = load i64, i64* %neiVar, align 8
  %nei_next = add i64 %nei_cur, 1
  store i64 %nei_next, i64* %neiVar, align 8
  br label %nei_loop_check

after_nei_loop:
  br label %compare_nei_then_maybe_pop

compare_nei_then_maybe_pop:
  %nei_cmp = load i64, i64* %neiVar, align 8
  %eqn = icmp eq i64 %nei_cmp, %n
  br i1 %eqn, label %pop_then_loopcheck, label %loop_check

pop_then_loopcheck:
  %sp_now3 = load i64, i64* %sp, align 8
  %sp_dec = add i64 %sp_now3, -1
  store i64 %sp_dec, i64* %sp, align 8
  br label %loop_check

cleanup:
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  br label %exit

exit:
  ret void
}