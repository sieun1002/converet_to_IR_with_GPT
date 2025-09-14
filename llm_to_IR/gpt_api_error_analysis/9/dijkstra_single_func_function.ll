; ModuleID = 'dijkstra.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:                                          ; preds = %init.body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp.init = icmp slt i32 %i.val, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                          ; preds = %init.loop
  %i64_1 = sext i32 %i.val to i64
  %dist.ptr.i = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64_1
  store i32 2147483647, i32* %dist.ptr.i, align 4
  %vis.ptr.i = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64_1
  store i32 0, i32* %vis.ptr.i, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop

init.end:                                           ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %outer.cond

outer.cond:                                         ; preds = %relax.end, %init.end
  %k.val = load i32, i32* %k, align 4
  %n.minus1 = add nsw i32 %n, -1
  %cmp.k = icmp slt i32 %k.val, %n.minus1
  br i1 %cmp.k, label %outer.body, label %after.outer

outer.body:                                         ; preds = %outer.cond
  %u = alloca i32, align 4
  %minv = alloca i32, align 4
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %minv, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %find.cond

find.cond:                                          ; preds = %find.inc, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp slt i32 %j.val, %n
  br i1 %cmp.j, label %find.body, label %find.end

find.body:                                          ; preds = %find.cond
  %j64 = sext i32 %j.val to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %j64
  %visj = load i32, i32* %vis.j.ptr, align 4
  %is.unvis = icmp eq i32 %visj, 0
  br i1 %is.unvis, label %check.min, label %find.inc

check.min:                                          ; preds = %find.body
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %distj = load i32, i32* %dist.j.ptr, align 4
  %min.cur = load i32, i32* %minv, align 4
  %lt = icmp slt i32 %distj, %min.cur
  br i1 %lt, label %update.min, label %find.inc

update.min:                                         ; preds = %check.min
  store i32 %distj, i32* %minv, align 4
  store i32 %j.val, i32* %u, align 4
  br label %find.inc

find.inc:                                           ; preds = %update.min, %check.min, %find.body
  %j.next = add nsw i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %find.cond

find.end:                                           ; preds = %find.cond
  %u.val = load i32, i32* %u, align 4
  %is.neg1 = icmp eq i32 %u.val, -1
  br i1 %is.neg1, label %after.outer, label %mark.vis

mark.vis:                                           ; preds = %find.end
  %u64 = sext i32 %u.val to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  %v = alloca i32, align 4
  store i32 0, i32* %v, align 4
  br label %relax.cond

relax.cond:                                         ; preds = %relax.inc, %mark.vis
  %v.val = load i32, i32* %v, align 4
  %cmp.v = icmp slt i32 %v.val, %n
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:                                         ; preds = %relax.cond
  %v64 = sext i32 %v.val to i64
  %rowmul = mul nsw i32 %u.val, 100
  %idx = add nsw i32 %rowmul, %v.val
  %idx64 = sext i32 %idx to i64
  %gptr = getelementptr inbounds i32, i32* %graph, i64 %idx64
  %gval = load i32, i32* %gptr, align 4
  %nonzero = icmp ne i32 %gval, 0
  br i1 %nonzero, label %check.vis.v, label %relax.inc

check.vis.v:                                        ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %visv = load i32, i32* %vis.v.ptr, align 4
  %v.unvis = icmp eq i32 %visv, 0
  br i1 %v.unvis, label %check.infu, label %relax.inc

check.infu:                                         ; preds = %check.vis.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %distu = load i32, i32* %dist.u.ptr, align 4
  %is.inf = icmp eq i32 %distu, 2147483647
  br i1 %is.inf, label %relax.inc, label %try.update

try.update:                                         ; preds = %check.infu
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %distv = load i32, i32* %dist.v.ptr, align 4
  %sum = add nsw i32 %distu, %gval
  %gt = icmp sgt i32 %distv, %sum
  br i1 %gt, label %do.update, label %relax.inc

do.update:                                          ; preds = %try.update
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                          ; preds = %do.update, %try.update, %check.infu, %check.vis.v, %relax.body
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %relax.cond

relax.end:                                          ; preds = %relax.cond
  %k.next = add nsw i32 %k.val, 1
  store i32 %k.next, i32* %k, align 4
  br label %outer.cond

after.outer:                                        ; preds = %find.end, %outer.cond
  %p = alloca i32, align 4
  store i32 0, i32* %p, align 4
  br label %print.cond

print.cond:                                         ; preds = %print.inc, %after.outer
  %p.val = load i32, i32* %p, align 4
  %cmp.p = icmp slt i32 %p.val, %n
  br i1 %cmp.p, label %print.body, label %ret

print.body:                                         ; preds = %print.cond
  %p64 = sext i32 %p.val to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p64
  %distp = load i32, i32* %dist.p.ptr, align 4
  %is.inf.p = icmp eq i32 %distp, 2147483647
  br i1 %is.inf.p, label %print.inf, label %print.val

print.inf:                                          ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %p.val)
  br label %print.inc

print.val:                                          ; preds = %print.body
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %p.val, i32 %distp)
  br label %print.inc

print.inc:                                          ; preds = %print.val, %print.inf
  %p.next = add nsw i32 %p.val, 1
  store i32 %p.next, i32* %p, align 4
  br label %print.cond

ret:                                                ; preds = %print.cond
  ret void
}