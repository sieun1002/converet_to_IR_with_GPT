; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/dijkstra_single_func.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_double = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define dso_local i32 @main() {
entry:
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  %call_scanf_dd = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_double, i64 0, i64 0), i32* nonnull %var_8, i32* nonnull %var_C)
  %s_as_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_as_i8, i8 0, i64 40000, i1 false)
  br label %loop

loop:                                             ; preds = %body, %entry
  %var_9C54.0 = phi i32 [ 0, %entry ], [ %i_next, %body ]
  %nedges = load i32, i32* %var_C, align 4
  %cmp_ge.not = icmp slt i32 %var_9C54.0, %nedges
  br i1 %cmp_ge.not, label %body, label %after_loop

body:                                             ; preds = %loop
  %call_scanf_ddd = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0), i32* nonnull %var_9C58, i32* nonnull %var_9C5C, i32* nonnull %var_9C60)
  %w_load_1 = load i32, i32* %var_9C60, align 4
  %u_load = load i32, i32* %var_9C58, align 4
  %v_load = load i32, i32* %var_9C5C, align 4
  %u_idx = sext i32 %u_load to i64
  %v_idx = sext i32 %v_load to i64
  %cell_uv_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_idx, i64 %v_idx
  store i32 %w_load_1, i32* %cell_uv_ptr, align 4
  %cell_vu_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_idx, i64 %u_idx
  store i32 %w_load_1, i32* %cell_vu_ptr, align 4
  %i_next = add nuw nsw i32 %var_9C54.0, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %call_scanf_d = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_single, i64 0, i64 0), i32* nonnull %var_9C64)
  %s_flat_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %arg_m = load i32, i32* %var_8, align 4
  %arg_start = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* nonnull %s_flat_ptr, i32 %arg_m, i32 %arg_start)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i.phi, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i64 = zext i32 %i.phi to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  %i.next = add nuw nsw i32 %i.phi, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.cont, %init.end
  %count.phi = phi i32 [ 0, %init.end ], [ %count.next, %outer.cont ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond.not = icmp slt i32 %count.phi, %n.minus1
  br i1 %outer.cond.not, label %findmin.loop, label %print.start

findmin.loop:                                     ; preds = %outer.loop, %findmin.inc
  %minIdx.phi = phi i32 [ %minIdx.next, %findmin.inc ], [ -1, %outer.loop ]
  %minDist.phi = phi i32 [ %minDist.next, %findmin.inc ], [ 2147483647, %outer.loop ]
  %v.phi = phi i32 [ %v.next, %findmin.inc ], [ 0, %outer.loop ]
  %v.cmp = icmp slt i32 %v.phi, %n
  br i1 %v.cmp, label %findmin.body, label %findmin.end

findmin.body:                                     ; preds = %findmin.loop
  %v64 = zext i32 %v.phi to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %isVisited.not = icmp eq i32 %vis.v, 0
  br i1 %isVisited.not, label %findmin.check, label %findmin.inc

findmin.check:                                    ; preds = %findmin.body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %less = icmp slt i32 %dist.v, %minDist.phi
  %spec.select = select i1 %less, i32 %dist.v, i32 %minDist.phi
  %spec.select1 = select i1 %less, i32 %v.phi, i32 %minIdx.phi
  br label %findmin.inc

findmin.inc:                                      ; preds = %findmin.check, %findmin.body
  %minDist.next = phi i32 [ %minDist.phi, %findmin.body ], [ %spec.select, %findmin.check ]
  %minIdx.next = phi i32 [ %minIdx.phi, %findmin.body ], [ %spec.select1, %findmin.check ]
  %v.next = add nuw nsw i32 %v.phi, 1
  br label %findmin.loop

findmin.end:                                      ; preds = %findmin.loop
  %noCandidate = icmp eq i32 %minIdx.phi, -1
  br i1 %noCandidate, label %print.start, label %selected

selected:                                         ; preds = %findmin.end
  %minIdx64 = sext i32 %minIdx.phi to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %minIdx64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.inc, %selected
  %v2.phi = phi i32 [ 0, %selected ], [ %v2.next, %relax.inc ]
  %v2.cmp = icmp slt i32 %v2.phi, %n
  br i1 %v2.cmp, label %relax.body, label %outer.cont

relax.body:                                       ; preds = %relax.loop
  %minIdx.mul = mul nsw i32 %minIdx.phi, 100
  %idx.sum = add nsw i32 %minIdx.mul, %v2.phi
  %idx.sum64 = sext i32 %idx.sum to i64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.sum64
  %edge.w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %edge.w, 0
  br i1 %edge.zero, label %relax.inc, label %relax.checkVis

relax.checkVis:                                   ; preds = %relax.body
  %v2.64 = zext i32 %v2.phi to i64
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2.64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2Visited.not = icmp eq i32 %vis.v2, 0
  br i1 %v2Visited.not, label %relax.checkInf, label %relax.inc

relax.checkInf:                                   ; preds = %relax.checkVis
  %dist.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %minIdx64
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %isInf = icmp eq i32 %dist.min, 2147483647
  br i1 %isInf, label %relax.inc, label %relax.compare

relax.compare:                                    ; preds = %relax.checkInf
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2.64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %sum = add nsw i32 %dist.min, %edge.w
  %better = icmp sgt i32 %dist.v2, %sum
  %spec.store.select = select i1 %better, i32 %sum, i32 %dist.v2
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %relax.compare, %relax.checkInf, %relax.checkVis, %relax.body
  %v2.next = add nuw nsw i32 %v2.phi, 1
  br label %relax.loop

outer.cont:                                       ; preds = %relax.loop
  %count.next = add nuw nsw i32 %count.phi, 1
  br label %outer.loop

print.start:                                      ; preds = %findmin.end, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.start
  %pidx.phi = phi i32 [ 0, %print.start ], [ %pidx.next, %print.inc ]
  %p.cmp = icmp slt i32 %pidx.phi, %n
  br i1 %p.cmp, label %print.body, label %ret.block

print.body:                                       ; preds = %print.loop
  %pidx64 = zext i32 %pidx.phi to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pidx64
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %isInf2 = icmp eq i32 %dist.p, 2147483647
  br i1 %isInf2, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %pidx.phi)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %pidx.phi, i32 %dist.p)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %pidx.next = add nuw nsw i32 %pidx.phi, 1
  br label %print.loop

ret.block:                                        ; preds = %print.loop
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
