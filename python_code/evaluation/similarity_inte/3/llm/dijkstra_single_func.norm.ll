; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/dijkstra_single_func.ll'
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
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %last = alloca i32, align 4
  %call.scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i32* nonnull %var8, i32* nonnull %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s.i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %cnt.0 = phi i32 [ 0, %entry ], [ %i.inc, %loop.body ]
  %nedges = load i32, i32* %varC, align 4
  %cmp = icmp slt i32 %cnt.0, %nedges
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call.scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* nonnull %a, i32* nonnull %b, i32* nonnull %w)
  %w.val = load i32, i32* %w, align 4
  %a.val = load i32, i32* %a, align 4
  %b.val = load i32, i32* %b, align 4
  %a.idx = sext i32 %a.val to i64
  %b.idx = sext i32 %b.val to i64
  %elem.ab.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx, i64 %b.idx
  store i32 %w.val, i32* %elem.ab.ptr, align 4
  %elem.ba.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx, i64 %a.idx
  store i32 %w.val, i32* %elem.ba.ptr, align 4
  %i.inc = add nuw nsw i32 %cnt.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call.scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* nonnull %last)
  %n.param = load i32, i32* %var8, align 4
  %src.param = load i32, i32* %last, align 4
  %0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  call void @dijkstra([100 x i32]* nonnull %0, i32 %n.param, i32 %src.param)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8* nocapture, i32, i64)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp.not = icmp slt i32 %i.init, %n
  br i1 %init.cmp.not, label %init.body, label %init.done

init.body:                                        ; preds = %init.loop
  %i.sext = sext i32 %i.init to i64
  %dist.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.el.ptr, align 4
  %vis.el.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.el.ptr, align 4
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
  %outer.cond.not = icmp slt i32 %count, %n.minus1
  br i1 %outer.cond.not, label %select.loop, label %print.start

select.loop:                                      ; preds = %outer.loop, %select.body
  %v.sel = phi i32 [ %v.next, %select.body ], [ 0, %outer.loop ]
  %min.cur = phi i32 [ %min.next, %select.body ], [ 2147483647, %outer.loop ]
  %u.cur = phi i32 [ %u.next, %select.body ], [ -1, %outer.loop ]
  %v.end.not = icmp slt i32 %v.sel, %n
  br i1 %v.end.not, label %select.body, label %select.done

select.body:                                      ; preds = %select.loop
  %v.sext = sext i32 %v.sel to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.zero = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  %cand.ok = and i1 %vis.zero, %lt.min
  %u.next = select i1 %cand.ok, i32 %v.sel, i32 %u.cur
  %min.next = select i1 %cand.ok, i32 %dist.v, i32 %min.cur
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
  %rel.end.not = icmp slt i32 %v.rel, %n
  br i1 %rel.end.not, label %relax.body, label %outer.afterUpdate

relax.body:                                       ; preds = %relax.loop
  %v.rel.sext = sext i32 %v.rel to i64
  %w.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u.sext, i64 %v.rel.sext
  %w = load i32, i32* %w.ptr, align 4
  %w.zero = icmp eq i32 %w, 0
  br i1 %w.zero, label %relax.latch, label %check.visited.v

check.visited.v:                                  ; preds = %relax.body
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.rel.sext
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %vis.v2.zero = icmp eq i32 %vis.v2, 0
  br i1 %vis.v2.zero, label %check.u.inf, label %relax.latch

check.u.inf:                                      ; preds = %check.visited.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax.latch, label %try.relax

try.relax:                                        ; preds = %check.u.inf
  %sum = add i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.rel.sext
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %gt.cur = icmp sgt i32 %dist.v2, %sum
  %spec.store.select = select i1 %gt.cur, i32 %sum, i32 %dist.v2
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:                                      ; preds = %try.relax, %check.u.inf, %check.visited.v, %relax.body
  %v.rel.next = add i32 %v.rel, 1
  br label %relax.loop

outer.afterUpdate:                                ; preds = %relax.loop
  %count.next = add i32 %count, 1
  br label %outer.loop

print.start:                                      ; preds = %select.done, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %print.start
  %i.print = phi i32 [ 0, %print.start ], [ %i.print.next, %print.latch ]
  %print.end.not = icmp slt i32 %i.print, %n
  br i1 %print.end.not, label %print.body, label %exit

print.body:                                       ; preds = %print.loop
  %i.print.sext = sext i32 %i.print to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.print.sext
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %i.print)
  br label %print.latch

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %i.print, i32 %dist.i)
  br label %print.latch

print.latch:                                      ; preds = %print.val, %print.inf
  %i.print.next = add i32 %i.print, 1
  br label %print.loop

exit:                                             ; preds = %print.loop
  ret void
}

declare i32 @printf(i8* nocapture readonly, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
