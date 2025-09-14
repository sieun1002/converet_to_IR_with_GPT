; target triple: adjust if needed to match your build environment
; target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8* noundef, i32 noundef, i64 noundef)
declare i32 @min_index(i32* noundef, i32* noundef, i32 noundef)

define void @dijkstra(i32* noundef %adj, i32 noundef %n, i32 noundef %src, i32* noundef %dist) local_unnamed_addr {
entry:
  %s.allo = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s.allo to i8*
  %memset.call = call i8* @memset(i8* noundef %s.i8, i32 noundef 0, i64 noundef 400)
  br label %init.loop

init.loop:
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i.ph, %n
  br i1 %init.cmp, label %init.body, label %init.done

init.body:
  %i64 = sext i32 %i.ph to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add i32 %i.ph, 1
  br label %init.loop

init.done:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:
  %iter.ph = phi i32 [ 0, %init.done ], [ %iter.next, %outer.cont ]
  %n.minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %iter.ph, %n.minus1
  br i1 %outer.cmp, label %choose.u, label %end

choose.u:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s.allo, i64 0, i64 0
  %u.call = call i32 @min_index(i32* noundef %dist, i32* noundef %s.base, i32 noundef %n)
  %u.neg1 = icmp eq i32 %u.call, -1
  br i1 %u.neg1, label %end, label %mark.u

mark.u:
  %u64 = sext i32 %u.call to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:
  %v.ph = phi i32 [ 0, %mark.u ], [ %v.next, %inner.cont ]
  %inner.cmp = icmp slt i32 %v.ph, %n
  br i1 %inner.cmp, label %edge.check, label %outer.cont

edge.check:
  %v64.a = sext i32 %v.ph to i64
  %u64.a = sext i32 %u.call to i64
  %u.times.100 = mul i64 %u64.a, 100
  %uv.index = add i64 %u.times.100, %v64.a
  %w.ptr = getelementptr inbounds i32, i32* %adj, i64 %uv.index
  %w.val = load i32, i32* %w.ptr, align 4
  %w.is.zero = icmp eq i32 %w.val, 0
  br i1 %w.is.zero, label %inner.cont, label %check.sv

check.sv:
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v64.a
  %s.v.val = load i32, i32* %s.v.ptr, align 4
  %v.visited = icmp ne i32 %s.v.val, 0
  br i1 %v.visited, label %inner.cont, label %check.du.inf

check.du.inf:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64.a
  %dist.u.val = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u.val, 2147483647
  br i1 %u.is.inf, label %inner.cont, label %relax

relax:
  %alt = add i32 %dist.u.val, %w.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64.a
  %dist.v.val = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v.val
  br i1 %alt.lt, label %update, label %inner.cont

update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.cont

inner.cont:
  %v.next = add i32 %v.ph, 1
  br label %inner.loop

outer.cont:
  %iter.next = add i32 %iter.ph, 1
  br label %outer.loop

end:
  ret void
}