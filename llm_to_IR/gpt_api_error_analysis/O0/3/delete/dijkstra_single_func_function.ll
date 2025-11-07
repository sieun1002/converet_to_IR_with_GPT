; target: System V x86_64 Linux
target triple = "x86_64-unknown-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8* nocapture readonly, ...)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                           ; i from 0 to n-1
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp sge i32 %i.init, %n
  br i1 %init.cmp, label %init.done, label %init.body

init.body:
  %i.sext = sext i32 %i.init to i64
  %dist.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.el.ptr, align 4
  %vis.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.el.ptr, align 4
  br label %init.latch

init.latch:
  %i.next = add i32 %i.init, 1
  br label %init.loop

init.done:
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                          ; count from 0 to n-2
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.afterUpdate ]
  %n.minus1 = add i32 %n, -1
  %outer.cond = icmp sge i32 %count, %n.minus1
  br i1 %outer.cond, label %print.start, label %select.init

select.init:
  br label %select.loop

select.loop:                                         ; find u with min dist among unvisited
  %v.sel = phi i32 [ 0, %select.init ], [ %v.next, %select.latch ]
  %min.cur = phi i32 [ 2147483647, %select.init ], [ %min.next, %select.latch ]
  %u.cur = phi i32 [ -1, %select.init ], [ %u.next, %select.latch ]
  %v.end = icmp sge i32 %v.sel, %n
  br i1 %v.end, label %select.done, label %select.body

select.body:
  %v.sext = sext i32 %v.sel to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.zero = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  %cand.ok = and i1 %vis.zero, %lt.min
  %min.next = select i1 %cand.ok, i32 %dist.v, i32 %min.cur
  %u.next = select i1 %cand.ok, i32 %v.sel, i32 %u.cur
  br label %select.latch

select.latch:
  %v.next = add i32 %v.sel, 1
  br label %select.loop

select.done:
  %u.is.neg1 = icmp eq i32 %u.cur, -1
  br i1 %u.is.neg1, label %print.start, label %visit.u

visit.u:
  %u.sext = sext i32 %u.cur to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.sext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                          ; for v = 0..n-1
  %v.rel = phi i32 [ 0, %visit.u ], [ %v.rel.next, %relax.latch ]
  %rel.end = icmp sge i32 %v.rel, %n
  br i1 %rel.end, label %outer.afterUpdate, label %relax.body

relax.body:
  %v.rel.sext = sext i32 %v.rel to i64
  %u.rel.sext = sext i32 %u.cur to i64
  %w.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u.rel.sext, i64 %v.rel.sext
  %w = load i32, i32* %w.ptr, align 4
  %w.zero = icmp eq i32 %w, 0
  br i1 %w.zero, label %relax.latch, label %check.visited.v

check.visited.v:
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.rel.sext
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %vis.v2.zero = icmp eq i32 %vis.v2, 0
  br i1 %vis.v2.zero, label %check.u.inf, label %relax.latch

check.u.inf:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.rel.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax.latch, label %try.relax

try.relax:
  %sum = add i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.rel.sext
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %gt.cur = icmp sgt i32 %dist.v2, %sum
  br i1 %gt.cur, label %do.update, label %relax.latch

do.update:
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:
  %v.rel.next = add i32 %v.rel, 1
  br label %relax.loop

outer.afterUpdate:
  %count.next = add i32 %count, 1
  br label %outer.loop

print.start:
  br label %print.loop

print.loop:
  %i.print = phi i32 [ 0, %print.start ], [ %i.print.next, %print.latch ]
  %print.end = icmp sge i32 %i.print, %n
  br i1 %print.end, label %exit, label %print.body

print.body:
  %i.print.sext = sext i32 %i.print to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.print.sext
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.print)
  br label %print.latch

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %i.print, i32 %dist.i)
  br label %print.latch

print.latch:
  %i.print.next = add i32 %i.print, 1
  br label %print.loop

exit:
  ret void
}