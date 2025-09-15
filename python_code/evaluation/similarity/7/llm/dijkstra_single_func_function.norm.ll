; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_single_func_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_single_func_function.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_num = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* nocapture %matrix, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i.init, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i64.init = zext i32 %i.init to i64
  %dist.ptr.init = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64.init
  store i32 2147483647, i32* %dist.ptr.init, align 4
  %vis.ptr.init = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64.init
  store i32 0, i32* %vis.ptr.init, align 4
  %i.next = add nuw nsw i32 %i.init, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.latch, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.latch ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %count, %nminus1
  br i1 %cmp.outer, label %findmin.loop, label %after.outer

findmin.loop:                                     ; preds = %outer.loop, %findmin.latch
  %minIdx.ph = phi i32 [ %minIdx.next, %findmin.latch ], [ -1, %outer.loop ]
  %minDist.ph = phi i32 [ %minDist.next, %findmin.latch ], [ 2147483647, %outer.loop ]
  %v.min = phi i32 [ %v.min.next, %findmin.latch ], [ 0, %outer.loop ]
  %cmp.v.min = icmp slt i32 %v.min, %n
  br i1 %cmp.v.min, label %findmin.body, label %findmin.end

findmin.body:                                     ; preds = %findmin.loop
  %v64.min = zext i32 %v.min to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64.min
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %isUnvisited = icmp eq i32 %vis.v, 0
  br i1 %isUnvisited, label %check.dist, label %findmin.latch

check.dist:                                       ; preds = %findmin.body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64.min
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmp.dist.min = icmp slt i32 %dist.v, %minDist.ph
  %spec.select = select i1 %cmp.dist.min, i32 %dist.v, i32 %minDist.ph
  %spec.select1 = select i1 %cmp.dist.min, i32 %v.min, i32 %minIdx.ph
  br label %findmin.latch

findmin.latch:                                    ; preds = %check.dist, %findmin.body
  %minDist.next = phi i32 [ %minDist.ph, %findmin.body ], [ %spec.select, %check.dist ]
  %minIdx.next = phi i32 [ %minIdx.ph, %findmin.body ], [ %spec.select1, %check.dist ]
  %v.min.next = add nuw nsw i32 %v.min, 1
  br label %findmin.loop

findmin.end:                                      ; preds = %findmin.loop
  %cmp.noMin = icmp eq i32 %minIdx.ph, -1
  br i1 %cmp.noMin, label %after.outer, label %relax.init

relax.init:                                       ; preds = %findmin.end
  %minIdx64 = sext i32 %minIdx.ph to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %minIdx64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.latch, %relax.init
  %v2 = phi i32 [ 0, %relax.init ], [ %v2.next, %relax.latch ]
  %cmp.v2 = icmp slt i32 %v2, %n
  br i1 %cmp.v2, label %relax.body, label %outer.latch

relax.body:                                       ; preds = %relax.loop
  %v2_64 = zext i32 %v2 to i64
  %row.mul = mul nsw i64 %minIdx64, 100
  %mat.idx = add nsw i64 %row.mul, %v2_64
  %mat.ptr = getelementptr inbounds i32, i32* %matrix, i64 %mat.idx
  %w = load i32, i32* %mat.ptr, align 4
  %hasEdge.not = icmp eq i32 %w, 0
  br i1 %hasEdge.not, label %relax.latch, label %relax.check.vis

relax.check.vis:                                  ; preds = %relax.body
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2_64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2.unvisited = icmp eq i32 %vis.v2, 0
  br i1 %v2.unvisited, label %relax.check.inf, label %relax.latch

relax.check.inf:                                  ; preds = %relax.check.vis
  %dist.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %minIdx64
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %isInf = icmp eq i32 %dist.min, 2147483647
  br i1 %isInf, label %relax.latch, label %relax.cmp

relax.cmp:                                        ; preds = %relax.check.inf
  %sum = add nsw i32 %dist.min, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2_64
  %dist.v2.cur = load i32, i32* %dist.v2.ptr, align 4
  %better = icmp sgt i32 %dist.v2.cur, %sum
  %spec.store.select = select i1 %better, i32 %sum, i32 %dist.v2.cur
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:                                      ; preds = %relax.cmp, %relax.check.inf, %relax.check.vis, %relax.body
  %v2.next = add nuw nsw i32 %v2, 1
  br label %relax.loop

outer.latch:                                      ; preds = %relax.loop
  %count.next = add nuw nsw i32 %count, 1
  br label %outer.loop

after.outer:                                      ; preds = %findmin.end, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %after.outer
  %pi = phi i32 [ 0, %after.outer ], [ %pi.next, %print.latch ]
  %cmp.pi = icmp slt i32 %pi, %n
  br i1 %cmp.pi, label %print.body, label %print.end

print.body:                                       ; preds = %print.loop
  %pi64 = zext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %isInf.pi = icmp eq i32 %dist.pi, 2147483647
  br i1 %isInf.pi, label %print.inf, label %print.num

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %pi)
  br label %print.latch

print.num:                                        ; preds = %print.body
  %call.num = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_num, i64 0, i64 0), i32 %pi, i32 %dist.pi)
  br label %print.latch

print.latch:                                      ; preds = %print.num, %print.inf
  %pi.next = add nuw nsw i32 %pi, 1
  br label %print.loop

print.end:                                        ; preds = %print.loop
  ret void
}
