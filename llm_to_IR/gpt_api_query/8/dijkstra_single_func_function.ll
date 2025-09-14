; LLVM IR (LLVM 14) for function: dijkstra
; Assumptions inferred from disassembly:
; - graph is a contiguous adjacency matrix with fixed row stride 100 (0x190 bytes per row = 100 ints)
; - n <= 100
; - INF = 2147483647 (0x7FFFFFFF)
; - Prints final distances using printf

declare i32 @printf(i8*, ...)

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %minIndex = alloca i32, align 4
  %minDist = alloca i32, align 4
  %u = alloca i32, align 4
  %j = alloca i32, align 4
  %v = alloca i32, align 4

  ; Initialize dist[i] = INF and visited[i] = 0 for i in [0, n)
  store i32 0, i32* %i, align 4
init.loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp.init = icmp slt i32 %i.val, %n
  br i1 %cmp.init, label %init.loop.body, label %init.loop.end

init.loop.body:
  %i64 = sext i32 %i.val to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop.cond

init.loop.end:
  ; dist[src] = 0
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  ; count = 0
  store i32 0, i32* %count, align 4
outer.cond:
  %count.val = load i32, i32* %count, align 4
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %count.val, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %print.init

outer.body:
  ; minIndex = -1, minDist = INF
  store i32 -1, i32* %minIndex, align 4
  store i32 2147483647, i32* %minDist, align 4

  ; for (j=0; j<n; ++j) find unvisited with minimal dist
  store i32 0, i32* %j, align 4
minsel.cond:
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp slt i32 %j.val, %n
  br i1 %cmp.j, label %minsel.body, label %minsel.end

minsel.body:
  %j64 = sext i32 %j.val to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %j64
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.j, 0
  br i1 %is.unvisited, label %minsel.checkdist, label %minsel.inc

minsel.checkdist:
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %cur.minDist = load i32, i32* %minDist, align 4
  %lt = icmp slt i32 %dist.j, %cur.minDist
  br i1 %lt, label %minsel.update, label %minsel.inc

minsel.update:
  store i32 %dist.j, i32* %minDist, align 4
  store i32 %j.val, i32* %minIndex, align 4
  br label %minsel.inc

minsel.inc:
  %j.next = add nsw i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %minsel.cond

minsel.end:
  ; if (minIndex == -1) break
  %minIndex.val = load i32, i32* %minIndex, align 4
  %minIndex.is.neg1 = icmp eq i32 %minIndex.val, -1
  br i1 %minIndex.is.neg1, label %outer.break, label %after.minsel

outer.break:
  br label %print.init

after.minsel:
  ; visited[minIndex] = 1
  %u.val = load i32, i32* %minIndex, align 4
  store i32 %u.val, i32* %u, align 4
  %u64 = sext i32 %u.val to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4

  ; for (v=0; v<n; ++v) relax edges
  store i32 0, i32* %v, align 4
relax.cond:
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:
  %v64 = sext i32 %v.val to i64
  ; weight = graph[u*100 + v]
  %u64.forIdx = sext i32 %u.val to i64
  %row.off = mul nsw i64 %u64.forIdx, 100
  %g.idx = add nsw i64 %row.off, %v64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %g.idx
  %w = load i32, i32* %g.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  br i1 %has.edge, label %relax.check.visited, label %relax.inc

relax.check.visited:
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %v.unvisited = icmp eq i32 %vis.v, 0
  br i1 %v.unvisited, label %relax.check.infdist, label %relax.inc

relax.check.infdist:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax.inc, label %relax.check.better

relax.check.better:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt = add nsw i32 %dist.u, %w
  %better = icmp sgt i32 %dist.v, %alt
  br i1 %better, label %relax.update, label %relax.inc

relax.update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %relax.cond

relax.end:
  ; count++
  %count.next = add nsw i32 %count.val, 1
  store i32 %count.next, i32* %count, align 4
  br label %outer.cond

; Printing results
print.init:
  store i32 0, i32* %i, align 4
print.cond:
  %i2 = load i32, i32* %i, align 4
  %cmp.print = icmp slt i32 %i2, %n
  br i1 %cmp.print, label %print.body, label %end

print.body:
  %i2_64 = sext i32 %i2 to i64
  %dist.i2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i2_64
  %dist.i2 = load i32, i32* %dist.i2.ptr, align 4
  %is.inf = icmp eq i32 %dist.i2, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i2)
  br label %print.inc

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %i2, i32 %dist.i2)
  br label %print.inc

print.inc:
  %i2.next = add nsw i32 %i2, 1
  store i32 %i2.next, i32* %i, align 4
  br label %print.cond

end:
  ret void
}