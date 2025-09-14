; ModuleID = 'dijkstra.ll'
source_filename = "dijkstra"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define dso_local void @dijkstra(i32* nocapture %graph, i32 %V, i32 %src, i32* nocapture %dist) local_unnamed_addr {
entry:
  %s = alloca [100 x i32], align 16
  %s_i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s_i8, i32 0, i64 400)

  ; for (i = 0; i < V; ++i) dist[i] = INT_MAX;
  br label %init.loop

init.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i, %V
  br i1 %cmp.init, label %init.body, label %init.done

init.body:
  %i64 = sext i32 %i to i64
  %di = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %di, align 4
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.done:
  ; dist[src] = 0;
  %src64 = sext i32 %src to i64
  %dsrc = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dsrc, align 4

  ; outer loop: count = 0; count < V-1;
  br label %outer.loop

outer.loop:
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.latch ]
  %Vm1 = add nsw i32 %V, -1
  %cmp.outer = icmp slt i32 %count, %Vm1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %sbase = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %sbase, i32 %V)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %exit, label %after.min

after.min:
  ; s[u] = 1;
  %u64 = sext i32 %u to i64
  %su.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u64
  store i32 1, i32* %su.ptr, align 4

  ; v loop: for (v = 0; v < V; ++v)
  br label %v.loop

v.loop:
  %v = phi i32 [ 0, %after.min ], [ %v.next, %v.latch ]
  %cmp.v = icmp slt i32 %v, %V
  br i1 %cmp.v, label %v.body, label %outer.latch

v.body:
  ; if graph[u][v] != 0
  %v64 = sext i32 %v to i64
  %rowBase = mul nsw i64 %u64, 100
  %idx = add nsw i64 %rowBase, %v64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %g.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  br i1 %has.edge, label %check.sv, label %v.latch

check.sv:
  ; and s[v] == 0
  %sv.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v64
  %sv = load i32, i32* %sv.ptr, align 4
  %unvisited.v = icmp eq i32 %sv, 0
  br i1 %unvisited.v, label %check.du, label %v.latch

check.du:
  ; and dist[u] != INT_MAX
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %du = load i32, i32* %du.ptr, align 4
  %du.valid = icmp ne i32 %du, 2147483647
  br i1 %du.valid, label %relax.try, label %v.latch

relax.try:
  ; temp = dist[u] + graph[u][v]
  %temp = add nsw i32 %du, %w
  ; if temp < dist[v] then dist[v] = temp
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dv.ptr, align 4
  %lt = icmp slt i32 %temp, %dv
  br i1 %lt, label %relax.store, label %v.latch

relax.store:
  store i32 %temp, i32* %dv.ptr, align 4
  br label %v.latch

v.latch:
  %v.next = add nsw i32 %v, 1
  br label %v.loop

outer.latch:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

exit:
  ret void
}