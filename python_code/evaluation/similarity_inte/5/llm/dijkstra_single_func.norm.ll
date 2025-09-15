; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/dijkstra_single_func.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.dist = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.two, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_as_i8 = bitcast [10000 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_as_i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.0, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.three, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %w.val = load i32, i32* %w, align 4
  %u.val = load i32, i32* %u, align 4
  %u.ext = sext i32 %u.val to i64
  %mul.row = mul nsw i64 %u.ext, 100
  %v.val = load i32, i32* %v, align 4
  %v.ext = sext i32 %v.val to i64
  %idx.uv = add nsw i64 %mul.row, %v.ext
  %elem.uv.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.uv
  store i32 %w.val, i32* %elem.uv.ptr, align 4
  %mul.row.v = mul nsw i64 %v.ext, 100
  %idx.vu = add nsw i64 %mul.row.v, %u.ext
  %elem.vu.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.vu
  store i32 %w.val, i32* %elem.vu.ptr, align 4
  %i.next = add nuw nsw i32 %i.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.one, i64 0, i64 0), i32* nonnull %src)
  %s.base = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* nonnull %s.base, i32 %n.load, i32 %src.load)
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
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i.0, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.sext = zext i32 %i.0 to i64
  %dist.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.ptr0, align 4
  %vis.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.ptr0, align 4
  %i.next = add nuw nsw i32 %i.0, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src.sext = sext i32 %src to i64
  %dist.ptr.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.sext
  store i32 0, i32* %dist.ptr.src, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %relax.end, %init.end
  %iter.0 = phi i32 [ 0, %init.end ], [ %iter.next, %relax.end ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %iter.0, %n.minus1
  br i1 %cmp.outer, label %findmin.cond, label %after.outer

findmin.cond:                                     ; preds = %outer.cond, %findmin.inc
  %u.0 = phi i32 [ %u.1, %findmin.inc ], [ -1, %outer.cond ]
  %min.0 = phi i32 [ %min.1, %findmin.inc ], [ 2147483647, %outer.cond ]
  %j.0 = phi i32 [ %j.next, %findmin.inc ], [ 0, %outer.cond ]
  %cmp.j = icmp slt i32 %j.0, %n
  br i1 %cmp.j, label %findmin.body, label %findmin.end

findmin.body:                                     ; preds = %findmin.cond
  %j.sext = zext i32 %j.0 to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %j.sext
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %vis.zero = icmp eq i32 %vis.j, 0
  br i1 %vis.zero, label %check.min, label %findmin.inc

check.min:                                        ; preds = %findmin.body
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j.sext
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %cmp.min = icmp slt i32 %dist.j, %min.0
  %spec.select = select i1 %cmp.min, i32 %j.0, i32 %u.0
  %spec.select1 = select i1 %cmp.min, i32 %dist.j, i32 %min.0
  br label %findmin.inc

findmin.inc:                                      ; preds = %check.min, %findmin.body
  %u.1 = phi i32 [ %u.0, %findmin.body ], [ %spec.select, %check.min ]
  %min.1 = phi i32 [ %min.0, %findmin.body ], [ %spec.select1, %check.min ]
  %j.next = add nuw nsw i32 %j.0, 1
  br label %findmin.cond

findmin.end:                                      ; preds = %findmin.cond
  %cmp.u = icmp eq i32 %u.0, -1
  br i1 %cmp.u, label %after.outer, label %cont1

cont1:                                            ; preds = %findmin.end
  %u.sext = sext i32 %u.0 to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.sext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.cond

relax.cond:                                       ; preds = %relax.inc, %cont1
  %v.0 = phi i32 [ 0, %cont1 ], [ %v.next, %relax.inc ]
  %cmp.v = icmp slt i32 %v.0, %n
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:                                       ; preds = %relax.cond
  %v.sext = zext i32 %v.0 to i64
  %mul.row = mul nsw i64 %u.sext, 100
  %idx = add nsw i64 %mul.row, %v.sext
  %elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %elem.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %relax.inc, label %check.visited.v

check.visited.v:                                  ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.v.zero = icmp eq i32 %vis.v, 0
  br i1 %vis.v.zero, label %check.distu.inf, label %relax.inc

check.distu.inf:                                  ; preds = %check.visited.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.inf, label %relax.inc, label %calc.alt

calc.alt:                                         ; preds = %check.distu.inf
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmp.dv = icmp sgt i32 %dist.v, %sum
  %spec.store.select = select i1 %cmp.dv, i32 %sum, i32 %dist.v
  store i32 %spec.store.select, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %calc.alt, %check.distu.inf, %check.visited.v, %relax.body
  %v.next = add nuw nsw i32 %v.0, 1
  br label %relax.cond

relax.end:                                        ; preds = %relax.cond
  %iter.next = add nuw nsw i32 %iter.0, 1
  br label %outer.cond

after.outer:                                      ; preds = %findmin.end, %outer.cond
  br label %print.cond

print.cond:                                       ; preds = %print.inc, %after.outer
  %i.1 = phi i32 [ 0, %after.outer ], [ %i.next2, %print.inc ]
  %cmp.i = icmp slt i32 %i.1, %n
  br i1 %cmp.i, label %print.body, label %return

print.body:                                       ; preds = %print.cond
  %i2.sext = zext i32 %i.1 to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i2.sext
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %i.1)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.dist, i64 0, i64 0), i32 %i.1, i32 %dist.i)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %i.next2 = add nuw nsw i32 %i.1, 1
  br label %print.cond

return:                                           ; preds = %print.cond
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
