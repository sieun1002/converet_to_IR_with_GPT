; target
target triple = "x86_64-pc-linux-gnu"

; external declarations
declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

; void dijkstra(int *graph, int n, int src, int *dist)
define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.i8, i32 0, i64 400)

  br label %init.loop

init.loop:
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i.ph, %n
  br i1 %init.cmp, label %init.body, label %after.init

init.body:
  %i.ph.sext = sext i32 %i.ph to i64
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ph.sext
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  %i.next = add i32 %i.ph, 1
  br label %init.loop

after.init:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:
  %iter.ph = phi i32 [ 0, %after.init ], [ %iter.next, %outer.cont ]
  %n.minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %iter.ph, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %ret

outer.body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u.call = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u.call, -1
  br i1 %u.is.neg1, label %ret, label %have.u

have.u:
  %u.sext = sext i32 %u.call to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:
  %v.ph = phi i32 [ 0, %have.u ], [ %v.next, %inner.cont ]
  %inner.cmp = icmp slt i32 %v.ph, %n
  br i1 %inner.cmp, label %inner.body, label %outer.cont

inner.body:
  %v.sext = sext i32 %v.ph to i64
  %u.mul100 = mul i32 %u.call, 100
  %u.mul100.sext = sext i32 %u.mul100 to i64
  %row.base.ptr = getelementptr inbounds i32, i32* %graph, i64 %u.mul100.sext
  %edge.ptr = getelementptr inbounds i32, i32* %row.base.ptr, i64 %v.sext
  %w = load i32, i32* %edge.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.cont, label %check.visited

check.visited:
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v.sext
  %sv = load i32, i32* %s.v.ptr, align 4
  %sv.ne.zero = icmp ne i32 %sv, 0
  br i1 %sv.ne.zero, label %inner.cont, label %check.inf

check.inf:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %inner.cont, label %relax

relax:
  %alt = add i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %do.update, label %inner.cont

do.update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.cont

inner.cont:
  %v.next = add i32 %v.ph, 1
  br label %inner.loop

outer.cont:
  %iter.next = add i32 %iter.ph, 1
  br label %outer.loop

ret:
  ret void
}