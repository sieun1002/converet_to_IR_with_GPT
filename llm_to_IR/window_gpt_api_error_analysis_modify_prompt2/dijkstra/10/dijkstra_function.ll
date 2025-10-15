target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @dijkstra(i32* noundef %graph, i64 noundef %n, i64 noundef %start, i32* noundef %dist, i32* noundef %prev) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret, label %check_start

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %after_alloc

after_alloc:
  %block = bitcast i8* %raw to i32*
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %after_alloc ], [ %i.next, %init_continue ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %init_done

init_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist_i_ptr, align 4
  %prev_i_ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev_i_ptr, align 4
  %block_i_ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block_i_ptr, align 4
  br label %init_continue

init_continue:
  %i.next = add i64 %i, 1
  br label %init_loop

init_done:
  %idxS = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %idxS, align 4
  br label %outer_loop

outer_loop:
  %t = phi i64 [ 0, %init_done ], [ %t.next, %outer_latch ]
  %tcond = icmp ult i64 %t, %n
  br i1 %tcond, label %select_init, label %free_block

select_init:
  br label %select_loop

select_loop:
  %j = phi i64 [ 0, %select_init ], [ %j.next, %select_latch ]
  %best_idx = phi i64 [ %n, %select_init ], [ %best_idx.next, %select_latch ]
  %best_dist = phi i32 [ 1061109567, %select_init ], [ %best_dist.next, %select_latch ]
  %jcond = icmp ult i64 %j, %n
  br i1 %jcond, label %select_body, label %after_select

select_body:
  %block_j_ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %block_j = load i32, i32* %block_j_ptr, align 4
  %is_blocked = icmp ne i32 %block_j, 0
  br i1 %is_blocked, label %select_latch, label %check_dist

check_dist:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %le = icmp sle i32 %best_dist, %dist_j
  br i1 %le, label %select_latch, label %update_best

update_best:
  br label %select_latch

select_latch:
  %best_dist.next = phi i32 [ %best_dist, %select_body ], [ %best_dist, %check_dist ], [ %dist_j, %update_best ]
  %best_idx.next = phi i64 [ %best_idx, %select_body ], [ %best_idx, %check_dist ], [ %j, %update_best ]
  %j.next = add i64 %j, 1
  br label %select_loop

after_select:
  %no_idx = icmp eq i64 %best_idx, %n
  br i1 %no_idx, label %free_block, label %mark_and_relax

mark_and_relax:
  %block_best_ptr = getelementptr inbounds i32, i32* %block, i64 %best_idx
  store i32 1, i32* %block_best_ptr, align 4
  br label %relax_loop

relax_loop:
  %k = phi i64 [ 0, %mark_and_relax ], [ %k.next, %relax_latch ]
  %kcond = icmp ult i64 %k, %n
  br i1 %kcond, label %relax_body, label %outer_latch

relax_body:
  %mul = mul i64 %best_idx, %n
  %idx_lin = add i64 %mul, %k
  %edge_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx_lin
  %edge = load i32, i32* %edge_ptr, align 4
  %edge_neg = icmp slt i32 %edge, 0
  br i1 %edge_neg, label %relax_latch, label %check_k_block

check_k_block:
  %block_k_ptr = getelementptr inbounds i32, i32* %block, i64 %k
  %block_k = load i32, i32* %block_k_ptr, align 4
  %k_blocked = icmp ne i32 %block_k, 0
  br i1 %k_blocked, label %relax_latch, label %check_dist_inf

check_dist_inf:
  %dist_best_ptr = getelementptr inbounds i32, i32* %dist, i64 %best_idx
  %dist_best = load i32, i32* %dist_best_ptr, align 4
  %is_inf = icmp eq i32 %dist_best, 1061109567
  br i1 %is_inf, label %relax_latch, label %calc_relax

calc_relax:
  %sum = add i32 %dist_best, %edge
  %dist_k_ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist_k = load i32, i32* %dist_k_ptr, align 4
  %ge = icmp sge i32 %sum, %dist_k
  br i1 %ge, label %relax_latch, label %do_update

do_update:
  store i32 %sum, i32* %dist_k_ptr, align 4
  %best_idx32 = trunc i64 %best_idx to i32
  %prev_k_ptr = getelementptr inbounds i32, i32* %prev, i64 %k
  store i32 %best_idx32, i32* %prev_k_ptr, align 4
  br label %relax_latch

relax_latch:
  %k.next = add i64 %k, 1
  br label %relax_loop

outer_latch:
  %t.next = add i64 %t, 1
  br label %outer_loop

free_block:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}