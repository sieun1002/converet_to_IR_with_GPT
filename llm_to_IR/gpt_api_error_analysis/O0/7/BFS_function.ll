; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %early_cond = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %early_cond, label %early_out, label %init_dist

early_out:
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:
  br label %ldist.cond

ldist.cond:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %ldist.body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %ldist.body, label %post_init

ldist.body:
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i, 1
  br label %ldist.cond

post_init:
  %malloc_size = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %malloc_size)
  %isnull = icmp eq i8* %malloc_ptr, null
  br i1 %isnull, label %early_out_after_alloc, label %after_alloc

early_out_after_alloc:
  store i64 0, i64* %out_count, align 8
  ret void

after_alloc:
  %queue = bitcast i8* %malloc_ptr to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %qslot0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %qslot0, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs.cond

bfs.cond:
  %head = phi i64 [ 0, %after_alloc ], [ %head.next, %bfs.iter.end ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail.new, %bfs.iter.end ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %bfs.iter, label %bfs.end

bfs.iter:
  %qpop.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qpop.ptr, align 8
  %head.next = add i64 %head, 1
  %count.old = load i64, i64* %out_count, align 8
  %count.next = add i64 %count.old, 1
  store i64 %count.next, i64* %out_count, align 8
  %ord.slot = getelementptr inbounds i64, i64* %out_order, i64 %count.old
  store i64 %u, i64* %ord.slot, align 8
  br label %inner.cond

inner.cond:
  %v = phi i64 [ 0, %bfs.iter ], [ %v.next, %inner.inc_end ]
  %tail.cur = phi i64 [ %tail, %bfs.iter ], [ %tail.updated, %inner.inc_end ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %bfs.iter.end

inner.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %hasEdge = icmp ne i32 %adj.val, 0
  br i1 %hasEdge, label %check.unseen, label %inner.inc

check.unseen:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %isUnseen = icmp eq i32 %dist.v, -1
  br i1 %isUnseen, label %visit.enqueue, label %inner.inc

visit.enqueue:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %qtail.ptr, align 8
  %tail.after = add i64 %tail.cur, 1
  br label %inner.inc_end

inner.inc:
  br label %inner.inc_end

inner.inc_end:
  %tail.updated = phi i64 [ %tail.after, %visit.enqueue ], [ %tail.cur, %inner.inc ]
  %v.next = add i64 %v, 1
  br label %inner.cond

bfs.iter.end:
  %tail.new = phi i64 [ %tail.cur, %inner.cond ]
  br label %bfs.cond

bfs.end:
  %free.ptr = bitcast i64* %queue to i8*
  call void @free(i8* %free.ptr)
  ret void
}