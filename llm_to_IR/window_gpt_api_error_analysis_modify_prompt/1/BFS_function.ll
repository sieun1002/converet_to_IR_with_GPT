target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %cmp.n.zero = icmp eq i64 %n, 0
  br i1 %cmp.n.zero, label %early, label %check.start

check.start:
  %cmp.start = icmp ult i64 %start, %n
  br i1 %cmp.start, label %dist.init.preheader, label %early

early:
  store i64 0, i64* %out_count, align 8
  ret void

dist.init.preheader:
  br label %dist.init

dist.init:
  %i = phi i64 [ 0, %dist.init.preheader ], [ %i.next, %dist.init.body ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %dist.init.body, label %post.init

dist.init.body:
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist.init

post.init:
  %size.bytes = shl i64 %n, 3
  %malloc.raw = call i8* @malloc(i64 %size.bytes)
  %malloc.null = icmp eq i8* %malloc.raw, null
  br i1 %malloc.null, label %malloc.fail, label %malloc.ok

malloc.fail:
  store i64 0, i64* %out_count, align 8
  ret void

malloc.ok:
  %block = bitcast i8* %malloc.raw to i64*
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  %slot0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %slot0, align 8
  store i64 0, i64* %out_count, align 8
  br label %outer.header

outer.header:
  %head = phi i64 [ 0, %malloc.ok ], [ %head.next, %outer.latch ]
  %tail = phi i64 [ 1, %malloc.ok ], [ %tail.after.inner, %outer.latch ]
  %cmp.queue = icmp ult i64 %head, %tail
  br i1 %cmp.queue, label %dequeue, label %done

dequeue:
  %v.ptr = getelementptr inbounds i64, i64* %block, i64 %head
  %v = load i64, i64* %v.ptr, align 8
  %head.next = add i64 %head, 1
  %count.old = load i64, i64* %out_count, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %out_count, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %count.old
  store i64 %v, i64* %out.slot, align 8
  br label %inner.header

inner.header:
  %w = phi i64 [ 0, %dequeue ], [ %w.next, %inner.latch ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next.phi, %inner.latch ]
  %w.cmp = icmp ult i64 %w, %n
  br i1 %w.cmp, label %inner.body, label %inner.exit

inner.body:
  %vn = mul i64 %v, %n
  %idx = add i64 %vn, %w
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj.ptr, align 4
  %is.zero = icmp eq i32 %a, 0
  br i1 %is.zero, label %inner.latch, label %check.dist

check.dist:
  %dist.w.ptr = getelementptr inbounds i32, i32* %dist, i64 %w
  %dw = load i32, i32* %dist.w.ptr, align 4
  %dw.cmp = icmp ne i32 %dw, -1
  br i1 %dw.cmp, label %inner.latch, label %relax

relax:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dist.v.ptr, align 4
  %dv1 = add i32 %dv, 1
  store i32 %dv1, i32* %dist.w.ptr, align 4
  %tail.slot = getelementptr inbounds i64, i64* %block, i64 %tail.cur
  store i64 %w, i64* %tail.slot, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner.latch

inner.latch:
  %tail.next.phi = phi i64 [ %tail.cur, %inner.body ], [ %tail.cur, %check.dist ], [ %tail.inc, %relax ]
  %w.next = add i64 %w, 1
  br label %inner.header

inner.exit:
  br label %outer.latch

outer.latch:
  %tail.after.inner = phi i64 [ %tail.cur, %inner.exit ]
  br label %outer.header

done:
  %block.raw2 = bitcast i64* %block to i8*
  call void @free(i8* %block.raw2)
  ret void
}