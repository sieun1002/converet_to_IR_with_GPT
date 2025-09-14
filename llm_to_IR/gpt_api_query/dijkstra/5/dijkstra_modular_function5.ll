; ModuleID = 'dijkstra_module'
target triple = "x86_64-unknown-linux-gnu"

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
declare i32 @min_index(i32* nocapture readonly, i32* nocapture readonly, i32)

define void @dijkstra(i32* nocapture %graph, i32 %n, i32 %src, i32* nocapture %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %outer = alloca i32, align 4
  %v = alloca i32, align 4
  %s.cast = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s.cast, i8 0, i64 400, i1 false)

  store i32 0, i32* %i, align 4
  br label %init.loop.cond

init.loop.cond:                                   ; i < n
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp slt i32 %i.val, %n
  br i1 %cmp.i, label %init.loop.body, label %init.loop.end

init.loop.body:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i32 %i.val
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop.cond

init.loop.end:
  %src.ptr = getelementptr inbounds i32, i32* %dist, i32 %src
  store i32 0, i32* %src.ptr, align 4

  store i32 0, i32* %outer, align 4
  br label %outer.cond

outer.cond:                                       ; outer < n-1
  %outer.val = load i32, i32* %outer, align 4
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %outer.val, %nminus1
  br i1 %cmp.outer, label %outer.body, label %end

outer.body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i32 0, i32 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %end, label %after.u

after.u:
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i32 0, i32 %u
  store i32 1, i32* %s.u.ptr, align 4

  store i32 0, i32* %v, align 4
  br label %inner.cond

inner.cond:                                       ; v < n
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %inner.body, label %inner.end

inner.body:
  %u.mul100 = mul nsw i32 %u, 100
  %uv.index = add nsw i32 %u.mul100, %v.val
  %w.ptr = getelementptr inbounds i32, i32* %graph, i32 %uv.index
  %w = load i32, i32* %w.ptr, align 4
  %hasEdge = icmp ne i32 %w, 0
  br i1 %hasEdge, label %check.sv, label %inner.inc

check.sv:
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i32 0, i32 %v.val
  %s.v = load i32, i32* %s.v.ptr, align 4
  %sv.zero = icmp eq i32 %s.v, 0
  br i1 %sv.zero, label %check.distu, label %inner.inc

check.distu:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i32 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.isinf, label %inner.inc, label %relax

relax:
  %temp = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i32 %v.val
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt = icmp slt i32 %temp, %dist.v
  br i1 %lt, label %do.store, label %inner.inc

do.store:
  store i32 %temp, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %inner.cond

inner.end:
  %outer.next = add nsw i32 %outer.val, 1
  store i32 %outer.next, i32* %outer, align 4
  br label %outer.cond

end:
  ret void
}