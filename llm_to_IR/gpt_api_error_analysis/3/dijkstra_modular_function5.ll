target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  %mem0 = call i8* @memset(i8* %s.i8, i32 0, i64 400)
  br label %init

init:
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %after.init

init.body:
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.latch

init.latch:
  %i.next = add i32 %i, 1
  br label %init

after.init:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer

outer:
  %j = phi i32 [ 0, %after.init ], [ %j.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %j, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %done

outer.body:
  %s.base = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %have.u

have.u:
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner

inner:
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %inner.body, label %outer.latch

inner.body:
  %v.sext = sext i32 %v to i64
  %row.ptr = getelementptr [100 x i32], [100 x i32]* %graph, i64 %u.sext
  %cell.ptr = getelementptr [100 x i32], [100 x i32]* %row.ptr, i64 0, i64 %v.sext
  %w = load i32, i32* %cell.ptr, align 4
  %edge.nz = icmp ne i32 %w, 0
  %s.v.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %v.sext
  %s.v.val = load i32, i32* %s.v.ptr, align 4
  %s.v.zero = icmp eq i32 %s.v.val, 0
  %dist.u.ptr = getelementptr i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.notinf = icmp ne i32 %dist.u, 2147483647
  %c1 = and i1 %edge.nz, %s.v.zero
  %guard = and i1 %c1, %dist.u.notinf
  br i1 %guard, label %relax, label %inner.latch

relax:
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.cmp = icmp slt i32 %sum, %dist.v
  br i1 %lt.cmp, label %update, label %inner.latch

update:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:
  %v.next = add i32 %v, 1
  br label %inner

outer.latch:
  %j.next = add i32 %j, 1
  br label %outer

done:
  ret void
}