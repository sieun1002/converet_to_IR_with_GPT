; ModuleID = 'bfs.ll'

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %order, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %fail, label %check_src

check_src:
  %src_in_range = icmp ult i64 %src, %n
  br i1 %src_in_range, label %init_loop, label %fail

fail:
  store i64 0, i64* %count, align 8
  ret void

init_loop:
  %i = phi i64 [ 0, %check_src ], [ %i.next, %init_loop.latch ]
  %more = icmp ult i64 %i, %n
  br i1 %more, label %init_body, label %alloc

init_body:
  %dist_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i, align 4
  br label %init_loop.latch

init_loop.latch:
  %i.next = add nuw i64 %i, 1
  br label %init_loop

alloc:
  %size = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %size)
  %q = bitcast i8* %qraw to i64*
  %qnull = icmp eq i64* %q, null
  br i1 %qnull, label %fail, label %setup

setup:
  %dist_src = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src, align 4
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %src, i64* %q0, align 8
  store i64 0, i64* %count, align 8
  br label %outer.cond

outer.cond:
  %head = phi i64 [ 0, %setup ], [ %head.next, %outer.latch ]
  %tail = phi i64 [ 1, %setup ], [ %tail.end, %outer.latch ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer.body, label %cleanup

outer.body:
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next = add i64 %head, 1
  %cnt0 = load i64, i64* %count, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %count, align 8
  %order_idx_ptr = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %u, i64* %order_idx_ptr, align 8
  br label %inner.header

inner.header:
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.latch ]
  %tail.acc = phi i64 [ %tail, %outer.body ], [ %tail.nextphi, %inner.latch ]
  %v.more = icmp ult i64 %v, %n
  br i1 %v.more, label %inner.body, label %inner.done

inner.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %nonzero = icmp ne i32 %adj.val, 0
  br i1 %nonzero, label %check.unvisited, label %no.enqueue

check.unvisited:
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %is.unvisited = icmp eq i32 %dv, -1
  br i1 %is.unvisited, label %enqueue, label %no.enqueue

enqueue:
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du.plus = add nsw i32 %du, 1
  store i32 %du.plus, i32* %dv.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.acc
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.new = add i64 %tail.acc, 1
  br label %inner.latch

no.enqueue:
  br label %inner.latch

inner.latch:
  %tail.nextphi = phi i64 [ %tail.new, %enqueue ], [ %tail.acc, %no.enqueue ]
  %v.next = add nuw i64 %v, 1
  br label %inner.header

inner.done:
  %tail.end = phi i64 [ %tail.acc, %inner.header ]
  br label %outer.latch

outer.latch:
  br label %outer.cond

cleanup:
  call void @free(i8* %qraw)
  ret void
}