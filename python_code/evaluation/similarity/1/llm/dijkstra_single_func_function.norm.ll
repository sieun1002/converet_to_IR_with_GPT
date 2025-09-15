; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_single_func_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_single_func_function.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %matrix, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %i.lt.n = icmp slt i32 %i, %n
  br i1 %i.lt.n, label %init.body, label %init.done

init.body:                                        ; preds = %init.loop
  %i64 = zext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %init.loop

init.done:                                        ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.done
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %outer.done.cond.not = icmp slt i32 %count, %nminus1
  br i1 %outer.done.cond.not, label %find.loop, label %print.init

find.loop:                                        ; preds = %outer.loop, %find.body
  %v = phi i32 [ %v.next, %find.body ], [ 0, %outer.loop ]
  %u.cur = phi i32 [ %u.sel, %find.body ], [ -1, %outer.loop ]
  %min.cur = phi i32 [ %min.sel, %find.body ], [ 2147483647, %outer.loop ]
  %v.lt.n2 = icmp slt i32 %v, %n
  br i1 %v.lt.n2, label %find.body, label %find.done

find.body:                                        ; preds = %find.loop
  %v64 = zext i32 %v to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.is0 = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  %pick = and i1 %vis.is0, %lt.min
  %u.sel = select i1 %pick, i32 %v, i32 %u.cur
  %min.sel = select i1 %pick, i32 %dist.v, i32 %min.cur
  %v.next = add nuw nsw i32 %v, 1
  br label %find.loop

find.done:                                        ; preds = %find.loop
  %u.is.neg1 = icmp eq i32 %u.cur, -1
  br i1 %u.is.neg1, label %print.init, label %relax.init

relax.init:                                       ; preds = %find.done
  %u64 = sext i32 %u.cur to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.cont, %relax.init
  %v2 = phi i32 [ 0, %relax.init ], [ %v2.next, %relax.cont ]
  %v2.lt.n = icmp slt i32 %v2, %n
  br i1 %v2.lt.n, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v264 = zext i32 %v2 to i64
  %row.off = mul nsw i64 %u64, 100
  %mat.idx = add nsw i64 %row.off, %v264
  %mat.ptr = getelementptr inbounds i32, i32* %matrix, i64 %mat.idx
  %w = load i32, i32* %mat.ptr, align 4
  %w.nz = icmp ne i32 %w, 0
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v264
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2.unvisited = icmp eq i32 %vis.v2, 0
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.not.inf = icmp ne i32 %dist.u, 2147483647
  %cond.all1 = and i1 %w.nz, %v2.unvisited
  %cond.all = and i1 %cond.all1, %u.not.inf
  br i1 %cond.all, label %maybe.update, label %relax.cont

maybe.update:                                     ; preds = %relax.body
  %sum = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v264
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %better = icmp sgt i32 %dist.v2, %sum
  %spec.store.select = select i1 %better, i32 %sum, i32 %dist.v2
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  br label %relax.cont

relax.cont:                                       ; preds = %maybe.update, %relax.body
  %v2.next = add nuw nsw i32 %v2, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %count.next = add nuw nsw i32 %count, 1
  br label %outer.loop

print.init:                                       ; preds = %find.done, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.init
  %pi = phi i32 [ 0, %print.init ], [ %pi.next, %print.inc ]
  %pi.lt.n = icmp slt i32 %pi, %n
  br i1 %pi.lt.n, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %pi64 = zext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %pi)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %pi, i32 %dist.pi)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %pi.next = add nuw nsw i32 %pi, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}
