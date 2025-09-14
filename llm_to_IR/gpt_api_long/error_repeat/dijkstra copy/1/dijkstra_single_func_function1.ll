; ModuleID = 'dijkstra'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dijkstra  ; Address: 0x401120
; Intent: Dijkstra single-source shortest paths on an adjacency matrix with fixed row stride 100 (confidence=0.98). Evidence: INF=0x7fffffff, visited[]/dist[] loops with min-extraction and relaxations using row*0x190 + col*4.
; Preconditions: 0 <= src < n <= 100; graph points to a row-major i32 adjacency matrix with row stride 100 and weight 0 meaning no edge.
; Postconditions: Prints "dist[i] = ..." for all i in [0, n).

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @dijkstra(i32* %graph, i32 %n, i32 %src) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                         ; i in [0, n)
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cond = icmp slt i32 %i, %n
  br i1 %init.cond, label %init.body, label %init.done

init.body:
  %i64 = sext i32 %i to i64
  %dist.elem = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.elem, align 4
  %vis.elem = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64
  store i32 0, i32* %vis.elem, align 4
  br label %init.latch

init.latch:
  %i.next = add i32 %i, 1
  br label %init.loop

init.done:
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer.cond

outer.cond:                                        ; count in [0, n-1)
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %outer.ok = icmp slt i32 %count, %n.minus1
  br i1 %outer.ok, label %outer.body, label %after.outer

outer.body:
  br label %scan.loop

scan.loop:                                         ; find min unvisited
  %j = phi i32 [ 0, %outer.body ], [ %j.next, %scan.latch ]
  %minIdx = phi i32 [ -1, %outer.body ], [ %minIdx.next, %scan.latch ]
  %minVal = phi i32 [ 2147483647, %outer.body ], [ %minVal.next, %scan.latch ]
  %scan.cond = icmp slt i32 %j, %n
  br i1 %scan.cond, label %scan.body, label %scan.done

scan.body:
  %j64 = sext i32 %j to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %j64
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %unvisited = icmp eq i32 %vis.j, 0
  br i1 %unvisited, label %check.dist, label %scan.latch

check.dist:
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %is.less = icmp slt i32 %dist.j, %minVal
  br i1 %is.less, label %update.min, label %scan.latch

update.min:
  br label %scan.latch

scan.latch:
  %minIdx.next = phi i32 [ %minIdx, %scan.body ], [ %minIdx, %check.dist ], [ %j, %update.min ]
  %minVal.next = phi i32 [ %minVal, %scan.body ], [ %minVal, %check.dist ], [ %dist.j, %update.min ]
  %j.next = add i32 %j, 1
  br label %scan.loop

scan.done:
  %no.min = icmp eq i32 %minIdx, -1
  br i1 %no.min, label %after.outer, label %after.min

after.min:
  %minIdx64 = sext i32 %minIdx to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %minIdx64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %neigh.loop

neigh.loop:                                        ; relax neighbors v in [0, n)
  %v = phi i32 [ 0, %after.min ], [ %v.next, %neigh.latch ]
  %neigh.cond = icmp slt i32 %v, %n
  br i1 %neigh.cond, label %neigh.body, label %outer.latch

neigh.body:
  %v64 = sext i32 %v to i64
  %rowBase = mul nsw i64 %minIdx64, 100
  %idx.linear = add nsw i64 %rowBase, %v64
  %w.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.linear
  %w = load i32, i32* %w.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  br i1 %has.edge, label %check.unvisited, label %neigh.latch

check.unvisited:
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %v.unvisited = icmp eq i32 %vis.v, 0
  br i1 %v.unvisited, label %check.inf, label %neigh.latch

check.inf:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %minIdx64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %neigh.latch, label %relax.check

relax.check:
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %better = icmp slt i32 %sum, %dist.v
  br i1 %better, label %relax.do, label %neigh.latch

relax.do:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %neigh.latch

neigh.latch:
  %v.next = add i32 %v, 1
  br label %neigh.loop

outer.latch:
  %count.next = add i32 %count, 1
  br label %outer.cond

after.outer:
  br label %print.loop

print.loop:                                        ; i in [0, n)
  %pi = phi i32 [ 0, %after.outer ], [ %pi.next, %print.latch ]
  %print.cond = icmp slt i32 %pi, %n
  br i1 %print.cond, label %print.body, label %ret

print.body:
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %pi)
  br label %print.latch

print.val:
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %pi, i32 %dist.pi)
  br label %print.latch

print.latch:
  %pi.next = add i32 %pi, 1
  br label %print.loop

ret:
  ret void
}