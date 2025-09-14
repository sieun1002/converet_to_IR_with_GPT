; ModuleID = 'bfs_module'
source_filename = "bfs_module"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init_dist.loop, label %ret_zero

ret_zero:
  store i64 0, i64* %out_len, align 8
  ret void

init_dist.loop:
  br label %init_dist.header

init_dist.header:
  %i_phi = phi i64 [ 0, %init_dist.loop ], [ %i_next, %init_dist.body ]
  %init_cond = icmp ult i64 %i_phi, %n
  br i1 %init_cond, label %init_dist.body, label %post_init

init_dist.body:
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i_phi
  store i32 -1, i32* %dist_ptr_i, align 4
  %i_next = add i64 %i_phi, 1
  br label %init_dist.header

post_init:
  %size_bytes = shl i64 %n, 3
  %q_raw = call i8* @malloc(i64 %size_bytes)
  %q_is_null = icmp eq i8* %q_raw, null
  br i1 %q_is_null, label %alloc_fail, label %alloc_ok

alloc_fail:
  store i64 0, i64* %out_len, align 8
  ret void

alloc_ok:
  %queue = bitcast i8* %q_raw to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %tail_init = add i64 0, 1
  %q_tail_slot_ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q_tail_slot_ptr, align 8
  store i64 0, i64* %out_len, align 8
  br label %outer.header

outer.header:
  %head_phi = phi i64 [ 0, %alloc_ok ], [ %head_next, %outer.latch ]
  %tail_phi = phi i64 [ 1, %alloc_ok ], [ %tail_after_inner, %outer.latch ]
  %not_empty = icmp ult i64 %head_phi, %tail_phi
  br i1 %not_empty, label %outer.body, label %outer.exit

outer.body:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head_phi
  %u = load i64, i64* %q_head_ptr, align 8
  %head_next = add i64 %head_phi, 1
  %old_cnt = load i64, i64* %out_len, align 8
  %new_cnt = add i64 %old_cnt, 1
  store i64 %new_cnt, i64* %out_len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %old_cnt
  store i64 %u, i64* %out_slot, align 8
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du_i32 = load i32, i32* %du_ptr, align 4
  %du_ext = sext i32 %du_i32 to i32
  br label %inner.header

inner.header:
  %v_phi = phi i64 [ 0, %outer.body ], [ %v_next, %inner.latch ]
  %tail_inner_phi = phi i64 [ %tail_phi, %outer.body ], [ %tail_updated, %inner.latch ]
  %v_cond = icmp ult i64 %v_phi, %n
  br i1 %v_cond, label %inner.body, label %outer.latch

inner.body:
  %mul_un = mul i64 %u, %n
  %idx_uv = add i64 %mul_un, %v_phi
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_uv
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nonzero = icmp ne i32 %adj_val, 0
  br i1 %adj_nonzero, label %check_dist, label %skip_enqueue

check_dist:
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v_phi
  %dv = load i32, i32* %dv_ptr, align 4
  %is_unvisited = icmp eq i32 %dv, -1
  br i1 %is_unvisited, label %visit_v, label %skip_enqueue

visit_v:
  %du_plus1 = add i32 %du_i32, 1
  store i32 %du_plus1, i32* %dv_ptr, align 4
  %q_tail_slot_ptr2 = getelementptr inbounds i64, i64* %queue, i64 %tail_inner_phi
  store i64 %v_phi, i64* %q_tail_slot_ptr2, align 8
  %tail_inc = add i64 %tail_inner_phi, 1
  br label %inner.latch

skip_enqueue:
  br label %inner.latch

inner.latch:
  %tail_updated = phi i64 [ %tail_inc, %visit_v ], [ %tail_inner_phi, %skip_enqueue ]
  %v_next = add i64 %v_phi, 1
  br label %inner.header

outer.latch:
  %tail_after_inner = phi i64 [ %tail_inner_phi, %inner.header ]
  br label %outer.header

outer.exit:
  call void @free(i8* %q_raw)
  ret void
}