; ModuleID = 'bfs_module'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %visited_out, i64* %visited_count_ptr) local_unnamed_addr {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early, label %check_start

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init_dist.header, label %early

early:
  store i64 0, i64* %visited_count_ptr, align 8
  ret void

init_dist.header:
  br label %init_dist.loop

init_dist.loop:
  %i.phi = phi i64 [ 0, %init_dist.header ], [ %i.next, %init_dist.loop.body ]
  %i.cmp = icmp ult i64 %i.phi, %n
  br i1 %i.cmp, label %init_dist.loop.body, label %post_init

init_dist.loop.body:
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i.phi
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i.phi, 1
  br label %init_dist.loop

post_init:
  %size_bytes = shl i64 %n, 3
  %q.raw = call noalias i8* @malloc(i64 %size_bytes)
  %q.null = icmp eq i8* %q.raw, null
  br i1 %q.null, label %early, label %setup

setup:
  %queue = bitcast i8* %q.raw to i64*
  %dist.start.gep = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.gep, align 4
  %tail.init = add i64 0, 0
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.init
  store i64 %start, i64* %q.enq.ptr, align 8
  %tail.after = add i64 %tail.init, 1
  store i64 0, i64* %visited_count_ptr, align 8
  br label %outer.header

outer.header:
  %head.phi = phi i64 [ 0, %setup ], [ %head.next, %outer.latch ]
  %tail.phi = phi i64 [ %tail.after, %setup ], [ %tail.from.inner, %outer.latch ]
  %has_items = icmp ult i64 %head.phi, %tail.phi
  br i1 %has_items, label %outer.body, label %outer.exit

outer.body:
  %q.deq.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.phi
  %u = load i64, i64* %q.deq.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %vis.old = load i64, i64* %visited_count_ptr, align 8
  %vis.next = add i64 %vis.old, 1
  store i64 %vis.next, i64* %visited_count_ptr, align 8
  %vis.out.ptr = getelementptr inbounds i64, i64* %visited_out, i64 %vis.old
  store i64 %u, i64* %vis.out.ptr, align 8
  br label %inner.header

inner.header:
  %j.phi = phi i64 [ 0, %outer.body ], [ %j.next, %inner.latch ]
  %tail.inner.phi = phi i64 [ %tail.phi, %outer.body ], [ %tail.inner.next, %inner.latch ]
  %j.cmp = icmp ult i64 %j.phi, %n
  br i1 %j.cmp, label %inner.body, label %outer.latch

inner.body:
  %u_times_n = mul i64 %u, %n
  %idx = add i64 %u_times_n, %j.phi
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.nonzero = icmp ne i32 %adj.val, 0
  br i1 %adj.nonzero, label %check.unvisited, label %inner.skip

check.unvisited:
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j.phi
  %dist.j.val = load i32, i32* %dist.j.ptr, align 4
  %is.unvisited = icmp eq i32 %dist.j.val, -1
  br i1 %is.unvisited, label %visit.enqueue, label %inner.skip

visit.enqueue:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u.val = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u.val, 1
  store i32 %dist.u.plus1, i32* %dist.j.ptr, align 4
  %tail.old = add i64 %tail.inner.phi, 0
  %q.enq2.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.old
  store i64 %j.phi, i64* %q.enq2.ptr, align 8
  %tail.enq.next = add i64 %tail.old, 1
  br label %inner.latch

inner.skip:
  br label %inner.latch

inner.latch:
  %tail.inner.next = phi i64 [ %tail.enq.next, %visit.enqueue ], [ %tail.inner.phi, %inner.skip ]
  %j.next = add i64 %j.phi, 1
  br label %inner.header

outer.latch:
  %tail.from.inner = phi i64 [ %tail.inner.phi, %inner.header ]
  br label %outer.header

outer.exit:
  %q.raw.free = bitcast i64* %queue to i8*
  call void @free(i8* %q.raw.free)
  ret void
}