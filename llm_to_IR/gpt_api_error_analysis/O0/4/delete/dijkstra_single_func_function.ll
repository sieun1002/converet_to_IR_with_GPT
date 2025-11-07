@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                            ; i from 0 to n-1
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp slt i32 %i.phi, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i.phi to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i.phi, 1
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                           ; count from 0 to n-2
  %count.phi = phi i32 [ 0, %init.end ], [ %count.next, %outer.cont ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond = icmp sge i32 %count.phi, %n.minus1
  br i1 %outer.cond, label %print.start, label %outer.body

outer.body:
  br label %findmin.loop

findmin.loop:                                         ; find unvisited vertex with min dist
  %minIdx.phi = phi i32 [ -1, %outer.body ], [ %minIdx.next, %findmin.inc ]
  %minDist.phi = phi i32 [ 2147483647, %outer.body ], [ %minDist.next, %findmin.inc ]
  %v.phi = phi i32 [ 0, %outer.body ], [ %v.next, %findmin.inc ]
  %v.cmp = icmp slt i32 %v.phi, %n
  br i1 %v.cmp, label %findmin.body, label %findmin.end

findmin.body:
  %v64 = sext i32 %v.phi to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %isVisited = icmp ne i32 %vis.v, 0
  br i1 %isVisited, label %findmin.inc, label %findmin.check

findmin.check:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %less = icmp slt i32 %dist.v, %minDist.phi
  br i1 %less, label %findmin.update, label %findmin.inc

findmin.update:
  br label %findmin.inc

findmin.inc:
  %minDist.next = phi i32 [ %minDist.phi, %findmin.body ], [ %minDist.phi, %findmin.check ], [ %dist.v, %findmin.update ]
  %minIdx.next = phi i32 [ %minIdx.phi, %findmin.body ], [ %minIdx.phi, %findmin.check ], [ %v.phi, %findmin.update ]
  %v.next = add nsw i32 %v.phi, 1
  br label %findmin.loop

findmin.end:
  %minIdx.final = phi i32 [ %minIdx.phi, %findmin.loop ]
  %minDist.final = phi i32 [ %minDist.phi, %findmin.loop ]
  %noCandidate = icmp eq i32 %minIdx.final, -1
  br i1 %noCandidate, label %outer.break, label %selected

selected:
  %minIdx64 = sext i32 %minIdx.final to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %minIdx64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:                                           ; relax neighbors
  %v2.phi = phi i32 [ 0, %selected ], [ %v2.next, %relax.inc ]
  %v2.cmp = icmp slt i32 %v2.phi, %n
  br i1 %v2.cmp, label %relax.body, label %relax.end

relax.body:
  %minIdx.mul = mul nsw i32 %minIdx.final, 100
  %idx.sum = add nsw i32 %minIdx.mul, %v2.phi
  %idx.sum64 = sext i32 %idx.sum to i64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.sum64
  %edge.w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %edge.w, 0
  br i1 %edge.zero, label %relax.inc, label %relax.checkVis

relax.checkVis:
  %v2.64 = sext i32 %v2.phi to i64
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2.64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2Visited = icmp ne i32 %vis.v2, 0
  br i1 %v2Visited, label %relax.inc, label %relax.checkInf

relax.checkInf:
  %dist.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %minIdx64
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %isInf = icmp eq i32 %dist.min, 2147483647
  br i1 %isInf, label %relax.inc, label %relax.compare

relax.compare:
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2.64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %sum = add nsw i32 %dist.min, %edge.w
  %better = icmp sgt i32 %dist.v2, %sum
  br i1 %better, label %relax.update, label %relax.inc

relax.update:
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:
  %v2.next = add nsw i32 %v2.phi, 1
  br label %relax.loop

relax.end:
  br label %outer.cont

outer.cont:
  %count.next = add nsw i32 %count.phi, 1
  br label %outer.loop

outer.break:
  br label %print.start

print.start:
  br label %print.loop

print.loop:                                           ; print results
  %pidx.phi = phi i32 [ 0, %print.start ], [ %pidx.next, %print.inc ]
  %p.cmp = icmp slt i32 %pidx.phi, %n
  br i1 %p.cmp, label %print.body, label %ret.block

print.body:
  %pidx64 = sext i32 %pidx.phi to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pidx64
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %isInf2 = icmp eq i32 %dist.p, 2147483647
  br i1 %isInf2, label %print.inf, label %print.val

print.inf:
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %pidx.phi)
  br label %print.inc

print.val:
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %pidx.phi, i32 %dist.p)
  br label %print.inc

print.inc:
  %pidx.next = add nsw i32 %pidx.phi, 1
  br label %print.loop

ret.block:
  ret void
}