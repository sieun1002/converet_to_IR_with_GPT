; target triple and datalayout
target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.cast = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.cast, i32 0, i64 400)
  br label %init.loop

init.loop:                                            ; i in [0, n)
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.cont ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %after.init

init.body:
  %i.ext = sext i32 %i to i64
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add i32 %i, 1
  br label %init.loop

after.init:
  %src.ext = sext i32 %src to i64
  %src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %src.ptr, align 4
  br label %outer.loop

outer.loop:                                           ; t in [0, n-1)
  %t = phi i32 [ 0, %after.init ], [ %t.next, %outer.inc ]
  %nminus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %t, %nminus1
  br i1 %cond.outer, label %outer.body, label %ret

outer.body:
  %s.i32ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.i32ptr0, i32 %n)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %ret, label %mark.u

mark.u:
  %u.ext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.i32ptr0, i64 %u.ext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                           ; v in [0, n)
  %v = phi i32 [ 0, %mark.u ], [ %v.next, %inner.inc ]
  %v.cond = icmp slt i32 %v, %n
  br i1 %v.cond, label %inner.body.entry, label %outer.inc

inner.body.entry:
  %u.sext2 = sext i32 %u to i64
  %v.sext = sext i32 %v to i64
  %u.mul100 = mul i64 %u.sext2, 100
  %idx = add i64 %u.mul100, %v.sext
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %g.val = load i32, i32* %g.ptr, align 4
  %g.iszero = icmp eq i32 %g.val, 0
  br i1 %g.iszero, label %inner.inc, label %check.visited

check.visited:
  %s.v.ptr = getelementptr inbounds i32, i32* %s.i32ptr0, i64 %v.sext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %visited = icmp ne i32 %s.v, 0
  br i1 %visited, label %inner.inc, label %check.distinf

check.distinf:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.sext2
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %isinf, label %inner.inc, label %relax

relax:
  %tmp = add i32 %dist.u, %g.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmpupd = icmp slt i32 %tmp, %dist.v
  br i1 %cmpupd, label %do.update, label %inner.inc

do.update:
  store i32 %tmp, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add i32 %v, 1
  br label %inner.loop

outer.inc:
  %t.next = add i32 %t, 1
  br label %outer.loop

ret:
  ret void
}