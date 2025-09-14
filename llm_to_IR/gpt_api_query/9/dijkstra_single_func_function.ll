; ModuleID = 'dijkstra.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.num = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %spt  = alloca [100 x i32], align 16
  %i    = alloca i32, align 4
  %j    = alloca i32, align 4
  %count = alloca i32, align 4
  %u    = alloca i32, align 4
  %minv = alloca i32, align 4

  ; initialize dist[] = INT_MAX and spt[] = 0
  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:
  %i.val = load i32, i32* %i, align 4
  %init.cmp = icmp slt i32 %i.val, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i.val to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %spt.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %i64
  store i32 0, i32* %spt.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop

init.end:
  ; dist[src] = 0
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src, align 4

  ; for (count = 0; count < n-1; ++count)
  store i32 0, i32* %count, align 4
  br label %outer.cond

outer.cond:
  %count.val = load i32, i32* %count, align 4
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %count.val, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %print.init

outer.body:
  ; u = -1; min = INT_MAX
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %minv, align 4

  ; for (j = 0; j < n; ++j) find min dist not in spt
  store i32 0, i32* %j, align 4
  br label %minscan.cond

minscan.cond:
  %j.val = load i32, i32* %j, align 4
  %j.cmp = icmp slt i32 %j.val, %n
  br i1 %j.cmp, label %minscan.body, label %minscan.end

minscan.body:
  %j64 = sext i32 %j.val to i64
  %spt.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %j64
  %spt.j = load i32, i32* %spt.j.ptr, align 4
  %spt.j.is0 = icmp eq i32 %spt.j, 0
  br i1 %spt.j.is0, label %check.min, label %minscan.inc

check.min:
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %min.cur = load i32, i32* %minv, align 4
  %lt = icmp slt i32 %dist.j, %min.cur
  br i1 %lt, label %update.min, label %minscan.inc

update.min:
  store i32 %dist.j, i32* %minv, align 4
  store i32 %j.val, i32* %u, align 4
  br label %minscan.inc

minscan.inc:
  %j.next = add nsw i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %minscan.cond

minscan.end:
  ; if (u == -1) break
  %u.val = load i32, i32* %u, align 4
  %u.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.neg1, label %print.init, label %after.u.check

after.u.check:
  ; spt[u] = 1
  %u64 = sext i32 %u.val to i64
  %spt.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %u64
  store i32 1, i32* %spt.u.ptr, align 4

  ; relax edges from u
  store i32 0, i32* %j, align 4
  br label %relax.cond

relax.cond:
  %v.val = load i32, i32* %j, align 4
  %v.cmp = icmp slt i32 %v.val, %n
  br i1 %v.cmp, label %relax.body, label %outer.inc

relax.body:
  ; weight = graph[u*100 + v]
  %v64 = sext i32 %v.val to i64
  %row.off = mul nsw i64 %u64, 100
  %idx = add nsw i64 %row.off, %v64
  %w.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %w.ptr, align 4

  ; if w != 0 && spt[v]==0 && dist[u]!=INT_MAX && dist[v] > dist[u] + w
  %w.nz = icmp ne i32 %w, 0
  br i1 %w.nz, label %check.sptv, label %relax.inc

check.sptv:
  %spt.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %v64
  %spt.v = load i32, i32* %spt.v.ptr, align 4
  %spt.v.is0 = icmp eq i32 %spt.v, 0
  br i1 %spt.v.is0, label %check.distu.inf, label %relax.inc

check.distu.inf:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.inf, label %relax.inc, label %check.better

check.better:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %sum = add nsw i32 %dist.u, %w
  %better = icmp sgt i32 %dist.v, %sum
  br i1 %better, label %do.update, label %relax.inc

do.update:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %j, align 4
  br label %relax.cond

outer.inc:
  %count.next = add nsw i32 %count.val, 1
  store i32 %count.next, i32* %count, align 4
  br label %outer.cond

; printing
print.init:
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:
  %pi = load i32, i32* %i, align 4
  %p.cmp = icmp slt i32 %pi, %n
  br i1 %p.cmp, label %print.body, label %ret

print.body:
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.num

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %pi)
  br label %print.inc

print.num:
  %fmt.num.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.num, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i32 %pi, i32 %dist.pi)
  br label %print.inc

print.inc:
  %pi.next = add nsw i32 %pi, 1
  store i32 %pi.next, i32* %i, align 4
  br label %print.cond

ret:
  ret void
}