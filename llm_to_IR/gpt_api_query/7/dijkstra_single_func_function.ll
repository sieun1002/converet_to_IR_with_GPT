; ModuleID = 'dijkstra'
source_filename = "dijkstra.ll"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %n64 = sext i32 %n to i64
  %dist = alloca i32, i64 %n64, align 16
  %visited = alloca i32, i64 %n64, align 16
  br label %init.loop

init.loop:                                         ; i in [0, n)
  %i0 = phi i32 [ 0, %entry ], [ %i1, %init.latch ]
  %init.done = icmp sge i32 %i0, %n
  br i1 %init.done, label %init.end, label %init.body

init.body:
  %i0_64 = sext i32 %i0 to i64
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i0_64
  store i32 2147483647, i32* %dist.i, align 4
  %visited.i = getelementptr inbounds i32, i32* %visited, i64 %i0_64
  store i32 0, i32* %visited.i, align 4
  br label %init.latch

init.latch:
  %i1 = add nsw i32 %i0, 1
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer.loop

outer.loop:                                        ; count in [0, n-1)
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.latch ]
  %nminus1 = add nsw i32 %n, -1
  %outer.done = icmp sge i32 %count, %nminus1
  br i1 %outer.done, label %done.initprint, label %select.init

select.init:
  br label %select.loop

select.loop:                                       ; select min unvisited
  %v = phi i32 [ 0, %select.init ], [ %v.next, %select.latch ]
  %minphi = phi i32 [ 2147483647, %select.init ], [ %min.next, %select.latch ]
  %uphi = phi i32 [ -1, %select.init ], [ %u.next, %select.latch ]
  %sel.done = icmp sge i32 %v, %n
  br i1 %sel.done, label %select.end, label %select.body

select.body:
  %v64 = sext i32 %v to i64
  %visited.v = getelementptr inbounds i32, i32* %visited, i64 %v64
  %vvis = load i32, i32* %visited.v, align 4
  %notVisited = icmp eq i32 %vvis, 0
  br i1 %notVisited, label %consider, label %select.latch

consider:
  %dist.v = getelementptr inbounds i32, i32* %dist, i64 %v64
  %vdist = load i32, i32* %dist.v, align 4
  %isLess = icmp slt i32 %vdist, %minphi
  br i1 %isLess, label %updateMin, label %select.latch

updateMin:
  br label %select.latch

select.latch:
  %min.next = phi i32 [ %minphi, %select.body ], [ %minphi, %consider ], [ %vdist, %updateMin ]
  %u.next   = phi i32 [ %uphi,   %select.body ], [ %uphi,   %consider ], [ %v,     %updateMin ]
  %v.next = add nsw i32 %v, 1
  br label %select.loop

select.end:
  %u.final = phi i32 [ %uphi, %select.loop ]
  %min.final = phi i32 [ %minphi, %select.loop ]
  %u.neg1 = icmp eq i32 %u.final, -1
  br i1 %u.neg1, label %done.initprint, label %mark.visited

mark.visited:
  %u64 = sext i32 %u.final to i64
  %visited.u = getelementptr inbounds i32, i32* %visited, i64 %u64
  store i32 1, i32* %visited.u, align 4
  br label %relax.loop

relax.loop:                                        ; relax all neighbors of u
  %v2 = phi i32 [ 0, %mark.visited ], [ %v2.next, %relax.latch ]
  %relax.done = icmp sge i32 %v2, %n
  br i1 %relax.done, label %outer.latch, label %relax.body

relax.body:
  %v2_64 = sext i32 %v2 to i64
  %rowoff = mul nsw i64 %u64, 100
  %gidx = add nsw i64 %rowoff, %v2_64
  %gptr = getelementptr inbounds i32, i32* %graph, i64 %gidx
  %w = load i32, i32* %gptr, align 4
  %hasEdge = icmp ne i32 %w, 0
  br i1 %hasEdge, label %check.visited.v2, label %relax.latch

check.visited.v2:
  %visited.v2 = getelementptr inbounds i32, i32* %visited, i64 %v2_64
  %v2vis = load i32, i32* %visited.v2, align 4
  %v2notVisited = icmp eq i32 %v2vis, 0
  br i1 %v2notVisited, label %check.distu.inf, label %relax.latch

check.distu.inf:
  %dist.u = getelementptr inbounds i32, i32* %dist, i64 %u64
  %distu = load i32, i32* %dist.u, align 4
  %uNotInf = icmp ne i32 %distu, 2147483647
  br i1 %uNotInf, label %compare.relax, label %relax.latch

compare.relax:
  %dist.v2 = getelementptr inbounds i32, i32* %dist, i64 %v2_64
  %distv2 = load i32, i32* %dist.v2, align 4
  %sum = add nsw i32 %distu, %w
  %better = icmp sgt i32 %distv2, %sum
  br i1 %better, label %do.relax, label %relax.latch

do.relax:
  store i32 %sum, i32* %dist.v2, align 4
  br label %relax.latch

relax.latch:
  %v2.next = add nsw i32 %v2, 1
  br label %relax.loop

outer.latch:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

done.initprint:
  br label %print.loop

print.loop:                                        ; print results
  %pi = phi i32 [ 0, %done.initprint ], [ %pi.next, %print.latch ]
  %print.done = icmp sge i32 %pi, %n
  br i1 %print.done, label %ret, label %print.body

print.body:
  %pi64 = sext i32 %pi to i64
  %pdistptr = getelementptr inbounds i32, i32* %dist, i64 %pi64
  %pdist = load i32, i32* %pdistptr, align 4
  %isInf = icmp eq i32 %pdist, 2147483647
  br i1 %isInf, label %call.inf, label %call.val

call.inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %pi)
  br label %print.latch

call.val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %__ = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %pi, i32 %pdist)
  br label %print.latch

print.latch:
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

ret:
  ret void
}