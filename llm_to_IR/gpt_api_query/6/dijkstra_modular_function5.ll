; ModuleID = 'dijkstra_module'
source_filename = "dijkstra.ll"

declare i32 @min_index(i32* %dist, i32* %s, i32 %n)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  ; locals
  %s = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %outer = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %alt = alloca i32, align 4

  ; memset s to 0 (400 bytes)
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s.i8, i8 0, i64 400, i1 false)

  ; for (i = 0; i < n; ++i) dist[i] = INT_MAX
  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp slt i32 %i.val, %n
  br i1 %cmp.i, label %init.body, label %init.done

init.body:
  %i.idx = sext i32 %i.val to i64
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i.idx
  store i32 2147483647, i32* %dist.ptr.i, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop

init.done:
  ; dist[src] = 0
  %src.idx = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.idx
  store i32 0, i32* %dist.src.ptr, align 4

  ; outer = 0
  store i32 0, i32* %outer, align 4
  br label %outer.loop

outer.loop:
  ; while (outer < n-1)
  %outer.val = load i32, i32* %outer, align 4
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %outer.val, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:
  ; u = min_index(dist, s, n)
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u.val = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  store i32 %u.val, i32* %u, align 4
  ; if (u == -1) break
  %u.is.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.is.neg1, label %return, label %mark.visited

mark.visited:
  ; s[u] = 1
  %u.idx.64 = sext i32 %u.val to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u.idx.64
  store i32 1, i32* %s.u.ptr, align 4

  ; for (v = 0; v < n; ++v)
  store i32 0, i32* %v, align 4
  br label %inner.loop

inner.loop:
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %inner.body, label %inner.done

inner.body:
  ; if (adj[u][v] != 0 && s[v] == 0 && dist[u] != INT_MAX)
  ; adj offset = u*100 + v
  %u.mul100 = mul nsw i32 %u.val, 100
  %off.uv = add nsw i32 %u.mul100, %v.val
  %off.uv.64 = sext i32 %off.uv to i64
  %adj.uv.ptr = getelementptr inbounds i32, i32* %adj, i64 %off.uv.64
  %adj.uv = load i32, i32* %adj.uv.ptr, align 4
  %adj.nz = icmp ne i32 %adj.uv, 0

  ; s[v] == 0
  %v.idx.64 = sext i32 %v.val to i64
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v.idx.64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.zero = icmp eq i32 %s.v, 0

  ; dist[u] != INT_MAX
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.idx.64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.valid = icmp ne i32 %dist.u, 2147483647

  %cond0 = and i1 %adj.nz, %s.v.zero
  %cond = and i1 %cond0, %dist.u.valid
  br i1 %cond, label %relax, label %inner.cont

relax:
  ; alt = dist[u] + adj[u][v]
  %alt.val = add nsw i32 %dist.u, %adj.uv
  store i32 %alt.val, i32* %alt, align 4

  ; if (alt < dist[v]) dist[v] = alt
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.idx.64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt.val, %dist.v
  br i1 %alt.lt, label %do.update, label %inner.cont

do.update:
  store i32 %alt.val, i32* %dist.v.ptr, align 4
  br label %inner.cont

inner.cont:
  ; v++
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %inner.loop

inner.done:
  ; outer++
  %outer.next = add nsw i32 %outer.val, 1
  store i32 %outer.next, i32* %outer, align 4
  br label %outer.loop

return:
  ret void
}