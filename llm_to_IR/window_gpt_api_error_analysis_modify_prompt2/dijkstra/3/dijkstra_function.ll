; ModuleID = 'dijkstra'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %graph, i64 %n, i64 %src, i32* %dist, i32* %prev) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %exit, label %check_src

check_src:
  %cmp_src_ge_n = icmp uge i64 %src, %n
  br i1 %cmp_src_ge_n, label %exit, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %blk_raw = call i8* @malloc(i64 %size_bytes)
  %blk_is_null = icmp eq i8* %blk_raw, null
  br i1 %blk_is_null, label %exit, label %after_alloc

after_alloc:
  %visited = bitcast i8* %blk_raw to i32*
  br label %init_cond

init_cond:
  %i = phi i64 [ 0, %after_alloc ], [ %i_next, %init_latch ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %post_init

init_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist_i_ptr
  %prev_i_ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev_i_ptr
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_i_ptr
  br label %init_latch

init_latch:
  %i_next = add i64 %i, 1
  br label %init_cond

post_init:
  %src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %src_ptr
  br label %outer_cond

outer_cond:
  %iter = phi i64 [ 0, %post_init ], [ %iter_next, %outer_latch ]
  %iter_lt_n = icmp ult i64 %iter, %n
  br i1 %iter_lt_n, label %select_min, label %free_and_exit

select_min:
  br label %scan_cond

scan_cond:
  %min_index = phi i64 [ %n, %select_min ], [ %min_index_next, %scan_latch ]
  %min_dist = phi i32 [ 1061109567, %select_min ], [ %min_dist_next, %scan_latch ]
  %j = phi i64 [ 0, %select_min ], [ %j_next, %scan_latch ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %scan_body, label %scan_end

scan_body:
  %vis_j_ptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vis_j = load i32, i32* %vis_j_ptr
  %vis_is_zero = icmp eq i32 %vis_j, 0
  br i1 %vis_is_zero, label %vis_ok, label %scan_latch_nomod

scan_latch_nomod:
  %j_next_a = add i64 %j, 1
  br label %scan_latch

vis_ok:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr
  %less = icmp slt i32 %dist_j, %min_dist
  br i1 %less, label %update_min, label %scan_latch_nomod2

update_min:
  %j_next_b = add i64 %j, 1
  br label %scan_latch_updated

scan_latch_nomod2:
  %j_next_c = add i64 %j, 1
  br label %scan_latch

scan_latch_updated:
  br label %scan_latch

scan_latch:
  %min_index_next = phi i64 [ %min_index, %scan_latch_nomod ], [ %min_index, %scan_latch_nomod2 ], [ %j, %scan_latch_updated ]
  %min_dist_next = phi i32 [ %min_dist, %scan_latch_nomod ], [ %min_dist, %scan_latch_nomod2 ], [ %dist_j, %scan_latch_updated ]
  %j_next = phi i64 [ %j_next_a, %scan_latch_nomod ], [ %j_next_c, %scan_latch_nomod2 ], [ %j_next_b, %scan_latch_updated ]
  br label %scan_cond

scan_end:
  %final_min_index = phi i64 [ %min_index, %scan_cond ]
  %final_min_dist = phi i32 [ %min_dist, %scan_cond ]
  %min_unset = icmp eq i64 %final_min_index, %n
  br i1 %min_unset, label %free_and_exit, label %visit_and_relax

visit_and_relax:
  %vis_min_ptr = getelementptr inbounds i32, i32* %visited, i64 %final_min_index
  store i32 1, i32* %vis_min_ptr
  br label %neighbor_cond

neighbor_cond:
  %k = phi i64 [ 0, %visit_and_relax ], [ %k_next, %neighbor_latch ]
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %neighbor_body, label %outer_latch

neighbor_body:
  %mul = mul i64 %final_min_index, %n
  %idx = add i64 %mul, %k
  %edge_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %edge_ptr
  %w_neg = icmp slt i32 %w, 0
  br i1 %w_neg, label %neighbor_latch, label %check_neighbor_vis

check_neighbor_vis:
  %vis_k_ptr = getelementptr inbounds i32, i32* %visited, i64 %k
  %vis_k = load i32, i32* %vis_k_ptr
  %vis_k_zero = icmp eq i32 %vis_k, 0
  br i1 %vis_k_zero, label %check_min_inf, label %neighbor_latch

check_min_inf:
  %dist_min_ptr = getelementptr inbounds i32, i32* %dist, i64 %final_min_index
  %dist_min = load i32, i32* %dist_min_ptr
  %min_is_inf = icmp eq i32 %dist_min, 1061109567
  br i1 %min_is_inf, label %neighbor_latch, label %compute_new

compute_new:
  %sum = add i32 %dist_min, %w
  %dist_k_ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist_k = load i32, i32* %dist_k_ptr
  %ge = icmp sge i32 %sum, %dist_k
  br i1 %ge, label %neighbor_latch, label %do_update

do_update:
  store i32 %sum, i32* %dist_k_ptr
  %min_i32 = trunc i64 %final_min_index to i32
  %prev_k_ptr = getelementptr inbounds i32, i32* %prev, i64 %k
  store i32 %min_i32, i32* %prev_k_ptr
  br label %neighbor_latch

neighbor_latch:
  %k_next = add i64 %k, 1
  br label %neighbor_cond

outer_latch:
  %iter_next = add i64 %iter, 1
  br label %outer_cond

free_and_exit:
  call void @free(i8* %blk_raw)
  br label %exit

exit:
  ret void
}