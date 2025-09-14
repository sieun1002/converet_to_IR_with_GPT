; ModuleID = 'dijkstra'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %matrix, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                            ; i = 0..n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %i.lt.n = icmp slt i32 %i, %n
  br i1 %i.lt.n, label %init.body, label %init.done

init.body:
  %i64 = sext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.done:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                           ; count = 0..n-2
  %count = phi i32 [ 0, %init.done ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %outer.done.cond = icmp sge i32 %count, %nminus1
  br i1 %outer.done.cond, label %print.init, label %select.min

select.min:
  br label %find.loop

find.loop:                                            ; find u with min dist among unvisited
  %v = phi i32 [ 0, %select.min ], [ %v.next, %find.body ]
  %u.cur = phi i32 [ -1, %select.min ], [ %u.sel, %find.body ]
  %min.cur = phi i32 [ 2147483647, %select.min ], [ %min.sel, %find.body ]
  %v.lt.n2 = icmp slt i32 %v, %n
  br i1 %v.lt.n2, label %find.body, label %find.done

find.body:
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

find.done:
  %u.final = phi i32 [ %u.cur, %find.loop ]
  %u.is.neg1 = icmp eq i32 %u.final, -1
  br i1 %u.is.neg1, label %print.init, label %relax.init

relax.init:
  %u64 = sext i32 %u.final to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                           ; relax edges from u
  %v2 = phi i32 [ 0, %relax.init ], [ %v2.next, %relax.cont ]
  %v2.lt.n = icmp slt i32 %v2, %n
  br i1 %v2.lt.n, label %relax.body, label %outer.inc

relax.body:
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

maybe.update:
  %sum = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v264
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %better = icmp sgt i32 %dist.v2, %sum
  br i1 %better, label %do.update, label %relax.cont

do.update:
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.cont

relax.cont:
  %v2.next = add nsw i32 %v2, 1
  br label %relax.loop

outer.inc:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

print.init:
  br label %print.loop

print.loop:
  %pi = phi i32 [ 0, %print.init ], [ %pi.next, %print.inc ]
  %pi.lt.n = icmp slt i32 %pi, %n
  br i1 %pi.lt.n, label %print.body, label %ret

print.body:
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %pi)
  br label %print.inc

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %pi, i32 %dist.pi)
  br label %print.inc

print.inc:
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

ret:
  ret void
}