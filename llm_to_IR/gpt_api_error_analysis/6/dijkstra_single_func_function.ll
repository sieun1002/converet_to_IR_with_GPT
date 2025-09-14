; ModuleID = 'dijkstra.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @dijkstra(i32* noundef %graph, i32 noundef %n, i32 noundef %src) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %init.body, label %init.exit

init.body:
  %i64 = sext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.exit:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:
  %k = phi i32 [ 0, %init.exit ], [ %k.next, %outer.inc ]
  %nsub1 = add nsw i32 %n, -1
  %ok = icmp slt i32 %k, %nsub1
  br i1 %ok, label %outer.body, label %outer.exit

outer.body:
  br label %select.loop

select.loop:
  %j = phi i32 [ 0, %outer.body ], [ %j.next, %select.inc ]
  %minIndex = phi i32 [ -1, %outer.body ], [ %minIndex.phi, %select.inc ]
  %minDist = phi i32 [ 2147483647, %outer.body ], [ %minDist.phi, %select.inc ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %select.body, label %select.exit

select.body:
  %j64 = sext i32 %j to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %j64
  %visj = load i32, i32* %vis.j.ptr, align 4
  %visj.zero = icmp eq i32 %visj, 0
  br i1 %visj.zero, label %sel.check2, label %select.inc

sel.check2:
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %distj = load i32, i32* %dist.j.ptr, align 4
  %less = icmp slt i32 %distj, %minDist
  br i1 %less, label %sel.update, label %select.inc

sel.update:
  br label %select.inc

select.inc:
  %minDist.phi = phi i32 [ %minDist, %select.body ], [ %minDist, %sel.check2 ], [ %distj, %sel.update ]
  %minIndex.phi = phi i32 [ %minIndex, %select.body ], [ %minIndex, %sel.check2 ], [ %j, %sel.update ]
  %j.next = add nsw i32 %j, 1
  br label %select.loop

select.exit:
  %minIndex.out = phi i32 [ %minIndex, %select.loop ]
  %minidx.neg1 = icmp eq i32 %minIndex.out, -1
  br i1 %minidx.neg1, label %outer.exit, label %mark.visited

mark.visited:
  %min64 = sext i32 %minIndex.out to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %min64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:
  %v = phi i32 [ 0, %mark.visited ], [ %v.next, %relax.inc ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %relax.body, label %outer.inc

relax.body:
  %v64 = sext i32 %v to i64
  %rowIndex64 = sext i32 %minIndex.out to i64
  %rowMul = mul nsw i64 %rowIndex64, 100
  %offset = add nsw i64 %rowMul, %v64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %offset
  %w = load i32, i32* %edge.ptr, align 4
  %edgeZero = icmp eq i32 %w, 0
  br i1 %edgeZero, label %relax.inc, label %chk.vis

chk.vis:
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %visv = load i32, i32* %vis.v.ptr, align 4
  %visv.zero = icmp eq i32 %visv, 0
  br i1 %visv.zero, label %chk.inf, label %relax.inc

chk.inf:
  %dist.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %min64
  %distu = load i32, i32* %dist.min.ptr, align 4
  %isinf = icmp eq i32 %distu, 2147483647
  br i1 %isinf, label %relax.inc, label %chk.better

chk.better:
  %sum = add nsw i32 %distu, %w
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %distv = load i32, i32* %dist.v.ptr, align 4
  %better = icmp sgt i32 %distv, %sum
  br i1 %better, label %update, label %relax.inc

update:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next = add nsw i32 %v, 1
  br label %relax.loop

outer.inc:
  %k.next = add nsw i32 %k, 1
  br label %outer.loop

outer.exit:
  br label %print.loop

print.loop:
  %p = phi i32 [ 0, %outer.exit ], [ %p.next, %print.inc ]
  %p.cmp = icmp slt i32 %p, %n
  br i1 %p.cmp, label %print.body, label %ret

print.body:
  %p64 = sext i32 %p to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p64
  %distp = load i32, i32* %dist.p.ptr, align 4
  %isInfP = icmp eq i32 %distp, 2147483647
  br i1 %isInfP, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %p)
  br label %print.inc

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %p, i32 %distp)
  br label %print.inc

print.inc:
  %p.next = add nsw i32 %p, 1
  br label %print.loop

ret:
  ret void
}