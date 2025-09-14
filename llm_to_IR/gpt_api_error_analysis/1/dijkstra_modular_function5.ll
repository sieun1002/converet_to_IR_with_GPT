; ModuleID = 'dijkstra'
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.i8, i32 0, i64 400)
  br label %init.loop

init.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i.ext = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.latch

init.latch:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:
  %iter = phi i32 [ 0, %init.end ], [ %iter.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %iter, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %done

outer.body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %after.u

after.u:
  %u.ext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u.ext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:
  %v = phi i32 [ 0, %after.u ], [ %v.next, %inner.latch ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.body, label %outer.latch

inner.body:
  %v.ext = sext i32 %v to i64
  %u.mul = mul nsw i32 %u, 100
  %u.mul.ext = sext i32 %u.mul to i64
  %idx = add nsw i64 %u.mul.ext, %v.ext
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.is.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.is.zero, label %inner.latch, label %check.sv

check.sv:
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v.ext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.nonzero = icmp ne i32 %s.v, 0
  br i1 %s.v.nonzero, label %inner.latch, label %check.du

check.du:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.is.inf, label %inner.latch, label %compute.alt

compute.alt:
  %alt = add nsw i32 %dist.u, %adj.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.ext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %update, label %inner.latch

update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.latch:
  %iter.next = add nsw i32 %iter, 1
  br label %outer.loop

done:
  ret void
}