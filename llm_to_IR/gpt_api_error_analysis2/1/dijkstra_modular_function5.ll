; ModuleID = 'dijkstra.ll'
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define dso_local void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %visited = alloca [100 x i32], align 16
  %visited.i8 = bitcast [100 x i32]* %visited to i8*
  %call.memset = call i8* @memset(i8* %visited.i8, i32 0, i64 400)
  br label %init.loop

init.loop:                                             ; i loop condition
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i to i64
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.cond

outer.cond:
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.count = icmp slt i32 %count, %n.minus1
  br i1 %cmp.count, label %outer.body.entry, label %outer.end

outer.body.entry:
  %visited.base = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %visited.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %outer.end, label %outer.body

outer.body:
  %u64 = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %v.loop.cond

v.loop.cond:
  %v = phi i32 [ 0, %outer.body ], [ %v.next, %v.latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %v.loop.body, label %v.loop.end

v.loop.body:
  %u64.b = sext i32 %u to i64
  %v64.b = sext i32 %v to i64
  %u.times.100 = mul nsw i64 %u64.b, 100
  %idx = add nsw i64 %u.times.100, %v64.b
  %graph.elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %graph.elem.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %v.latch, label %check.visited

check.visited:
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64.b
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.nonzero = icmp ne i32 %s.v, 0
  br i1 %s.v.nonzero, label %v.latch, label %check.distu

check.distu:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64.b
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.is.max = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.is.max, label %v.latch, label %compute.temp

compute.temp:
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64.b
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %sum.lt.distv = icmp slt i32 %sum, %dist.v
  br i1 %sum.lt.distv, label %do.update, label %v.latch

do.update:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %v.latch

v.latch:
  %v.next = add nsw i32 %v, 1
  br label %v.loop.cond

v.loop.end:
  br label %outer.latch

outer.latch:
  %count.next = add nsw i32 %count, 1
  br label %outer.cond

outer.end:
  ret void
}