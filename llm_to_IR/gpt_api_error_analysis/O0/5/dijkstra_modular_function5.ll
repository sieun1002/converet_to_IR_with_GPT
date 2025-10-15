; target: x86_64 Linux, SysV ABI
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.i8, i32 0, i64 400)

  br label %init.loop

init.loop:                                           ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.cont ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %init.end

init.body:
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add i32 %i, 1
  br label %init.loop

init.end:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4

  %n.minus1 = add i32 %n, -1
  br label %outer.loop

outer.loop:                                          ; count from 0 to n-2
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %outer.cmp = icmp slt i32 %count, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %minidx = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %min.is.neg1 = icmp eq i32 %minidx, -1
  br i1 %min.is.neg1, label %exit, label %got.min

got.min:
  %minidx.sext = sext i32 %minidx to i64
  %s.min.ptr = getelementptr inbounds i32, i32* %s.base, i64 %minidx.sext
  store i32 1, i32* %s.min.ptr, align 4
  br label %inner.loop

inner.loop:                                          ; j from 0 to n-1
  %j = phi i32 [ 0, %got.min ], [ %j.next, %inner.inc ]
  %inner.cmp = icmp slt i32 %j, %n
  br i1 %inner.cmp, label %inner.body.checkEdge, label %outer.inc

inner.body.checkEdge:
  %j.sext = sext i32 %j to i64
  %row.base = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %minidx.sext, i32 0
  %edge.ptr = getelementptr inbounds i32, i32* %row.base, i64 %j.sext
  %edge.val = load i32, i32* %edge.ptr, align 4
  %edge.is.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.is.zero, label %inner.inc, label %checkVisited

checkVisited:
  %s.j.ptr = getelementptr inbounds i32, i32* %s.base, i64 %j.sext
  %s.j.val = load i32, i32* %s.j.ptr, align 4
  %visited = icmp ne i32 %s.j.val, 0
  br i1 %visited, label %inner.inc, label %checkInf

checkInf:
  %dist.min.ptr = getelementptr inbounds i32, i32* %dist, i64 %minidx.sext
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %is.inf = icmp eq i32 %dist.min, 2147483647
  br i1 %is.inf, label %inner.inc, label %relax

relax:
  %cand = add i32 %dist.min, %edge.val
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j.sext
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %cand.lt = icmp slt i32 %cand, %dist.j
  br i1 %cand.lt, label %storeNew, label %inner.inc

storeNew:
  store i32 %cand, i32* %dist.j.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add i32 %j, 1
  br label %inner.loop

outer.inc:
  %count.next = add i32 %count, 1
  br label %outer.loop

exit:
  ret void
}