; LLVM 14 IR for function: dijkstra

source_filename = "dijkstra.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [16 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %visited = alloca [100 x i32], align 16
  %dist = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %u = alloca i32, align 4
  %minDist = alloca i32, align 4
  %v = alloca i32, align 4

  store i32 0, i32* %i, align 4
  br label %init.cond

init.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp.init = icmp slt i32 %i.val, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i.val to i64
  %dist.elem = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.elem, align 4
  %vis.elem = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.elem, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.cond

init.end:
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src, align 4

  store i32 0, i32* %count, align 4
  br label %outer.cond

outer.cond:
  %count.val = load i32, i32* %count, align 4
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %count.val, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %print.start

outer.body:
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %minDist, align 4
  store i32 0, i32* %i, align 4
  br label %pick.cond

pick.cond:
  %i2 = load i32, i32* %i, align 4
  %cmp.pick = icmp slt i32 %i2, %n
  br i1 %cmp.pick, label %pick.body, label %pick.end

pick.body:
  %i2_64 = sext i32 %i2 to i64
  %vis.p = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i2_64
  %vis.val = load i32, i32* %vis.p, align 4
  %not.vis = icmp eq i32 %vis.val, 0
  br i1 %not.vis, label %check.min, label %pick.inc

check.min:
  %dist.p = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i2_64
  %d.val = load i32, i32* %dist.p, align 4
  %min.cur = load i32, i32* %minDist, align 4
  %lt.min = icmp slt i32 %d.val, %min.cur
  br i1 %lt.min, label %update.min, label %pick.inc

update.min:
  store i32 %d.val, i32* %minDist, align 4
  store i32 %i2, i32* %u, align 4
  br label %pick.inc

pick.inc:
  %i2.next = add nsw i32 %i2, 1
  store i32 %i2.next, i32* %i, align 4
  br label %pick.cond

pick.end:
  %u.val = load i32, i32* %u, align 4
  %u.is.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.is.neg1, label %print.start, label %after.pick

after.pick:
  %u64 = sext i32 %u.val to i64
  %u64x100 = mul nsw i64 %u64, 100
  %row.ptr = getelementptr inbounds i32, i32* %graph, i64 %u64x100
  %u.vis.p = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %u.vis.p, align 4

  store i32 0, i32* %v, align 4
  br label %relax.cond

relax.cond:
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:
  %v64 = sext i32 %v.val to i64
  %cell.p = getelementptr inbounds i32, i32* %row.ptr, i64 %v64
  %w = load i32, i32* %cell.p, align 4
  %w.nz = icmp ne i32 %w, 0
  br i1 %w.nz, label %chk.visV, label %relax.inc

chk.visV:
  %visV.p = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %visV = load i32, i32* %visV.p, align 4
  %v.not.vis = icmp eq i32 %visV, 0
  br i1 %v.not.vis, label %chk.duinf, label %relax.inc

chk.duinf:
  %du.p = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %du = load i32, i32* %du.p, align 4
  %du.is.inf = icmp eq i32 %du, 2147483647
  br i1 %du.is.inf, label %relax.inc, label %chk.relax

chk.relax:
  %dv.p = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dv = load i32, i32* %dv.p, align 4
  %sum = add i32 %du, %w
  %need.update = icmp sgt i32 %dv, %sum
  br i1 %need.update, label %do.update, label %relax.inc

do.update:
  store i32 %sum, i32* %dv.p, align 4
  br label %relax.inc

relax.inc:
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %relax.cond

relax.end:
  %count.cur = load i32, i32* %count, align 4
  %count.inc = add nsw i32 %count.cur, 1
  store i32 %count.inc, i32* %count, align 4
  br label %outer.cond

print.start:
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:
  %ip = load i32, i32* %i, align 4
  %cmp.print = icmp slt i32 %ip, %n
  br i1 %cmp.print, label %print.body, label %exit

print.body:
  %ip64 = sext i32 %ip to i64
  %dist.p.pr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %ip64
  %d.pr = load i32, i32* %dist.p.pr, align 4
  %is.inf = icmp eq i32 %d.pr, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %ip)
  br label %print.inc

print.val:
  %fmt2 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %ip, i32 %d.pr)
  br label %print.inc

print.inc:
  %ip.next = add nsw i32 %ip, 1
  store i32 %ip.next, i32* %i, align 4
  br label %print.cond

exit:
  ret void
}