; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmp.n0 = icmp eq i64 %n, 0
  %cmp.start = icmp uge i64 %start, %n
  %bad = or i1 %cmp.n0, %cmp.start
  br i1 %bad, label %early, label %init.header

early:
  store i64 0, i64* %outCount, align 8
  br label %ret

init.header:
  br label %init.loop

init.loop:
  %i.init = phi i64 [ 0, %init.header ], [ %i.next, %init.body ]
  %cond.init = icmp ult i64 %i.init, %n
  br i1 %cond.init, label %init.body, label %alloc

init.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.init
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i.init, 1
  br label %init.loop

alloc:
  %size = shl i64 %n, 3
  %buf = call i8* @malloc(i64 %size)
  %q = bitcast i8* %buf to i64*
  %isnull = icmp eq i8* %buf, null
  br i1 %isnull, label %early2, label %afterAlloc

early2:
  store i64 0, i64* %outCount, align 8
  br label %ret

afterAlloc:
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  %q.store.ptr0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q.store.ptr0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer.cond

outer.cond:
  %head.phi = phi i64 [ 0, %afterAlloc ], [ %head.next2, %outer.latch ]
  %tail.phi = phi i64 [ 1, %afterAlloc ], [ %tail.next2, %outer.latch ]
  %cmp.ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp.ht, label %outer.body, label %cleanup

outer.body:
  %q.load.ptr = getelementptr inbounds i64, i64* %q, i64 %head.phi
  %x = load i64, i64* %q.load.ptr, align 8
  %head.next2 = add i64 %head.phi, 1
  %cnt0 = load i64, i64* %outCount, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %outCount, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %x, i64* %out.slot, align 8
  br label %inner.header

inner.header:
  %i2 = phi i64 [ 0, %outer.body ], [ %i2.next, %inner.advance.merge ]
  %tail.curr = phi i64 [ %tail.phi, %outer.body ], [ %tail.next, %inner.advance.merge ]
  %cond.inner = icmp ult i64 %i2, %n
  br i1 %cond.inner, label %inner.body, label %outer.latch

inner.body:
  %mul = mul i64 %x, %n
  %idx = add i64 %mul, %i2
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %val = load i32, i32* %adj.ptr, align 4
  %iszero = icmp eq i32 %val, 0
  br i1 %iszero, label %inner.advance.no, label %inner.check2

inner.check2:
  %dist.i2.ptr = getelementptr inbounds i32, i32* %dist, i64 %i2
  %di = load i32, i32* %dist.i2.ptr, align 4
  %isneg1 = icmp eq i32 %di, -1
  br i1 %isneg1, label %inner.visit, label %inner.advance.no

inner.visit:
  %dist.x.ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dx = load i32, i32* %dist.x.ptr, align 4
  %dx1 = add i32 %dx, 1
  store i32 %dx1, i32* %dist.i2.ptr, align 4
  %q.enq.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.curr
  store i64 %i2, i64* %q.enq.ptr, align 8
  %tail.inc = add i64 %tail.curr, 1
  br label %inner.advance.yes

inner.advance.no:
  br label %inner.advance.merge

inner.advance.yes:
  br label %inner.advance.merge

inner.advance.merge:
  %tail.next = phi i64 [ %tail.curr, %inner.advance.no ], [ %tail.inc, %inner.advance.yes ]
  %i2.next = add i64 %i2, 1
  br label %inner.header

outer.latch:
  %tail.next2 = phi i64 [ %tail.curr, %inner.header ]
  br label %outer.cond

cleanup:
  %buf.cast = bitcast i64* %q to i8*
  call void @free(i8* %buf.cast)
  br label %ret

ret:
  ret void
}