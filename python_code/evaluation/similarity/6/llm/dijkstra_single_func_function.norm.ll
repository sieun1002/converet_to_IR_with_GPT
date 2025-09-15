; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_single_func_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_single_func_function.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @dijkstra(i32* noundef %graph, i32 noundef %n, i32 noundef %src) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %init.body, label %init.exit

init.body:                                        ; preds = %init.loop
  %i64 = zext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %init.loop

init.exit:                                        ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.exit
  %k = phi i32 [ 0, %init.exit ], [ %k.next, %outer.inc ]
  %nsub1 = add nsw i32 %n, -1
  %ok = icmp slt i32 %k, %nsub1
  br i1 %ok, label %select.loop, label %outer.exit

select.loop:                                      ; preds = %outer.loop, %select.inc
  %j = phi i32 [ %j.next, %select.inc ], [ 0, %outer.loop ]
  %minIndex = phi i32 [ %minIndex.phi, %select.inc ], [ -1, %outer.loop ]
  %minDist = phi i32 [ %minDist.phi, %select.inc ], [ 2147483647, %outer.loop ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %select.body, label %select.exit

select.body:                                      ; preds = %select.loop
  %j64 = zext i32 %j to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %j64
  %visj = load i32, i32* %vis.j.ptr, align 4
  %visj.zero = icmp eq i32 %visj, 0
  br i1 %visj.zero, label %sel.check2, label %select.inc

sel.check2:                                       ; preds = %select.body
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %distj = load i32, i32* %dist.j.ptr, align 4
  %less = icmp slt i32 %distj, %minDist
  %spec.select = select i1 %less, i32 %distj, i32 %minDist
  %spec.select1 = select i1 %less, i32 %j, i32 %minIndex
  br label %select.inc

select.inc:                                       ; preds = %sel.check2, %select.body
  %minDist.phi = phi i32 [ %minDist, %select.body ], [ %spec.select, %sel.check2 ]
  %minIndex.phi = phi i32 [ %minIndex, %select.body ], [ %spec.select1, %sel.check2 ]
  %j.next = add nuw nsw i32 %j, 1
  br label %select.loop

select.exit:                                      ; preds = %select.loop
  %minidx.neg1 = icmp eq i32 %minIndex, -1
  br i1 %minidx.neg1, label %outer.exit, label %mark.visited

mark.visited:                                     ; preds = %select.exit
  %min64 = sext i32 %minIndex to i64
  %vis.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %min64
  store i32 1, i32* %vis.min.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.inc, %mark.visited
  %v = phi i32 [ 0, %mark.visited ], [ %v.next, %relax.inc ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v64 = zext i32 %v to i64
  %rowMul = mul nsw i64 %min64, 100
  %offset = add nsw i64 %rowMul, %v64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %offset
  %w = load i32, i32* %edge.ptr, align 4
  %edgeZero = icmp eq i32 %w, 0
  br i1 %edgeZero, label %relax.inc, label %chk.vis

chk.vis:                                          ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %visv = load i32, i32* %vis.v.ptr, align 4
  %visv.zero = icmp eq i32 %visv, 0
  br i1 %visv.zero, label %chk.inf, label %relax.inc

chk.inf:                                          ; preds = %chk.vis
  %dist.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %min64
  %distu = load i32, i32* %dist.min.ptr, align 4
  %isinf = icmp eq i32 %distu, 2147483647
  br i1 %isinf, label %relax.inc, label %chk.better

chk.better:                                       ; preds = %chk.inf
  %sum = add nsw i32 %distu, %w
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %distv = load i32, i32* %dist.v.ptr, align 4
  %better = icmp sgt i32 %distv, %sum
  %spec.store.select = select i1 %better, i32 %sum, i32 %distv
  store i32 %spec.store.select, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %chk.better, %chk.inf, %chk.vis, %relax.body
  %v.next = add nuw nsw i32 %v, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %k.next = add nuw nsw i32 %k, 1
  br label %outer.loop

outer.exit:                                       ; preds = %select.exit, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %outer.exit
  %p = phi i32 [ 0, %outer.exit ], [ %p.next, %print.inc ]
  %p.cmp = icmp slt i32 %p, %n
  br i1 %p.cmp, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %p64 = zext i32 %p to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p64
  %distp = load i32, i32* %dist.p.ptr, align 4
  %isInfP = icmp eq i32 %distp, 2147483647
  br i1 %isInfP, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %p)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %p, i32 %distp)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %p.next = add nuw nsw i32 %p, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}
