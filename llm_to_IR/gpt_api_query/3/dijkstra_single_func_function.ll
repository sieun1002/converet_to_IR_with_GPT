; ModuleID = 'dijkstra.ll'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [14 x i8] c"dist[%d] = %d\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @dijkstra(i32* %graph, i32 %n, i32 %src) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %iter = alloca i32, align 4
  %u = alloca i32, align 4
  %min = alloca i32, align 4
  %v = alloca i32, align 4

  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:                                        ; for (i = 0; i < n; ++i)
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %n
  br i1 %cmp, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i.val to i64
  %distptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %distptr, align 4
  %visptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %visptr, align 4
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist_src_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist_src_ptr, align 4

  store i32 0, i32* %iter, align 4
  br label %outer.loop

outer.loop:                                       ; for (iter = 0; iter < n-1; ++iter)
  %iter.val = load i32, i32* %iter, align 4
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %iter.val, %nminus1
  br i1 %cmp.outer, label %outer.body, label %final.print.init

outer.body:
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %v, align 4
  br label %select.loop

select.loop:                                      ; select u: unvisited with minimum dist
  %v.sel = load i32, i32* %v, align 4
  %cmp.vn = icmp slt i32 %v.sel, %n
  br i1 %cmp.vn, label %select.body, label %select.end

select.body:
  %v64 = sext i32 %v.sel to i64
  %visited_v_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %visited_v = load i32, i32* %visited_v_ptr, align 4
  %notVisited = icmp eq i32 %visited_v, 0
  br i1 %notVisited, label %check.dist, label %select.inc

check.dist:
  %dist_v_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %min.cur = load i32, i32* %min, align 4
  %lt = icmp slt i32 %dist_v, %min.cur
  br i1 %lt, label %update.min, label %select.inc

update.min:
  store i32 %dist_v, i32* %min, align 4
  store i32 %v.sel, i32* %u, align 4
  br label %select.inc

select.inc:
  %v.next = add nsw i32 %v.sel, 1
  store i32 %v.next, i32* %v, align 4
  br label %select.loop

select.end:
  %u.val = load i32, i32* %u, align 4
  %u.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.neg1, label %outer.break, label %mark.u

mark.u:
  %u64 = sext i32 %u.val to i64
  %visited_u_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %visited_u_ptr, align 4

  store i32 0, i32* %v, align 4
  br label %relax.loop

relax.loop:                                       ; for each v: relax edges from u
  %v.rel = load i32, i32* %v, align 4
  %cmp.rel = icmp slt i32 %v.rel, %n
  br i1 %cmp.rel, label %relax.body, label %outer.inc

relax.body:
  %mul = mul nsw i32 %u.val, 100
  %idx = add nsw i32 %mul, %v.rel
  %idx64 = sext i32 %idx to i64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx64
  %w = load i32, i32* %edge.ptr, align 4
  %is_zero = icmp eq i32 %w, 0
  br i1 %is_zero, label %relax.inc, label %chk.visited2

chk.visited2:
  %v64.rel = sext i32 %v.rel to i64
  %visited_v2_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64.rel
  %visited_v2 = load i32, i32* %visited_v2_ptr, align 4
  %notVisited2 = icmp eq i32 %visited_v2, 0
  br i1 %notVisited2, label %chk.distu, label %relax.inc

chk.distu:
  %dist_u_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %is_inf_u = icmp eq i32 %dist_u, 2147483647
  br i1 %is_inf_u, label %relax.inc, label %try.relax

try.relax:
  %dist_v2_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64.rel
  %dist_v2 = load i32, i32* %dist_v2_ptr, align 4
  %sum = add nsw i32 %dist_u, %w
  %gt = icmp sgt i32 %dist_v2, %sum
  br i1 %gt, label %do.relax, label %relax.inc

do.relax:
  store i32 %sum, i32* %dist_v2_ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next.rel = add nsw i32 %v.rel, 1
  store i32 %v.next.rel, i32* %v, align 4
  br label %relax.loop

outer.inc:
  %iter.next = add nsw i32 %iter.val, 1
  store i32 %iter.next, i32* %iter, align 4
  br label %outer.loop

outer.break:
  br label %final.print.init

final.print.init:
  store i32 0, i32* %i, align 4
  br label %print.loop

print.loop:
  %i.pr = load i32, i32* %i, align 4
  %cmp.pr = icmp slt i32 %i.pr, %n
  br i1 %cmp.pr, label %print.body, label %ret

print.body:
  %i64.pr = sext i32 %i.pr to i64
  %dist_i_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64.pr
  %dist_i = load i32, i32* %dist_i_ptr, align 4
  %is_inf_i = icmp eq i32 %dist_i, 2147483647
  br i1 %is_inf_i, label %print.inf, label %print.val

print.inf:
  %fmt1.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i32 %i.pr)
  br label %print.inc

print.val:
  %fmt2.ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %i.pr, i32 %dist_i)
  br label %print.inc

print.inc:
  %i.next.pr = add nsw i32 %i.pr, 1
  store i32 %i.next.pr, i32* %i, align 4
  br label %print.loop

ret:
  ret void
}