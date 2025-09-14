; target: SysV x86-64 (Linux/glibc)
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %s.base.i8 = bitcast i32* %s.base to i8*
  %memset.call = call i8* @memset(i8* %s.base.i8, i32 0, i64 400)

  br label %init.loop

init.loop:                                            ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %after.init

init.body:
  %i64 = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

after.init:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  br label %outer.loop

outer.loop:                                           ; count from 0 to n-2
  %count = phi i32 [ 0, %after.init ], [ %count.next, %outer.inc ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %count, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %return

outer.body:
  %u.call = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u.call, -1
  br i1 %u.is.neg1, label %return, label %have.u

have.u:
  %u64 = sext i32 %u.call to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                           ; v from 0 to n-1
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.inc ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.check1, label %outer.inc

inner.check1:
  %v64 = sext i32 %v to i64
  %u.times.100 = mul nsw i64 %u64, 100
  %idx = add nsw i64 %u.times.100, %v64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %g.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.inc, label %inner.check2

inner.check2:
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v64
  %sv = load i32, i32* %s.v.ptr, align 4
  %sv.is.zero = icmp eq i32 %sv, 0
  br i1 %sv.is.zero, label %inner.check3, label %inner.inc

inner.check3:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %inner.inc, label %inner.relax

inner.relax:
  %alt = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %relax.store, label %inner.inc

relax.store:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.inc:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

return:
  ret void
}