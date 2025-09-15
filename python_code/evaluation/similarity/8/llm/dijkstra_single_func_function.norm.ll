; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_single_func_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_single_func_function.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i.ph, %n
  br i1 %cmp.init, label %init.body, label %init.done

init.body:                                        ; preds = %init.loop
  %i.ext = zext i32 %i.ph to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.ext
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.ext
  store i32 0, i32* %vis.ptr, align 4
  %i.next = add nuw nsw i32 %i.ph, 1
  br label %init.loop

init.done:                                        ; preds = %init.loop
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %init.done
  %count.ph = phi i32 [ 0, %init.done ], [ %count.next, %outer.inc ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer.not = icmp slt i32 %count.ph, %n.minus1
  br i1 %cmp.outer.not, label %select.loop, label %print.start

select.loop:                                      ; preds = %outer.cond, %select.inc
  %vsel.ph = phi i32 [ %vsel.next, %select.inc ], [ 0, %outer.cond ]
  %bestIdx.ph = phi i32 [ %bestIdx.next, %select.inc ], [ -1, %outer.cond ]
  %bestDist.ph = phi i32 [ %bestDist.next, %select.inc ], [ 2147483647, %outer.cond ]
  %cmp.vsel = icmp slt i32 %vsel.ph, %n
  br i1 %cmp.vsel, label %select.body, label %select.done

select.body:                                      ; preds = %select.loop
  %vsel.ext = zext i32 %vsel.ph to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %vsel.ext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.v, 0
  br i1 %is.unvisited, label %select.body.cmp, label %select.inc

select.body.cmp:                                  ; preds = %select.body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %vsel.ext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmp.dist = icmp slt i32 %dist.v, %bestDist.ph
  %dist.v.bestDist.ph = select i1 %cmp.dist, i32 %dist.v, i32 %bestDist.ph
  %vsel.ph.bestIdx.ph = select i1 %cmp.dist, i32 %vsel.ph, i32 %bestIdx.ph
  br label %select.inc

select.inc:                                       ; preds = %select.body, %select.body.cmp
  %bestDist.next = phi i32 [ %dist.v.bestDist.ph, %select.body.cmp ], [ %bestDist.ph, %select.body ]
  %bestIdx.next = phi i32 [ %vsel.ph.bestIdx.ph, %select.body.cmp ], [ %bestIdx.ph, %select.body ]
  %vsel.next = add nuw nsw i32 %vsel.ph, 1
  br label %select.loop

select.done:                                      ; preds = %select.loop
  %no.u = icmp eq i32 %bestIdx.ph, -1
  br i1 %no.u, label %print.start, label %after.select

after.select:                                     ; preds = %select.done
  %u.ext = sext i32 %bestIdx.ph to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.ext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.inc, %after.select
  %v.ph = phi i32 [ 0, %after.select ], [ %v.next, %relax.inc ]
  %cmp.v = icmp slt i32 %v.ph, %n
  br i1 %cmp.v, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v.ext2 = zext i32 %v.ph to i64
  %row.mul = mul nsw i64 %u.ext, 100
  %idx.flat = add nsw i64 %row.mul, %v.ext2
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.flat
  %w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %w, 0
  br i1 %edge.zero, label %relax.inc, label %relax.check.vis

relax.check.vis:                                  ; preds = %relax.body
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.ext2
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v.unvisited = icmp eq i32 %vis.v2, 0
  br i1 %v.unvisited, label %relax.check.distu, label %relax.inc

relax.check.distu:                                ; preds = %relax.check.vis
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.ext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.isinf, label %relax.inc, label %relax.compare

relax.compare:                                    ; preds = %relax.check.distu
  %sum = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.ext2
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %better = icmp sgt i32 %dist.v2, %sum
  %spec.store.select = select i1 %better, i32 %sum, i32 %dist.v2
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %relax.compare, %relax.check.distu, %relax.check.vis, %relax.body
  %v.next = add nuw nsw i32 %v.ph, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %count.next = add nuw nsw i32 %count.ph, 1
  br label %outer.cond

print.start:                                      ; preds = %select.done, %outer.cond
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.start
  %pi.ph = phi i32 [ 0, %print.start ], [ %pi.next, %print.inc ]
  %cmp.print = icmp slt i32 %pi.ph, %n
  br i1 %cmp.print, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %pi.ext = zext i32 %pi.ph to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi.ext
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %pi.ph)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.val, i64 0, i64 0), i32 %pi.ph, i32 %dist.pi)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %pi.next = add nuw nsw i32 %pi.ph, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}
