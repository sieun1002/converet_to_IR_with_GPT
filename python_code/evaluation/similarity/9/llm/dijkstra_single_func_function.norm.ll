; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_single_func_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_single_func_function.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i.0, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i64_1 = zext i32 %i.0 to i64
  %dist.ptr.i = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64_1
  store i32 2147483647, i32* %dist.ptr.i, align 4
  %vis.ptr.i = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64_1
  store i32 0, i32* %vis.ptr.i, align 4
  %i.next = add nuw nsw i32 %i.0, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %relax.end, %init.end
  %storemerge = phi i32 [ 0, %init.end ], [ %k.next, %relax.end ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.k = icmp slt i32 %storemerge, %n.minus1
  br i1 %cmp.k, label %outer.body, label %after.outer

outer.body:                                       ; preds = %outer.cond
  %u = alloca i32, align 4
  %minv = alloca i32, align 4
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %minv, align 4
  br label %find.cond

find.cond:                                        ; preds = %find.inc, %outer.body
  %min.cur = phi i32 [ 2147483647, %outer.body ], [ %min.cur6, %find.inc ]
  %u.val = phi i32 [ -1, %outer.body ], [ %u.val4, %find.inc ]
  %storemerge2 = phi i32 [ 0, %outer.body ], [ %j.next, %find.inc ]
  %cmp.j = icmp slt i32 %storemerge2, %n
  br i1 %cmp.j, label %find.body, label %find.end

find.body:                                        ; preds = %find.cond
  %j64 = zext i32 %storemerge2 to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %j64
  %visj = load i32, i32* %vis.j.ptr, align 4
  %is.unvis = icmp eq i32 %visj, 0
  br i1 %is.unvis, label %check.min, label %find.inc

check.min:                                        ; preds = %find.body
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %distj = load i32, i32* %dist.j.ptr, align 4
  %lt = icmp slt i32 %distj, %min.cur
  br i1 %lt, label %update.min, label %find.inc

update.min:                                       ; preds = %check.min
  store i32 %distj, i32* %minv, align 4
  store i32 %storemerge2, i32* %u, align 4
  br label %find.inc

find.inc:                                         ; preds = %update.min, %check.min, %find.body
  %min.cur6 = phi i32 [ %distj, %update.min ], [ %min.cur, %check.min ], [ %min.cur, %find.body ]
  %u.val4 = phi i32 [ %storemerge2, %update.min ], [ %u.val, %check.min ], [ %u.val, %find.body ]
  %j.next = add nuw nsw i32 %storemerge2, 1
  br label %find.cond

find.end:                                         ; preds = %find.cond
  %is.neg1 = icmp eq i32 %u.val, -1
  br i1 %is.neg1, label %after.outer, label %mark.vis

mark.vis:                                         ; preds = %find.end
  %u64 = sext i32 %u.val to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.cond

relax.cond:                                       ; preds = %relax.inc, %mark.vis
  %storemerge3 = phi i32 [ 0, %mark.vis ], [ %v.next, %relax.inc ]
  %cmp.v = icmp slt i32 %storemerge3, %n
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:                                       ; preds = %relax.cond
  %v64 = zext i32 %storemerge3 to i64
  %rowmul = mul nsw i32 %u.val, 100
  %idx = add nsw i32 %rowmul, %storemerge3
  %idx64 = sext i32 %idx to i64
  %gptr = getelementptr inbounds i32, i32* %graph, i64 %idx64
  %gval = load i32, i32* %gptr, align 4
  %nonzero.not = icmp eq i32 %gval, 0
  br i1 %nonzero.not, label %relax.inc, label %check.vis.v

check.vis.v:                                      ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %visv = load i32, i32* %vis.v.ptr, align 4
  %v.unvis = icmp eq i32 %visv, 0
  br i1 %v.unvis, label %check.infu, label %relax.inc

check.infu:                                       ; preds = %check.vis.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %distu = load i32, i32* %dist.u.ptr, align 4
  %is.inf = icmp eq i32 %distu, 2147483647
  br i1 %is.inf, label %relax.inc, label %try.update

try.update:                                       ; preds = %check.infu
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %distv = load i32, i32* %dist.v.ptr, align 4
  %sum = add nsw i32 %distu, %gval
  %gt = icmp sgt i32 %distv, %sum
  %spec.store.select = select i1 %gt, i32 %sum, i32 %distv
  store i32 %spec.store.select, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %try.update, %check.infu, %check.vis.v, %relax.body
  %v.next = add nuw nsw i32 %storemerge3, 1
  br label %relax.cond

relax.end:                                        ; preds = %relax.cond
  %k.next = add nuw nsw i32 %storemerge, 1
  br label %outer.cond

after.outer:                                      ; preds = %find.end, %outer.cond
  br label %print.cond

print.cond:                                       ; preds = %print.inc, %after.outer
  %storemerge1 = phi i32 [ 0, %after.outer ], [ %p.next, %print.inc ]
  %cmp.p = icmp slt i32 %storemerge1, %n
  br i1 %cmp.p, label %print.body, label %ret

print.body:                                       ; preds = %print.cond
  %p64 = zext i32 %storemerge1 to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p64
  %distp = load i32, i32* %dist.p.ptr, align 4
  %is.inf.p = icmp eq i32 %distp, 2147483647
  br i1 %is.inf.p, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %storemerge1)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %storemerge1, i32 %distp)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %p.next = add nuw nsw i32 %storemerge1, 1
  br label %print.cond

ret:                                              ; preds = %print.cond
  ret void
}
