; ModuleID = 'dijkstra_module'
source_filename = "dijkstra.ll"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %graph, i64 %n, i64 %src, i32* %dist, i32* %prev) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %end_noalloc, label %check_src

check_src:                                           ; preds = %entry
  %cmp_src_ge_n = icmp uge i64 %src, %n
  br i1 %cmp_src_ge_n, label %end_noalloc, label %do_malloc

do_malloc:                                           ; preds = %check_src
  %size = shl i64 %n, 2
  %blk_raw = call noalias i8* @malloc(i64 %size)
  %block = bitcast i8* %blk_raw to i32*
  %blk_is_null = icmp eq i8* %blk_raw, null
  br i1 %blk_is_null, label %end_noalloc, label %init_loop_header

init_loop_header:                                    ; preds = %do_malloc, %init_loop_body_end
  %i = phi i64 [ 0, %do_malloc ], [ %i_next, %init_loop_body_end ]
  %init_cond = icmp ult i64 %i, %n
  br i1 %init_cond, label %init_loop_body, label %post_init

init_loop_body:                                      ; preds = %init_loop_header
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist_i_ptr, align 4
  %prev_i_ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev_i_ptr, align 4
  %block_i_ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block_i_ptr, align 4
  br label %init_loop_body_end

init_loop_body_end:                                  ; preds = %init_loop_body
  %i_next = add i64 %i, 1
  br label %init_loop_header

post_init:                                           ; preds = %init_loop_header
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr, align 4
  br label %outer_header

outer_header:                                        ; preds = %post_init, %outer_end
  %outer = phi i64 [ 0, %post_init ], [ %outer_next, %outer_end ]
  %outer_cond = icmp ult i64 %outer, %n
  br i1 %outer_cond, label %scan_header, label %after_loops

scan_header:                                         ; preds = %outer_header, %scan_body_end
  %j = phi i64 [ 0, %outer_header ], [ %j_next, %scan_body_end ]
  %minDist_phi = phi i32 [ 1061109567, %outer_header ], [ %minDist_next, %scan_body_end ]
  %minIndex_phi = phi i64 [ %n, %outer_header ], [ %minIndex_next, %scan_body_end ]
  %scan_cond = icmp ult i64 %j, %n
  br i1 %scan_cond, label %scan_body, label %scan_end

scan_body:                                           ; preds = %scan_header
  %blk_j_ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %blk_j = load i32, i32* %blk_j_ptr, align 4
  %is_unvisited_j = icmp eq i32 %blk_j, 0
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %lt_j = icmp slt i32 %dist_j, %minDist_phi
  %upd_cond = and i1 %is_unvisited_j, %lt_j
  %minDist_sel = select i1 %upd_cond, i32 %dist_j, i32 %minDist_phi
  %minIndex_sel = select i1 %upd_cond, i64 %j, i64 %minIndex_phi
  br label %scan_body_end

scan_body_end:                                       ; preds = %scan_body
  %minDist_next = phi i32 [ %minDist_sel, %scan_body ]
  %minIndex_next = phi i64 [ %minIndex_sel, %scan_body ]
  %j_next = add i64 %j, 1
  br label %scan_header

scan_end:                                            ; preds = %scan_header
  %minDist_final = phi i32 [ %minDist_phi, %scan_header ]
  %minIndex_final = phi i64 [ %minIndex_phi, %scan_header ]
  %cmp_minIndex_eq_n = icmp eq i64 %minIndex_final, %n
  br i1 %cmp_minIndex_eq_n, label %free_and_end, label %mark_visited

mark_visited:                                        ; preds = %scan_end
  %blk_min_ptr = getelementptr inbounds i32, i32* %block, i64 %minIndex_final
  store i32 1, i32* %blk_min_ptr, align 4
  br label %inner_header

inner_header:                                        ; preds = %mark_visited, %inner_end
  %k = phi i64 [ 0, %mark_visited ], [ %k_next, %inner_end ]
  %inner_cond = icmp ult i64 %k, %n
  br i1 %inner_cond, label %inner_body, label %outer_end

inner_body:                                          ; preds = %inner_header
  %mul = mul i64 %minIndex_final, %n
  %idx = add i64 %mul, %k
  %w_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %w_ptr, align 4
  %w_neg = icmp slt i32 %w, 0
  br i1 %w_neg, label %inner_end, label %check_k_unvisited

check_k_unvisited:                                   ; preds = %inner_body
  %blk_k_ptr = getelementptr inbounds i32, i32* %block, i64 %k
  %blk_k = load i32, i32* %blk_k_ptr, align 4
  %k_unvisited = icmp eq i32 %blk_k, 0
  br i1 %k_unvisited, label %check_min_inf, label %inner_end

check_min_inf:                                       ; preds = %check_k_unvisited
  %dist_min_ptr = getelementptr inbounds i32, i32* %dist, i64 %minIndex_final
  %dist_min = load i32, i32* %dist_min_ptr, align 4
  %is_inf = icmp eq i32 %dist_min, 1061109567
  br i1 %is_inf, label %inner_end, label %check_better

check_better:                                        ; preds = %check_min_inf
  %sum = add i32 %dist_min, %w
  %dist_k_ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist_k = load i32, i32* %dist_k_ptr, align 4
  %ge = icmp sge i32 %sum, %dist_k
  br i1 %ge, label %inner_end, label %do_update

do_update:                                           ; preds = %check_better
  store i32 %sum, i32* %dist_k_ptr, align 4
  %prev_k_ptr = getelementptr inbounds i32, i32* %prev, i64 %k
  %minIndex_trunc = trunc i64 %minIndex_final to i32
  store i32 %minIndex_trunc, i32* %prev_k_ptr, align 4
  br label %inner_end

inner_end:                                           ; preds = %inner_body, %check_k_unvisited, %check_min_inf, %check_better, %do_update
  %k_next = add i64 %k, 1
  br label %inner_header

outer_end:                                           ; preds = %inner_header
  %outer_next = add i64 %outer, 1
  br label %outer_header

after_loops:                                         ; preds = %outer_header
  br label %free_and_end

free_and_end:                                        ; preds = %scan_end, %after_loops
  %blk_for_free = bitcast i32* %block to i8*
  call void @free(i8* %blk_for_free)
  br label %end

end_noalloc:                                         ; preds = %check_src, %do_malloc, %entry
  br label %end

end:                                                 ; preds = %end_noalloc, %free_and_end
  ret void
}