; Target: x86_64 Linux, LLVM 14
target triple = "x86_64-unknown-linux-gnu"

declare i8* @memset(i8* nocapture, i32, i64)
declare i32 @min_index(i32* nocapture, i32* nocapture, i32)

define void @dijkstra(i32* nocapture %graph, i32 %n, i32 %src, i32* nocapture %dist) {
entry:
  %s = alloca [100 x i32], align 16

  ; memset s to 0 (400 bytes)
  %s.base.i32 = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %s.base.i8 = bitcast i32* %s.base.i32 to i8*
  %memset.call = call i8* @memset(i8* %s.base.i8, i32 0, i64 400)

  br label %init.loop

init.loop:                                           ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body.end ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.body.end

init.body.end:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                          ; k from 0 to n-2
  %k = phi i32 [ 0, %init.end ], [ %k.next, %outer.iter.end ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %k, %n.minus1
  br i1 %outer.cmp, label %outer.iter, label %done

outer.iter:
  %s.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.ptr, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %mark.u

mark.u:
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.ptr, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                          ; v from 0 to n-1
  %v = phi i32 [ 0, %mark.u ], [ %v.next, %inner.iter.end ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.iter, label %outer.iter.end

inner.iter:
  %u.mul.100 = mul nsw i32 %u, 100
  %idx = add nsw i32 %u.mul.100, %v
  %idx.sext = sext i32 %idx to i64
  %graph.elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.sext
  %edge = load i32, i32* %graph.elem.ptr, align 4
  %edge.is.zero = icmp eq i32 %edge, 0
  br i1 %edge.is.zero, label %inner.iter.end, label %check.s.v

check.s.v:
  %v.sext = sext i32 %v to i64
  %s.v.ptr = getelementptr inbounds i32, i32* %s.ptr, i64 %v.sext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.is.zero = icmp eq i32 %s.v, 0
  br i1 %s.v.is.zero, label %check.dist.u, label %inner.iter.end

check.dist.u:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.is.inf, label %inner.iter.end, label %compute.alt

compute.alt:
  %alt = add nsw i32 %dist.u, %edge
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %do.update, label %inner.iter.end

do.update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.iter.end

inner.iter.end:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.iter.end:
  %k.next = add nsw i32 %k, 1
  br label %outer.loop

done:
  ret void
}