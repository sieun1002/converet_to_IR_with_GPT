; ModuleID = 'dijkstra'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %graph.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %src.addr = alloca i32, align 4
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  store i32* %graph, i32** %graph.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 %src, i32* %src.addr, align 4
  br label %init.loop

init.loop:
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %n.ld0 = load i32, i32* %n.addr, align 4
  %cmp.init = icmp slt i32 %i.ph, %n.ld0
  br i1 %cmp.init, label %init.body, label %init.done

init.body:
  %i.ext = sext i32 %i.ph to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.ext
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.ext
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i.ph, 1
  br label %init.loop

init.done:
  %src.ld = load i32, i32* %src.addr, align 4
  %src.ext = sext i32 %src.ld to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.cond

outer.cond:
  %count.ph = phi i32 [ 0, %init.done ], [ %count.next, %outer.inc ]
  %n.ld1 = load i32, i32* %n.addr, align 4
  %n.minus1 = add nsw i32 %n.ld1, -1
  %cmp.outer = icmp sge i32 %count.ph, %n.minus1
  br i1 %cmp.outer, label %print.start, label %outer.body.init

outer.body.init:
  br label %select.loop

select.loop:
  %vsel.ph = phi i32 [ 0, %outer.body.init ], [ %vsel.next, %select.inc ]
  %bestIdx.ph = phi i32 [ -1, %outer.body.init ], [ %bestIdx.next, %select.inc ]
  %bestDist.ph = phi i32 [ 2147483647, %outer.body.init ], [ %bestDist.next, %select.inc ]
  %n.ld2 = load i32, i32* %n.addr, align 4
  %cmp.vsel = icmp slt i32 %vsel.ph, %n.ld2
  br i1 %cmp.vsel, label %select.body, label %select.done

select.body:
  %vsel.ext = sext i32 %vsel.ph to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %vsel.ext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.v, 0
  br i1 %is.unvisited, label %select.body.cmp, label %select.body.visfalse

select.body.cmp:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %vsel.ext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmp.dist = icmp slt i32 %dist.v, %bestDist.ph
  br i1 %cmp.dist, label %select.body.update, label %select.body.noupdate

select.body.update:
  br label %select.inc

select.body.noupdate:
  br label %select.inc

select.body.visfalse:
  br label %select.inc

select.inc:
  %bestDist.next = phi i32 [ %bestDist.ph, %select.body.visfalse ], [ %bestDist.ph, %select.body.noupdate ], [ %dist.v, %select.body.update ]
  %bestIdx.next = phi i32 [ %bestIdx.ph, %select.body.visfalse ], [ %bestIdx.ph, %select.body.noupdate ], [ %vsel.ph, %select.body.update ]
  %vsel.next = add nsw i32 %vsel.ph, 1
  br label %select.loop

select.done:
  %u.sel = phi i32 [ %bestIdx.ph, %select.loop ]
  %minDist.sel = phi i32 [ %bestDist.ph, %select.loop ]
  %no.u = icmp eq i32 %u.sel, -1
  br i1 %no.u, label %print.start, label %after.select

after.select:
  %u.ext = sext i32 %u.sel to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.ext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:
  %v.ph = phi i32 [ 0, %after.select ], [ %v.next, %relax.inc ]
  %n.ld3 = load i32, i32* %n.addr, align 4
  %cmp.v = icmp slt i32 %v.ph, %n.ld3
  br i1 %cmp.v, label %relax.body, label %outer.inc

relax.body:
  %graph.ld = load i32*, i32** %graph.addr, align 8
  %u.ext2 = sext i32 %u.sel to i64
  %v.ext2 = sext i32 %v.ph to i64
  %row.mul = mul nsw i64 %u.ext2, 100
  %idx.flat = add nsw i64 %row.mul, %v.ext2
  %edge.ptr = getelementptr inbounds i32, i32* %graph.ld, i64 %idx.flat
  %w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %w, 0
  br i1 %edge.zero, label %relax.inc, label %relax.check.vis

relax.check.vis:
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.ext2
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v.unvisited = icmp eq i32 %vis.v2, 0
  br i1 %v.unvisited, label %relax.check.distu, label %relax.inc

relax.check.distu:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.ext2
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.isinf, label %relax.inc, label %relax.compare

relax.compare:
  %sum = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.ext2
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %better = icmp sgt i32 %dist.v2, %sum
  br i1 %better, label %relax.update, label %relax.inc

relax.update:
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next = add nsw i32 %v.ph, 1
  br label %relax.loop

outer.inc:
  %count.next = add nsw i32 %count.ph, 1
  br label %outer.cond

print.start:
  br label %print.loop

print.loop:
  %pi.ph = phi i32 [ 0, %print.start ], [ %pi.next, %print.inc ]
  %n.ld4 = load i32, i32* %n.addr, align 4
  %cmp.print = icmp slt i32 %pi.ph, %n.ld4
  br i1 %cmp.print, label %print.body, label %ret

print.body:
  %pi.ext = sext i32 %pi.ph to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi.ext
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %fmt.inf.i8 = bitcast i8* %fmt.inf.ptr to i8*
  %pi.ext.to64 = sext i32 %pi.ph to i64
  %pi.to32.inf = trunc i64 %pi.ext.to64 to i32
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %pi.to32.inf)
  br label %print.inc

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %fmt.val.i8 = bitcast i8* %fmt.val.ptr to i8*
  %pi.ext2 = sext i32 %pi.ph to i64
  %pi.to32.val = trunc i64 %pi.ext2 to i32
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %pi.to32.val, i32 %dist.pi)
  br label %print.inc

print.inc:
  %pi.next = add nsw i32 %pi.ph, 1
  br label %print.loop

ret:
  ret void
}