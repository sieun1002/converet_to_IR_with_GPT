; ModuleID = 'dijkstra_single_func.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %cnt = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %last = alloca i32, align 4
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %call.scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %var8, i32* %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call.memset = call i8* @memset(i8* %s.i8, i32 0, i64 40000)
  store i32 0, i32* %cnt, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %cnt, align 4
  %nedges = load i32, i32* %varC, align 4
  %cmp = icmp slt i32 %i.cur, %nedges
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt3.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %call.scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %a, i32* %b, i32* %w)
  %w.val = load i32, i32* %w, align 4
  %a.val = load i32, i32* %a, align 4
  %b.val = load i32, i32* %b, align 4
  %a.idx = sext i32 %a.val to i64
  %b.idx = sext i32 %b.val to i64
  %row.a.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx
  %elem.ab.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.a.ptr, i64 0, i64 %b.idx
  store i32 %w.val, i32* %elem.ab.ptr, align 4
  %row.b.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx
  %elem.ba.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.b.ptr, i64 0, i64 %a.idx
  store i32 %w.val, i32* %elem.ba.ptr, align 4
  %i.next0 = load i32, i32* %cnt, align 4
  %i.inc = add nsw i32 %i.next0, 1
  store i32 %i.inc, i32* %cnt, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %call.scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %last)
  %row0.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %s.flat = getelementptr inbounds [100 x i32], [100 x i32]* %row0.ptr, i64 0, i64 0
  %n.param = load i32, i32* %var8, align 4
  %src.param = load i32, i32* %last, align 4
  %call.dijkstra = call i32 bitcast (void ([100 x i32]*, i32, i32)* @dijkstra to i32 (i32*, i32, i32)*)(i32* %s.flat, i32 %n.param, i32 %src.param)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8* nocapture, i32, i64)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.latch, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp sge i32 %i.init, %n
  br i1 %init.cmp, label %init.done, label %init.body

init.body:                                        ; preds = %init.loop
  %i.sext = sext i32 %i.init to i64
  %dist.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.el.ptr, align 4
  %vis.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.el.ptr, align 4
  br label %init.latch

init.latch:                                       ; preds = %init.body
  %i.next = add i32 %i.init, 1
  br label %init.loop

init.done:                                        ; preds = %init.loop
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.afterUpdate, %init.done
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.afterUpdate ]
  %n.minus1 = add i32 %n, -1
  %outer.cond = icmp sge i32 %count, %n.minus1
  br i1 %outer.cond, label %print.start, label %select.init

select.init:                                      ; preds = %outer.loop
  br label %select.loop

select.loop:                                      ; preds = %select.latch, %select.init
  %v.sel = phi i32 [ 0, %select.init ], [ %v.next, %select.latch ]
  %min.cur = phi i32 [ 2147483647, %select.init ], [ %min.next, %select.latch ]
  %u.cur = phi i32 [ -1, %select.init ], [ %u.next, %select.latch ]
  %v.end = icmp sge i32 %v.sel, %n
  br i1 %v.end, label %select.done, label %select.body

select.body:                                      ; preds = %select.loop
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

select.latch:                                     ; preds = %select.body
  %v.next = add i32 %v.sel, 1
  br label %select.loop

select.done:                                      ; preds = %select.loop
  %u.is.neg1 = icmp eq i32 %u.cur, -1
  br i1 %u.is.neg1, label %print.start, label %visit.u

visit.u:                                          ; preds = %select.done
  %u.sext = sext i32 %u.cur to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.sext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.latch, %visit.u
  %v.rel = phi i32 [ 0, %visit.u ], [ %v.rel.next, %relax.latch ]
  %rel.end = icmp sge i32 %v.rel, %n
  br i1 %rel.end, label %outer.afterUpdate, label %relax.body

relax.body:                                       ; preds = %relax.loop
  %v.rel.sext = sext i32 %v.rel to i64
  %u.rel.sext = sext i32 %u.cur to i64
  %w.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u.rel.sext, i64 %v.rel.sext
  %w = load i32, i32* %w.ptr, align 4
  %w.zero = icmp eq i32 %w, 0
  br i1 %w.zero, label %relax.latch, label %check.visited.v

check.visited.v:                                  ; preds = %relax.body
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.rel.sext
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %vis.v2.zero = icmp eq i32 %vis.v2, 0
  br i1 %vis.v2.zero, label %check.u.inf, label %relax.latch

check.u.inf:                                      ; preds = %check.visited.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.rel.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax.latch, label %try.relax

try.relax:                                        ; preds = %check.u.inf
  %sum = add i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.rel.sext
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %gt.cur = icmp sgt i32 %dist.v2, %sum
  br i1 %gt.cur, label %do.update, label %relax.latch

do.update:                                        ; preds = %try.relax
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:                                      ; preds = %do.update, %try.relax, %check.u.inf, %check.visited.v, %relax.body
  %v.rel.next = add i32 %v.rel, 1
  br label %relax.loop

outer.afterUpdate:                                ; preds = %relax.loop
  %count.next = add i32 %count, 1
  br label %outer.loop

print.start:                                      ; preds = %select.done, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %print.start
  %i.print = phi i32 [ 0, %print.start ], [ %i.print.next, %print.latch ]
  %print.end = icmp sge i32 %i.print, %n
  br i1 %print.end, label %exit, label %print.body

print.body:                                       ; preds = %print.loop
  %i.print.sext = sext i32 %i.print to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.print.sext
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.print)
  br label %print.latch

print.val:                                        ; preds = %print.body
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %i.print, i32 %dist.i)
  br label %print.latch

print.latch:                                      ; preds = %print.val, %print.inf
  %i.print.next = add i32 %i.print, 1
  br label %print.loop

exit:                                             ; preds = %print.loop
  ret void
}

declare i32 @printf(i8* nocapture readonly, ...)
