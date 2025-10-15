target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %graph, i64 %n, i64 %start, i32* %dist, i32* %prev) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %ret, label %check_start

check_start:
  %cmp_start = icmp uge i64 %start, %n
  br i1 %cmp_start, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %blkraw = call i8* @malloc(i64 %size)
  %blk = bitcast i8* %blkraw to i32*
  %blk_isnull = icmp eq i32* %blk, null
  br i1 %blk_isnull, label %ret, label %init_cond

init_cond:
  %i = phi i64 [ 0, %alloc ], [ %i.next, %init_body ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %init_body, label %post_init

init_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist_i_ptr, align 4
  %prev_i_ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev_i_ptr, align 4
  %blk_i_ptr = getelementptr inbounds i32, i32* %blk, i64 %i
  store i32 0, i32* %blk_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_cond

post_init:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  br label %outer_cond

outer_cond:
  %t = phi i64 [ 0, %post_init ], [ %t.next, %outer_cont ]
  %t_cmp = icmp ult i64 %t, %n
  br i1 %t_cmp, label %select_init, label %free_blk

select_init:
  br label %sel_cond

sel_cond:
  %j = phi i64 [ 0, %select_init ], [ %j.next, %sel_body_end ]
  %min_index_phi = phi i64 [ %n, %select_init ], [ %min_index_upd, %sel_body_end ]
  %min_value_phi = phi i32 [ 1061109567, %select_init ], [ %min_value_upd, %sel_body_end ]
  %j_cmp = icmp ult i64 %j, %n
  br i1 %j_cmp, label %sel_body, label %sel_done

sel_body:
  %blk_j_ptr = getelementptr inbounds i32, i32* %blk, i64 %j
  %blk_j = load i32, i32* %blk_j_ptr, align 4
  %blk_j_zero = icmp eq i32 %blk_j, 0
  br i1 %blk_j_zero, label %sel_check, label %sel_skip

sel_check:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %dist_lt = icmp slt i32 %dist_j, %min_value_phi
  br i1 %dist_lt, label %sel_do_update, label %sel_skip

sel_do_update:
  br label %sel_body_end

sel_skip:
  br label %sel_body_end

sel_body_end:
  %min_value_upd = phi i32 [ %min_value_phi, %sel_skip ], [ %dist_j, %sel_do_update ]
  %min_index_upd = phi i64 [ %min_index_phi, %sel_skip ], [ %j, %sel_do_update ]
  %j.next = add i64 %j, 1
  br label %sel_cond

sel_done:
  %min_index_res = add i64 %min_index_phi, 0
  %min_is_n = icmp eq i64 %min_index_res, %n
  br i1 %min_is_n, label %free_blk, label %after_select

after_select:
  %blk_min_ptr = getelementptr inbounds i32, i32* %blk, i64 %min_index_res
  store i32 1, i32* %blk_min_ptr, align 4
  br label %relax_cond

relax_cond:
  %k = phi i64 [ 0, %after_select ], [ %k.next, %relax_inc ]
  %k_cmp = icmp ult i64 %k, %n
  br i1 %k_cmp, label %relax_body, label %outer_cont

relax_body:
  %mul = mul i64 %min_index_res, %n
  %idx = add i64 %mul, %k
  %wptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %wptr, align 4
  %w_neg = icmp slt i32 %w, 0
  br i1 %w_neg, label %relax_inc, label %check_blk_k

check_blk_k:
  %blk_k_ptr = getelementptr inbounds i32, i32* %blk, i64 %k
  %blk_k = load i32, i32* %blk_k_ptr, align 4
  %blk_k_zero = icmp eq i32 %blk_k, 0
  br i1 %blk_k_zero, label %check_inf, label %relax_inc

check_inf:
  %dist_min_ptr = getelementptr inbounds i32, i32* %dist, i64 %min_index_res
  %dist_min = load i32, i32* %dist_min_ptr, align 4
  %is_inf = icmp eq i32 %dist_min, 1061109567
  br i1 %is_inf, label %relax_inc, label %check_better

check_better:
  %newdist = add i32 %dist_min, %w
  %dist_k_ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist_k = load i32, i32* %dist_k_ptr, align 4
  %improve = icmp slt i32 %newdist, %dist_k
  br i1 %improve, label %do_update, label %relax_inc

do_update:
  store i32 %newdist, i32* %dist_k_ptr, align 4
  %prev_k_ptr = getelementptr inbounds i32, i32* %prev, i64 %k
  %min_index_tr = trunc i64 %min_index_res to i32
  store i32 %min_index_tr, i32* %prev_k_ptr, align 4
  br label %relax_inc

relax_inc:
  %k.next = add i64 %k, 1
  br label %relax_cond

outer_cont:
  %t.next = add i64 %t, 1
  br label %outer_cond

free_blk:
  call void @free(i8* %blkraw)
  br label %ret

ret:
  ret void
}