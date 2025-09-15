; ModuleID = 'dijkstra_single_func.bc'
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
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %var_9C54 = alloca i32, align 4
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  store i32 0, i32* %var_4, align 4
  %fmt_dd_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_double, i64 0, i64 0
  %call_scanf_dd = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_ptr, i32* %var_8, i32* %var_C)
  %s_as_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_as_i8, i32 0, i64 40000)
  store i32 0, i32* %var_9C54, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i_val = load i32, i32* %var_9C54, align 4
  %nedges = load i32, i32* %var_C, align 4
  %cmp_ge = icmp sge i32 %i_val, %nedges
  br i1 %cmp_ge, label %after_loop, label %body

body:                                             ; preds = %loop
  %fmt_ddd_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf_ddd = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd_ptr, i32* %var_9C58, i32* %var_9C5C, i32* %var_9C60)
  %w_load_1 = load i32, i32* %var_9C60, align 4
  %u_load = load i32, i32* %var_9C58, align 4
  %v_load = load i32, i32* %var_9C5C, align 4
  %u_idx = sext i32 %u_load to i64
  %v_idx = sext i32 %v_load to i64
  %row_u_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_idx
  %cell_uv_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_u_ptr, i64 0, i64 %v_idx
  store i32 %w_load_1, i32* %cell_uv_ptr, align 4
  %row_v_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_idx
  %cell_vu_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_v_ptr, i64 0, i64 %u_idx
  store i32 %w_load_1, i32* %cell_vu_ptr, align 4
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %var_9C54, align 4
  br label %loop

after_loop:                                       ; preds = %loop
  %fmt_d_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_single, i64 0, i64 0
  %call_scanf_d = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_ptr, i32* %var_9C64)
  %s_flat_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %arg_m = load i32, i32* %var_8, align 4
  %arg_start = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* %s_flat_ptr, i32 %arg_m, i32 %arg_start)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.inc, %entry
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp slt i32 %i.phi, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i64 = sext i32 %i.phi to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:                                         ; preds = %init.body
  %i.next = add nsw i32 %i.phi, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.cont, %init.end
  %count.phi = phi i32 [ 0, %init.end ], [ %count.next, %outer.cont ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond = icmp sge i32 %count.phi, %n.minus1
  br i1 %outer.cond, label %print.start, label %outer.body

outer.body:                                       ; preds = %outer.loop
  br label %findmin.loop

findmin.loop:                                     ; preds = %findmin.inc, %outer.body
  %minIdx.phi = phi i32 [ -1, %outer.body ], [ %minIdx.next, %findmin.inc ]
  %minDist.phi = phi i32 [ 2147483647, %outer.body ], [ %minDist.next, %findmin.inc ]
  %v.phi = phi i32 [ 0, %outer.body ], [ %v.next, %findmin.inc ]
  %v.cmp = icmp slt i32 %v.phi, %n
  br i1 %v.cmp, label %findmin.body, label %findmin.end

findmin.body:                                     ; preds = %findmin.loop
  %v64 = sext i32 %v.phi to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %isVisited = icmp ne i32 %vis.v, 0
  br i1 %isVisited, label %findmin.inc, label %findmin.check

findmin.check:                                    ; preds = %findmin.body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %less = icmp slt i32 %dist.v, %minDist.phi
  br i1 %less, label %findmin.update, label %findmin.inc

findmin.update:                                   ; preds = %findmin.check
  br label %findmin.inc

findmin.inc:                                      ; preds = %findmin.update, %findmin.check, %findmin.body
  %minDist.next = phi i32 [ %minDist.phi, %findmin.body ], [ %minDist.phi, %findmin.check ], [ %dist.v, %findmin.update ]
  %minIdx.next = phi i32 [ %minIdx.phi, %findmin.body ], [ %minIdx.phi, %findmin.check ], [ %v.phi, %findmin.update ]
  %v.next = add nsw i32 %v.phi, 1
  br label %findmin.loop

findmin.end:                                      ; preds = %findmin.loop
  %minIdx.final = phi i32 [ %minIdx.phi, %findmin.loop ]
  %minDist.final = phi i32 [ %minDist.phi, %findmin.loop ]
  %noCandidate = icmp eq i32 %minIdx.final, -1
  br i1 %noCandidate, label %outer.break, label %selected

selected:                                         ; preds = %findmin.end
  %minIdx64 = sext i32 %minIdx.final to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %minIdx64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.inc, %selected
  %v2.phi = phi i32 [ 0, %selected ], [ %v2.next, %relax.inc ]
  %v2.cmp = icmp slt i32 %v2.phi, %n
  br i1 %v2.cmp, label %relax.body, label %relax.end

relax.body:                                       ; preds = %relax.loop
  %minIdx.mul = mul nsw i32 %minIdx.final, 100
  %idx.sum = add nsw i32 %minIdx.mul, %v2.phi
  %idx.sum64 = sext i32 %idx.sum to i64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.sum64
  %edge.w = load i32, i32* %edge.ptr, align 4
  %edge.zero = icmp eq i32 %edge.w, 0
  br i1 %edge.zero, label %relax.inc, label %relax.checkVis

relax.checkVis:                                   ; preds = %relax.body
  %v2.64 = sext i32 %v2.phi to i64
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2.64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2Visited = icmp ne i32 %vis.v2, 0
  br i1 %v2Visited, label %relax.inc, label %relax.checkInf

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
  br i1 %better, label %relax.update, label %relax.inc

relax.update:                                     ; preds = %relax.compare
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %relax.update, %relax.compare, %relax.checkInf, %relax.checkVis, %relax.body
  %v2.next = add nsw i32 %v2.phi, 1
  br label %relax.loop

relax.end:                                        ; preds = %relax.loop
  br label %outer.cont

outer.cont:                                       ; preds = %relax.end
  %count.next = add nsw i32 %count.phi, 1
  br label %outer.loop

outer.break:                                      ; preds = %findmin.end
  br label %print.start

print.start:                                      ; preds = %outer.break, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.start
  %pidx.phi = phi i32 [ 0, %print.start ], [ %pidx.next, %print.inc ]
  %p.cmp = icmp slt i32 %pidx.phi, %n
  br i1 %p.cmp, label %print.body, label %ret.block

print.body:                                       ; preds = %print.loop
  %pidx64 = sext i32 %pidx.phi to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pidx64
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %isInf2 = icmp eq i32 %dist.p, 2147483647
  br i1 %isInf2, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %pidx.phi)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %pidx.phi, i32 %dist.p)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %pidx.next = add nsw i32 %pidx.phi, 1
  br label %print.loop

ret.block:                                        ; preds = %print.loop
  ret void
}

declare i32 @printf(i8*, ...)
