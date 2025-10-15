target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %countp) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init.pre, label %early

early:
  store i64 0, i64* %countp, align 8
  br label %ret

init.pre:
  br label %init.cond

init.cond:
  %i = phi i64 [ 0, %init.pre ], [ %i.next, %init.body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init.body, label %alloc

init.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.cond

alloc:
  %bytes = shl i64 %n, 3
  %raw = call i8* @malloc(i64 %bytes)
  %queue = bitcast i8* %raw to i64*
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %malloc_fail, label %post_alloc

malloc_fail:
  store i64 0, i64* %countp, align 8
  br label %ret

post_alloc:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_tail_ptr0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q_tail_ptr0, align 8
  store i64 0, i64* %countp, align 8
  br label %outer.cond

outer.cond:
  %head.phi = phi i64 [ 0, %post_alloc ], [ %head.next, %outer.latch ]
  %tail.phi = phi i64 [ 1, %post_alloc ], [ %tail.after.inner, %outer.latch ]
  %queue.phi = phi i64* [ %queue, %post_alloc ], [ %queue.phi, %outer.latch ]
  %head_lt_tail = icmp ult i64 %head.phi, %tail.phi
  br i1 %head_lt_tail, label %outer.body, label %done

outer.body:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue.phi, i64 %head.phi
  %node = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head.phi, 1
  %oldcnt = load i64, i64* %countp, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %countp, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %node, i64* %out_slot, align 8
  br label %inner.cond

inner.cond:
  %j = phi i64 [ 0, %outer.body ], [ %j.next, %skip_join ]
  %tail.in = phi i64 [ %tail.phi, %outer.body ], [ %tail.upd, %skip_join ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner.body, label %outer.latch

inner.body:
  %mul = mul i64 %node, %n
  %idx = add i64 %mul, %j
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %adj_val, 0
  br i1 %is_zero, label %skip_enq, label %check_unseen

check_unseen:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %is_unseen = icmp eq i32 %dist_j, -1
  br i1 %is_unseen, label %visit, label %skip_enq

visit:
  %dist_node_ptr = getelementptr inbounds i32, i32* %dist, i64 %node
  %dist_node = load i32, i32* %dist_node_ptr, align 4
  %dist_inc = add i32 %dist_node, 1
  store i32 %dist_inc, i32* %dist_j_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue.phi, i64 %tail.in
  store i64 %j, i64* %q_tail_ptr, align 8
  %tail.new = add i64 %tail.in, 1
  br label %skip_join

skip_enq:
  br label %skip_join

skip_join:
  %tail.upd = phi i64 [ %tail.new, %visit ], [ %tail.in, %skip_enq ]
  %j.next = add i64 %j, 1
  br label %inner.cond

outer.latch:
  %tail.after.inner = phi i64 [ %tail.in, %inner.cond ]
  br label %outer.cond

done:
  %raw.queue = bitcast i64* %queue.phi to i8*
  call void @free(i8* %raw.queue)
  br label %ret

ret:
  ret void
}