; ModuleID = 'dijkstra.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_num = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %graph.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %src.addr = alloca i32, align 4
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %u = alloca i32, align 4
  %min = alloca i32, align 4
  %v = alloca i32, align 4
  store i32* %graph, i32** %graph.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 %src, i32* %src.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.init

for.init:
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %cmp.init = icmp slt i32 %i.val, %n.val
  br i1 %cmp.init, label %for.body, label %for.end

for.body:
  %idx64 = sext i32 %i.val to i64
  %dist.ptr.i = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %idx64
  store i32 2147483647, i32* %dist.ptr.i, align 4
  %vis.ptr.i = getelementptr [100 x i32], [100 x i32]* %visited, i64 0, i64 %idx64
  store i32 0, i32* %vis.ptr.i, align 4
  %inc.i = add nsw i32 %i.val, 1
  store i32 %inc.i, i32* %i, align 4
  br label %for.init

for.end:
  %src.val = load i32, i32* %src.addr, align 4
  %src64 = sext i32 %src.val to i64
  %dist.src.ptr = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  store i32 0, i32* %count, align 4
  br label %outer.cond

outer.cond:
  %count.val = load i32, i32* %count, align 4
  %n.val2 = load i32, i32* %n.addr, align 4
  %nminus1 = add nsw i32 %n.val2, -1
  %cmp.outer = icmp slt i32 %count.val, %nminus1
  br i1 %cmp.outer, label %outer.body.pre, label %after.outer

outer.body.pre:
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %v, align 4
  br label %select.cond

select.cond:
  %v.sel = load i32, i32* %v, align 4
  %n.val3 = load i32, i32* %n.addr, align 4
  %cmp.sel = icmp slt i32 %v.sel, %n.val3
  br i1 %cmp.sel, label %select.body, label %select.end

select.body:
  %v.sel64 = sext i32 %v.sel to i64
  %vis.ptr.sel = getelementptr [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sel64
  %vis.val.sel = load i32, i32* %vis.ptr.sel, align 4
  %isZero = icmp eq i32 %vis.val.sel, 0
  br i1 %isZero, label %check.min, label %select.inc

check.min:
  %dist.ptr.sel = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sel64
  %dist.val.sel = load i32, i32* %dist.ptr.sel, align 4
  %min.cur = load i32, i32* %min, align 4
  %cmp.min = icmp slt i32 %dist.val.sel, %min.cur
  br i1 %cmp.min, label %update.min, label %select.inc

update.min:
  store i32 %dist.val.sel, i32* %min, align 4
  store i32 %v.sel, i32* %u, align 4
  br label %select.inc

select.inc:
  %v.sel2 = load i32, i32* %v, align 4
  %v.inc = add nsw i32 %v.sel2, 1
  store i32 %v.inc, i32* %v, align 4
  br label %select.cond

select.end:
  %u.val = load i32, i32* %u, align 4
  %u.isneg1 = icmp eq i32 %u.val, -1
  br i1 %u.isneg1, label %after.outer, label %mark.visited

mark.visited:
  %u64 = sext i32 %u.val to i64
  %vis.ptr.u = getelementptr [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %vis.ptr.u, align 4
  store i32 0, i32* %v, align 4
  br label %relax.cond

relax.cond:
  %v.rel = load i32, i32* %v, align 4
  %n.val4 = load i32, i32* %n.addr, align 4
  %cmp.rel = icmp slt i32 %v.rel, %n.val4
  br i1 %cmp.rel, label %relax.body, label %relax.end

relax.body:
  %u64.rel = sext i32 %u.val to i64
  %mul100 = mul nsw i64 %u64.rel, 100
  %v64.rel = sext i32 %v.rel to i64
  %rowcol = add nsw i64 %mul100, %v64.rel
  %g.ptr = load i32*, i32** %graph.addr, align 8
  %edge.ptr = getelementptr i32, i32* %g.ptr, i64 %rowcol
  %edge.val = load i32, i32* %edge.ptr, align 4
  %edge.iszero = icmp eq i32 %edge.val, 0
  br i1 %edge.iszero, label %relax.inc, label %check.visited

check.visited:
  %vis.ptr.v = getelementptr [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64.rel
  %vis.val.v = load i32, i32* %vis.ptr.v, align 4
  %v.notvisited = icmp eq i32 %vis.val.v, 0
  br i1 %v.notvisited, label %check.infdist, label %relax.inc

check.infdist:
  %dist.u.ptr = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64.rel
  %dist.u.val = load i32, i32* %dist.u.ptr, align 4
  %u.isinf = icmp eq i32 %dist.u.val, 2147483647
  br i1 %u.isinf, label %relax.inc, label %calc.alt

calc.alt:
  %dist.v.ptr = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64.rel
  %dist.v.cur = load i32, i32* %dist.v.ptr, align 4
  %alt.tmp = add nsw i32 %dist.u.val, %edge.val
  %cmp.alt = icmp sgt i32 %dist.v.cur, %alt.tmp
  br i1 %cmp.alt, label %update.dist, label %relax.inc

update.dist:
  store i32 %alt.tmp, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.rel2 = load i32, i32* %v, align 4
  %v.rel.inc = add nsw i32 %v.rel2, 1
  store i32 %v.rel.inc, i32* %v, align 4
  br label %relax.cond

relax.end:
  %count.cur = load i32, i32* %count, align 4
  %count.inc = add nsw i32 %count.cur, 1
  store i32 %count.inc, i32* %count, align 4
  br label %outer.cond

after.outer:
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:
  %i.pr = load i32, i32* %i, align 4
  %n.val5 = load i32, i32* %n.addr, align 4
  %cmp.pr = icmp slt i32 %i.pr, %n.val5
  br i1 %cmp.pr, label %print.body, label %print.end

print.body:
  %i64.pr = sext i32 %i.pr to i64
  %dist.ptr.pr = getelementptr [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64.pr
  %dist.val.pr = load i32, i32* %dist.ptr.pr, align 4
  %is.inf = icmp eq i32 %dist.val.pr, 2147483647
  br i1 %is.inf, label %print.inf, label %print.num

print.inf:
  %fmt.inf.ptr = getelementptr [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %res.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.pr)
  br label %print.inc

print.num:
  %fmt.num.ptr = getelementptr [15 x i8], [15 x i8]* @.str_num, i64 0, i64 0
  %res.num = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i32 %i.pr, i32 %dist.val.pr)
  br label %print.inc

print.inc:
  %i.pr2 = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.pr2, 1
  store i32 %i.next, i32* %i, align 4
  br label %print.cond

print.end:
  ret void
}