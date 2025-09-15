; ModuleID = 'dijkstra_single_func.bc'
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
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %fmt_pair_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_scanf_pair = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_pair_ptr, i32* %n, i32* %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt_triple_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf_triple = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_triple_ptr, i32* %u, i32* %v, i32* %w)
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4
  %u.idx = sext i32 %u.val to i64
  %v.idx = sext i32 %v.val to i64
  %row.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u.idx
  %elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr, i64 0, i64 %v.idx
  store i32 %w.val, i32* %elem.ptr, align 4
  %row.ptr.sym = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v.idx
  %elem.ptr.sym = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr.sym, i64 0, i64 %u.idx
  store i32 %w.val, i32* %elem.ptr.sym, align 4
  %i.cur = load i32, i32* %i, align 4
  %i.inc = add nsw i32 %i.cur, 1
  store i32 %i.inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt_single_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_single, i64 0, i64 0
  %call_scanf_single = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_single_ptr, i32* %start)
  %row0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %base = getelementptr inbounds [100 x i32], [100 x i32]* %row0, i64 0, i64 0
  %n.final = load i32, i32* %n, align 4
  %start.final = load i32, i32* %start, align 4
  call void @dijkstra(i32* %base, i32 %n.final, i32 %start.final)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

define void @dijkstra(i32* %matrix, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %i.lt.n = icmp slt i32 %i, %n
  br i1 %i.lt.n, label %init.body, label %init.done

init.body:                                        ; preds = %init.loop
  %i64 = sext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:                                         ; preds = %init.body
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.done:                                        ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.done
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %outer.done.cond = icmp sge i32 %count, %nminus1
  br i1 %outer.done.cond, label %print.init, label %select.min

select.min:                                       ; preds = %outer.loop
  br label %find.loop

find.loop:                                        ; preds = %find.body, %select.min
  %v = phi i32 [ 0, %select.min ], [ %v.next, %find.body ]
  %u.cur = phi i32 [ -1, %select.min ], [ %u.sel, %find.body ]
  %min.cur = phi i32 [ 2147483647, %select.min ], [ %min.sel, %find.body ]
  %v.lt.n2 = icmp slt i32 %v, %n
  br i1 %v.lt.n2, label %find.body, label %find.done

find.body:                                        ; preds = %find.loop
  %v64 = sext i32 %v to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.is0 = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  %pick = and i1 %vis.is0, %lt.min
  %u.sel = select i1 %pick, i32 %v, i32 %u.cur
  %min.sel = select i1 %pick, i32 %dist.v, i32 %min.cur
  %v.next = add nsw i32 %v, 1
  br label %find.loop

find.done:                                        ; preds = %find.loop
  %u.final = phi i32 [ %u.cur, %find.loop ]
  %u.is.neg1 = icmp eq i32 %u.final, -1
  br i1 %u.is.neg1, label %print.init, label %relax.init

relax.init:                                       ; preds = %find.done
  %u64 = sext i32 %u.final to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.cont, %relax.init
  %v2 = phi i32 [ 0, %relax.init ], [ %v2.next, %relax.cont ]
  %v2.lt.n = icmp slt i32 %v2, %n
  br i1 %v2.lt.n, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v264 = sext i32 %v2 to i64
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
  br i1 %better, label %do.update, label %relax.cont

do.update:                                        ; preds = %maybe.update
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.cont

relax.cont:                                       ; preds = %do.update, %maybe.update, %relax.body
  %v2.next = add nsw i32 %v2, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

print.init:                                       ; preds = %find.done, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.init
  %pi = phi i32 [ 0, %print.init ], [ %pi.next, %print.inc ]
  %pi.lt.n = icmp slt i32 %pi, %n
  br i1 %pi.lt.n, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %pi)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %pi, i32 %dist.pi)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}

declare i32 @printf(i8*, ...)
