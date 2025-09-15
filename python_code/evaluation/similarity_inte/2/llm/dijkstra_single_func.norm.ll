; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/2/dijkstra_single_func.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private constant [16 x i8] c"dist[%d] = INF\0A\00"
@.str_val = private constant [15 x i8] c"dist[%d] = %d\0A\00"

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %t.0 = phi i32 [ 0, %entry ], [ %tinc, %loop.body ]
  %mval = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %t.0, %mval
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* nonnull %i, i32* nonnull %j, i32* nonnull %w)
  %iv = load i32, i32* %i, align 4
  %jv = load i32, i32* %j, align 4
  %wv = load i32, i32* %w, align 4
  %iv64 = sext i32 %iv to i64
  %jv64 = sext i32 %jv to i64
  %elemPtr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %iv64, i64 %jv64
  store i32 %wv, i32* %elemPtr, align 4
  %elemPtr_t = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %jv64, i64 %iv64
  store i32 %wv, i32* %elemPtr_t, align 4
  %tinc = add nuw nsw i32 %t.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* nonnull %src)
  %s_i32 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  call void @dijkstra(i32* nonnull %s_i32, i32 %nval, i32 %srcval)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %n64 = sext i32 %n to i64
  %dist = alloca i32, i64 %n64, align 16
  %visited = alloca i32, i64 %n64, align 16
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i.init, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.init.64 = zext i32 %i.init to i64
  %dist.ptr.init = getelementptr inbounds i32, i32* %dist, i64 %i.init.64
  store i32 2147483647, i32* %dist.ptr.init, align 4
  %visited.ptr.init = getelementptr inbounds i32, i32* %visited, i64 %i.init.64
  store i32 0, i32* %visited.ptr.init, align 4
  %i.next = add nuw nsw i32 %i.init, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.latch, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %count, %n.minus1
  br i1 %outer.cmp, label %select.loop, label %after.outer

select.loop:                                      ; preds = %outer.loop, %select.body
  %v.sel = phi i32 [ %v.sel.next, %select.body ], [ 0, %outer.loop ]
  %u.cur = phi i32 [ %u.next, %select.body ], [ -1, %outer.loop ]
  %min.cur = phi i32 [ %min.next, %select.body ], [ 2147483647, %outer.loop ]
  %sel.cmp = icmp slt i32 %v.sel, %n
  br i1 %sel.cmp, label %select.body, label %select.end

select.body:                                      ; preds = %select.loop
  %v.sel.64 = zext i32 %v.sel to i64
  %vis.v.ptr = getelementptr inbounds i32, i32* %visited, i64 %v.sel.64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sel.64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is.less = icmp slt i32 %dist.v, %min.cur
  %cond.update = and i1 %is.unvisited, %is.less
  %u.next = select i1 %cond.update, i32 %v.sel, i32 %u.cur
  %min.next = select i1 %cond.update, i32 %dist.v, i32 %min.cur
  %v.sel.next = add nuw nsw i32 %v.sel, 1
  br label %select.loop

select.end:                                       ; preds = %select.loop
  %u.neg1 = icmp eq i32 %u.cur, -1
  br i1 %u.neg1, label %after.outer, label %relax.init

relax.init:                                       ; preds = %select.end
  %u.fin.64 = sext i32 %u.cur to i64
  %visited.u.ptr = getelementptr inbounds i32, i32* %visited, i64 %u.fin.64
  store i32 1, i32* %visited.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.body, %relax.init
  %v.rel = phi i32 [ 0, %relax.init ], [ %v.rel.next, %relax.body ]
  %rel.cmp = icmp slt i32 %v.rel, %n
  br i1 %rel.cmp, label %relax.body, label %outer.latch

relax.body:                                       ; preds = %relax.loop
  %v.rel.64 = zext i32 %v.rel to i64
  %u.mul = mul nsw i64 %u.fin.64, 100
  %idx.linear = add nsw i64 %u.mul, %v.rel.64
  %adj.ptr = getelementptr i32, i32* %graph, i64 %idx.linear
  %w = load i32, i32* %adj.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  %vis.v2.ptr = getelementptr inbounds i32, i32* %visited, i64 %v.rel.64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %is.unvisited2 = icmp eq i32 %vis.v2, 0
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.fin.64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.not.inf = icmp ne i32 %dist.u, 2147483647
  %sum = add i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.rel.64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %is.better = icmp sgt i32 %dist.v2, %sum
  %c1 = and i1 %has.edge, %is.unvisited2
  %c2 = and i1 %c1, %u.not.inf
  %do.update = and i1 %c2, %is.better
  %spec.store.select = select i1 %do.update, i32 %sum, i32 %dist.v2
  store i32 %spec.store.select, i32* %dist.v2.ptr, align 4
  %v.rel.next = add nuw nsw i32 %v.rel, 1
  br label %relax.loop

outer.latch:                                      ; preds = %relax.loop
  %count.next = add nuw nsw i32 %count, 1
  br label %outer.loop

after.outer:                                      ; preds = %select.end, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %after.outer
  %i.print = phi i32 [ 0, %after.outer ], [ %i.print.next, %print.latch ]
  %print.cmp = icmp slt i32 %i.print, %n
  br i1 %print.cmp, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %i.print.64 = zext i32 %i.print to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.print.64
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
  %i.print.next = add nuw nsw i32 %i.print, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
