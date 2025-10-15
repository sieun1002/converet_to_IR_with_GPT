; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %is_n_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %is_n_zero, %start_ge_n
  br i1 %bad, label %ret_zero, label %init_loop_cond_pre

ret_zero:
  store i64 0, i64* %outCount, align 8
  ret void

init_loop_cond_pre:
  br label %init_loop_cond

init_loop_cond:
  %i = phi i64 [ 0, %init_loop_cond_pre ], [ %i_next, %init_loop_body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_loop_body, label %post_init

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %init_loop_cond

post_init:
  %bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %malloc_failed, label %after_malloc

malloc_failed:
  store i64 0, i64* %outCount, align 8
  ret void

after_malloc:
  %queue = bitcast i8* %mem to i64*
  %start_dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start_dist_ptr, align 4
  store i64 0, i64* %outCount, align 8
  %q0ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0ptr, align 8
  br label %outer_loop_cond

outer_loop_cond:
  %head = phi i64 [ 0, %after_malloc ], [ %head_next, %outer_loop_latch ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail_out, %outer_loop_latch ]
  %cmp_ht = icmp ult i64 %head, %tail
  br i1 %cmp_ht, label %outer_loop_body, label %cleanup

outer_loop_body:
  %curr_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %curr = load i64, i64* %curr_ptr, align 8
  %head_next = add i64 %head, 1
  %oldCount = load i64, i64* %outCount, align 8
  %newCount = add i64 %oldCount, 1
  store i64 %newCount, i64* %outCount, align 8
  %out_elem_ptr = getelementptr inbounds i64, i64* %out, i64 %oldCount
  store i64 %curr, i64* %out_elem_ptr, align 8
  br label %inner_cond

inner_cond:
  %v = phi i64 [ 0, %outer_loop_body ], [ %v_next, %inner_continue ]
  %tail_phi = phi i64 [ %tail, %outer_loop_body ], [ %tail_after, %inner_continue ]
  %cmp_vn = icmp ult i64 %v, %n
  br i1 %cmp_vn, label %inner_body, label %inner_exit

inner_body:
  %mul = mul i64 %curr, %n
  %index = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %index
  %a = load i32, i32* %adj_ptr, align 4
  %neq_zero = icmp ne i32 %a, 0
  br i1 %neq_zero, label %check_unvisited, label %inner_continue

check_unvisited:
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv_ptr, align 4
  %is_unvisited = icmp eq i32 %dv, -1
  br i1 %is_unvisited, label %do_visit, label %inner_continue

do_visit:
  %dc_ptr = getelementptr inbounds i32, i32* %dist, i64 %curr
  %dc = load i32, i32* %dc_ptr, align 4
  %dc1 = add i32 %dc, 1
  store i32 %dc1, i32* %dv_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail_phi
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail_inc = add i64 %tail_phi, 1
  br label %inner_continue

inner_continue:
  %tail_after = phi i64 [ %tail_phi, %inner_body ], [ %tail_inc, %do_visit ], [ %tail_phi, %check_unvisited ]
  %v_next = add i64 %v, 1
  br label %inner_cond

inner_exit:
  %tail_exit = phi i64 [ %tail_phi, %inner_cond ]
  br label %outer_loop_latch

outer_loop_latch:
  %tail_out = phi i64 [ %tail_exit, %inner_exit ]
  br label %outer_loop_cond

cleanup:
  call void @free(i8* %mem)
  ret void
}