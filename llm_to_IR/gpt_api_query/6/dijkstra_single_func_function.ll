; ModuleID = 'dijkstra.ll'
source_filename = "dijkstra"

declare i32 @printf(i8*, ...)

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %u = alloca i32, align 4
  %min = alloca i32, align 4
  %iter = alloca i32, align 4
  %p = alloca i32, align 4

  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp sge i32 %i.val, %n
  br i1 %cmp.i, label %init.done, label %init.body

init.body:
  %i.idx64 = sext i32 %i.val to i64
  %dist.elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.idx64
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  %vis.elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i.idx64
  store i32 0, i32* %vis.elem.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop

init.done:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  store i32 0, i32* %iter, align 4
  br label %outer.cond

outer.cond:
  %iter.val = load i32, i32* %iter, align 4
  %n.minus1 = add nsw i32 %n, -1
  %cmp.iter = icmp sge i32 %iter.val, %n.minus1
  br i1 %cmp.iter, label %print.start, label %outer.body

outer.body:
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %j, align 4
  br label %findmin.loop

findmin.loop:
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp sge i32 %j.val, %n
  br i1 %cmp.j, label %findmin.done, label %findmin.body

findmin.body:
  %j.idx64 = sext i32 %j.val to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %j.idx64
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %vis.zero = icmp eq i32 %vis.j, 0
  br i1 %vis.zero, label %check.min, label %findmin.next

check.min:
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j.idx64
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %min.cur = load i32, i32* %min, align 4
  %lt = icmp slt i32 %dist.j, %min.cur
  br i1 %lt, label %update.min, label %findmin.next

update.min:
  %dist.j2 = load i32, i32* %dist.j.ptr, align 4
  store i32 %dist.j2, i32* %min, align 4
  store i32 %j.val, i32* %u, align 4
  br label %findmin.next

findmin.next:
  %j.inc = add nsw i32 %j.val, 1
  store i32 %j.inc, i32* %j, align 4
  br label %findmin.loop

findmin.done:
  %u.val = load i32, i32* %u, align 4
  %u.is.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.is.neg1, label %print.start, label %relax.start

relax.start:
  %u.idx64 = sext i32 %u.val to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u.idx64
  store i32 1, i32* %vis.u.ptr, align 4
  store i32 0, i32* %k, align 4
  br label %relax.loop

relax.loop:
  %k.val = load i32, i32* %k, align 4
  %cmp.k = icmp sge i32 %k.val, %n
  br i1 %cmp.k, label %outer.inc, label %relax.body

relax.body:
  %k.idx64 = sext i32 %k.val to i64
  %u.idx64.2 = sext i32 %u.val to i64
  %row.off = mul nsw i64 %u.idx64.2, 100
  %elem.idx = add nsw i64 %row.off, %k.idx64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %elem.idx
  %w = load i32, i32* %edge.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %relax.next, label %relax.check.vis

relax.check.vis:
  %vis.k.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %k.idx64
  %vis.k = load i32, i32* %vis.k.ptr, align 4
  %k.unvisited = icmp eq i32 %vis.k, 0
  br i1 %k.unvisited, label %relax.check.du, label %relax.next

relax.check.du:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.idx64.2
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.is.inf, label %relax.next, label %relax.check.better

relax.check.better:
  %sum = add nsw i32 %dist.u, %w
  %dist.k.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %k.idx64
  %dist.k = load i32, i32* %dist.k.ptr, align 4
  %better = icmp slt i32 %sum, %dist.k
  br i1 %better, label %relax.update, label %relax.next

relax.update:
  store i32 %sum, i32* %dist.k.ptr, align 4
  br label %relax.next

relax.next:
  %k.inc = add nsw i32 %k.val, 1
  store i32 %k.inc, i32* %k, align 4
  br label %relax.loop

outer.inc:
  %iter.next = add nsw i32 %iter.val, 1
  store i32 %iter.next, i32* %iter, align 4
  br label %outer.cond

print.start:
  store i32 0, i32* %p, align 4
  br label %print.loop

print.loop:
  %p.val = load i32, i32* %p, align 4
  %cmp.p = icmp sge i32 %p.val, %n
  br i1 %cmp.p, label %done, label %print.body

print.body:
  %p.idx64 = sext i32 %p.val to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p.idx64
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %is.inf = icmp eq i32 %dist.p, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %p.val)
  br label %print.next

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %p.val, i32 %dist.p)
  br label %print.next

print.next:
  %p.inc = add nsw i32 %p.val, 1
  store i32 %p.inc, i32* %p, align 4
  br label %print.loop

done:
  ret void
}