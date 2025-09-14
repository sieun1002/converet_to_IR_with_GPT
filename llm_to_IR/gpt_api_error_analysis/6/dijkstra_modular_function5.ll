; ModuleID = 'dijkstra_module'
source_filename = "dijkstra_module"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16

  %s.cast = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.cast, i32 0, i64 400)

  br label %init.loop

init.loop:                                            ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.cont ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %init.after

init.body:
  %i.sext = sext i32 %i to i64
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.after:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4

  br label %outer.cond

outer.cond:                                           ; k from 0 to n-2
  %k = phi i32 [ 0, %init.after ], [ %k.next, %outer.iter.end ], [ %k, %exit ] 
  %n.minus1 = add nsw i32 %n, -1
  %k.cmp = icmp slt i32 %k, %n.minus1
  br i1 %k.cmp, label %outer.body, label %exit

outer.body:
  %s.data = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.data, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %exit, label %mark.u

mark.u:
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.cond

inner.cond:                                           ; v from 0 to n-1
  %v = phi i32 [ 0, %mark.u ], [ %v.next, %inner.iter.end ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %inner.body, label %outer.iter.end

inner.body:
  %u64 = sext i32 %u to i64
  %mul.u100 = mul nsw i64 %u64, 100
  %v64 = sext i32 %v to i64
  %idx.uv = add nsw i64 %mul.u100, %v64
  %g.uv.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.uv
  %w = load i32, i32* %g.uv.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.iter.end, label %check.sv

check.sv:
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.is.set = icmp ne i32 %s.v, 0
  br i1 %s.v.is.set, label %inner.iter.end, label %check.du

check.du:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %du = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %du, 2147483647
  br i1 %du.is.inf, label %inner.iter.end, label %relax

relax:
  %alt = add nsw i32 %du, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dist.v.ptr, align 4
  %better = icmp slt i32 %alt, %dv
  br i1 %better, label %store.alt, label %inner.iter.end

store.alt:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.iter.end

inner.iter.end:
  %v.next = add nsw i32 %v, 1
  br label %inner.cond

outer.iter.end:
  %k.next = add nsw i32 %k, 1
  br label %outer.cond

exit:
  ret void
}