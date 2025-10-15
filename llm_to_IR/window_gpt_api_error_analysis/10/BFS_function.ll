; ModuleID = 'bfs_module'
source_filename = "bfs_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_nodes, i64* %out_lenp) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %invalid, label %checkstart

checkstart:
  %start_lt = icmp ult i64 %start, %n
  br i1 %start_lt, label %init_loop_entry, label %invalid

invalid:
  store i64 0, i64* %out_lenp, align 8
  ret void

init_loop_entry:
  br label %init_cond

init_cond:
  %i = phi i64 [ 0, %init_loop_entry ], [ %i_next, %init_body ]
  %lt = icmp ult i64 %i, %n
  br i1 %lt, label %init_body, label %post_init

init_body:
  %distptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %distptr, align 4
  %i_next = add i64 %i, 1
  br label %init_cond

post_init:
  %size_bytes = shl i64 %n, 3
  %raw = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %alloc_fail, label %alloc_ok

alloc_fail:
  store i64 0, i64* %out_lenp, align 8
  ret void

alloc_ok:
  %queue = bitcast i8* %raw to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  br label %enqueue_start

enqueue_start:
  %head0 = phi i64 [ 0, %alloc_ok ]
  %tail0 = phi i64 [ 0, %alloc_ok ]
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail0
  store i64 %start, i64* %q_tail_ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 0, i64* %out_lenp, align 8
  br label %outer_cond

outer_cond:
  %head = phi i64 [ %head0, %enqueue_start ], [ %head_after, %after_inner ]
  %tail = phi i64 [ %tail1, %enqueue_start ], [ %tail_after, %after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer_body, label %outer_end

outer_body:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %v = load i64, i64* %q_head_ptr, align 8
  %head_next = add i64 %head, 1
  %curr_len = load i64, i64* %out_lenp, align 8
  %next_len = add i64 %curr_len, 1
  store i64 %next_len, i64* %out_lenp, align 8
  %out_slot = getelementptr inbounds i64, i64* %out_nodes, i64 %curr_len
  store i64 %v, i64* %out_slot, align 8
  br label %inner_cond

inner_cond:
  %u = phi i64 [ 0, %outer_body ], [ %u_next, %inner_next ]
  %tail_cur = phi i64 [ %tail, %outer_body ], [ %tail_updated, %inner_next ]
  %head_prog = phi i64 [ %head_next, %outer_body ], [ %head_prog_latch, %inner_next ]
  %u_lt_n = icmp ult i64 %u, %n
  br i1 %u_lt_n, label %inner_body, label %after_inner

inner_body:
  %mul = mul i64 %v, %n
  %idx = add i64 %mul, %u
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %unvisited = icmp eq i32 %dist_u, -1
  %can_visit = and i1 %adj_nonzero, %unvisited
  br i1 %can_visit, label %visit, label %inner_next

visit:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %dist_new = add i32 %dist_v, 1
  store i32 %dist_new, i32* %dist_u_ptr, align 4
  %q_tail_slot = getelementptr inbounds i64, i64* %queue, i64 %tail_cur
  store i64 %u, i64* %q_tail_slot, align 8
  %tail_inc = add i64 %tail_cur, 1
  br label %inner_next

inner_next:
  %tail_updated = phi i64 [ %tail_cur, %inner_body ], [ %tail_inc, %visit ]
  %head_prog_latch = add i64 %head_prog, 0
  %u_next = add i64 %u, 1
  br label %inner_cond

after_inner:
  %head_after = phi i64 [ %head_prog, %inner_cond ]
  %tail_after = phi i64 [ %tail_cur, %inner_cond ]
  br label %outer_cond

outer_end:
  %raw_free = bitcast i64* %queue to i8*
  call void @free(i8* %raw_free)
  ret void
}