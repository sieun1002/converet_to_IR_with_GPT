; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/1/dijkstra_single_func.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_pair = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %start = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %call_scanf_pair = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i.inc, %loop.body ]
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.0, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call_scanf_triple = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4
  %u.idx = sext i32 %u.val to i64
  %v.idx = sext i32 %v.val to i64
  %elem.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u.idx, i64 %v.idx
  store i32 %w.val, i32* %elem.ptr, align 4
  %elem.ptr.sym = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v.idx, i64 %u.idx
  store i32 %w.val, i32* %elem.ptr.sym, align 4
  %i.inc = add nuw nsw i32 %i.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_scanf_single = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_single, i64 0, i64 0), i32* nonnull %start)
  %base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.final = load i32, i32* %n, align 4
  %start.final = load i32, i32* %start, align 4
  call void @dijkstra(i32* nonnull %base, i32 %n.final, i32 %start.final)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

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

declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
