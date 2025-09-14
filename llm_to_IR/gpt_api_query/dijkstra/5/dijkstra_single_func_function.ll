; ModuleID = 'dijkstra.ll'
target triple = "x86_64-unknown-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_dist = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16

  br label %init.loop

init.loop:                                         ; for (i = 0; i < n; ++i)
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %after.init

init.body:
  %i64 = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %vis.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.i.ptr, align 4
  br label %init.latch

init.latch:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

after.init:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  br label %outer.loop

outer.loop:                                        ; for (count = 0; count < n-1; ++count)
  %count = phi i32 [ 0, %after.init ], [ %count.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond = icmp slt i32 %count, %n.minus1
  br i1 %outer.cond, label %outer.body, label %after.outer

outer.body:
  br label %findmin.loop

findmin.loop:                                      ; find u = argmin dist[v] among !visited
  %v = phi i32 [ 0, %outer.body ], [ %v.next, %findmin.latch ]
  %curMin = phi i32 [ 2147483647, %outer.body ], [ %min.next, %findmin.latch ]
  %curU = phi i32 [ -1, %outer.body ], [ %u.next, %findmin.latch ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %findmin.body, label %after.findmin

findmin.body:
  %v64 = sext i32 %v to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %notVisited = icmp eq i32 %vis.v, 0
  %ltMin = icmp slt i32 %dist.v, %curMin
  %take = and i1 %notVisited, %ltMin
  %min.next = select i1 %take, i32 %dist.v, i32 %curMin
  %u.next = select i1 %take, i32 %v, i32 %curU
  br label %findmin.latch

findmin.latch:
  %v.next = add nsw i32 %v, 1
  br label %findmin.loop

after.findmin:
  %min.out = phi i32 [ %curMin, %findmin.loop ]
  %u.out = phi i32 [ %curU, %findmin.loop ]
  %u.is.neg1 = icmp eq i32 %u.out, -1
  br i1 %u.is.neg1, label %after.outer, label %relax.prep

relax.prep:
  %u64 = sext i32 %u.out to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                        ; for (v = 0; v < n; ++v)
  %v2 = phi i32 [ 0, %relax.prep ], [ %v2.next, %relax.latch ]
  %v2.cmp = icmp slt i32 %v2, %n
  br i1 %v2.cmp, label %relax.body, label %outer.latch

relax.body:
  %u64.2 = sext i32 %u.out to i64
  %mul100 = mul nsw i64 %u64.2, 100
  %v2.64 = sext i32 %v2 to i64
  %idx = add nsw i64 %mul100, %v2.64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %w, 0
  br i1 %edge.zero, label %relax.latch, label %check.vis2

check.vis2:
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2.64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %notVisited2 = icmp eq i32 %vis.v2, 0
  br i1 %notVisited2, label %check.distu, label %relax.latch

check.distu:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64.2
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax.latch, label %maybe.update

maybe.update:
  %newd = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2.64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %improve = icmp sgt i32 %dist.v2, %newd
  br i1 %improve, label %do.update, label %relax.latch

do.update:
  store i32 %newd, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:
  %v2.next = add nsw i32 %v2, 1
  br label %relax.loop

outer.latch:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

after.outer:                                       ; print results
  br label %print.loop

print.loop:
  %pi = phi i32 [ 0, %after.outer ], [ %pi.next, %print.latch ]
  %pi.cmp = icmp slt i32 %pi, %n
  br i1 %pi.cmp, label %print.body, label %end

print.body:
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %pi.is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %pi.is.inf, label %print.inf, label %print.norm

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %pi)
  br label %print.latch

print.norm:
  %fmt.dist.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_dist, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i32 %pi, i32 %dist.pi)
  br label %print.latch

print.latch:
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

end:
  ret void
}