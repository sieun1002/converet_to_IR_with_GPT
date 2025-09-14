; ModuleID = 'dijkstra_module'
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16

  ; memset s to 0 over 0x190 bytes
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s.i8, i32 0, i64 400)

  ; for (i = 0; i < n; ++i) dist[i] = INT_MAX
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.i.cond

for.i.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp slt i32 %i.val, %n
  br i1 %cmp.i, label %for.i.body, label %for.i.end

for.i.body:
  %i.val.sext = sext i32 %i.val to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.val.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %for.i.cond

for.i.end:
  ; dist[src] = 0
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4

  ; outer loop: for (count = 0; count < n - 1; ++count)
  %count = alloca i32, align 4
  store i32 0, i32* %count, align 4
  br label %outer.cond

outer.cond:
  %count.val = load i32, i32* %count, align 4
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %count.val, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  ; u = min_index(dist, s, n)
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %exit, label %after.u

after.u:
  ; s[u] = 1
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4

  ; inner loop: for (v = 0; v < n; ++v)
  %v = alloca i32, align 4
  store i32 0, i32* %v, align 4
  br label %v.cond

v.cond:
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %v.body, label %v.end

v.body:
  %v.sext = sext i32 %v.val to i64

  ; weight = graph[u][v]
  %row.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u.sext
  %cell.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr, i64 0, i64 %v.sext
  %w = load i32, i32* %cell.ptr, align 4
  %w.nonzero = icmp ne i32 %w, 0
  br i1 %w.nonzero, label %check.s, label %v.inc

check.s:
  ; s[v] == 0?
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v.sext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.zero = icmp eq i32 %s.v, 0
  br i1 %s.v.zero, label %check.distu, label %v.inc

check.distu:
  ; dist[u] != INT_MAX?
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.isinf, label %v.inc, label %compute.alt

compute.alt:
  ; alt = dist[u] + graph[u][v]
  %alt = add nsw i32 %dist.u, %w
  ; if (alt < dist[v]) dist[v] = alt
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %update, label %v.inc

update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %v.inc

v.inc:
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %v.cond

v.end:
  ; ++count
  %count.next = add nsw i32 %count.val, 1
  store i32 %count.next, i32* %count, align 4
  br label %outer.cond

exit:
  ret void
}