; ModuleID = 'dijkstra'
declare i32 @printf(i8*, ...)

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00"
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00"

define dso_local void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16

  br label %init.loop

init.loop:                                           ; i = 0..n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %after.init

init.body:
  %i64 = sext i32 %i to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add i32 %i, 1
  br label %init.loop

after.init:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  br label %outer.loop

outer.loop:                                          ; count = 0..n-2
  %count = phi i32 [ 0, %after.init ], [ %count.next, %outer.inc.end ]
  %nminus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %count, %nminus1
  br i1 %outer.cmp, label %select.u, label %print.start

select.u:
  br label %findmin.loop

findmin.loop:                                        ; find u with min dist among unvisited
  %idx = phi i32 [ 0, %select.u ], [ %idx.next, %findmin.inc ]
  %u = phi i32 [ -1, %select.u ], [ %u2, %findmin.inc ]
  %min = phi i32 [ 2147483647, %select.u ], [ %min2, %findmin.inc ]
  %find.cmp = icmp slt i32 %idx, %n
  br i1 %find.cmp, label %findmin.body, label %after.findmin

findmin.body:
  %idx64 = sext i32 %idx to i64
  %vis.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %idx64
  %vis.i = load i32, i32* %vis.i.ptr, align 4
  %unvisited = icmp eq i32 %vis.i, 0
  br i1 %unvisited, label %check.min, label %findmin.inc

check.min:
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %idx64
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %ltmin = icmp slt i32 %dist.i, %min
  br label %findmin.inc

findmin.inc:
  %idx.next = add i32 %idx, 1
  %upd = phi i1 [ false, %findmin.body ], [ %ltmin, %check.min ]
  %new.min.cand = phi i32 [ 0, %findmin.body ], [ %dist.i, %check.min ]
  %min2 = select i1 %upd, i32 %new.min.cand, i32 %min
  %u2 = select i1 %upd, i32 %idx, i32 %u
  br label %findmin.loop

after.findmin:
  ; %u carries from loop header phi; use it
  %u.chosen = phi i32 [ %u, %findmin.loop ]
  %u.is.neg1 = icmp eq i32 %u.chosen, -1
  br i1 %u.is.neg1, label %print.start, label %mark.visited

mark.visited:
  %u64 = sext i32 %u.chosen to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                          ; for v = 0..n-1
  %v = phi i32 [ 0, %mark.visited ], [ %v.next, %relax.inc ]
  %relax.cmp = icmp slt i32 %v, %n
  br i1 %relax.cmp, label %relax.body, label %outer.inc

relax.body:
  %v64 = sext i32 %v to i64
  %cell.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u64, i64 %v64
  %w = load i32, i32* %cell.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  br i1 %has.edge, label %check.vis.v, label %relax.inc

check.vis.v:
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %v.unvisited = icmp eq i32 %vis.v, 0
  br i1 %v.unvisited, label %check.du, label %relax.inc

check.du:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.not.inf = icmp ne i32 %dist.u, 2147483647
  br i1 %u.not.inf, label %check.relax, label %relax.inc

check.relax:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %sum = add i32 %dist.u, %w
  %better = icmp slt i32 %sum, %dist.v
  br i1 %better, label %do.update.dv, label %relax.inc

do.update.dv:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:
  %v.next = add i32 %v, 1
  br label %relax.loop

outer.inc:
  br label %outer.inc.end

outer.inc.end:
  %count.next = add i32 %count, 1
  br label %outer.loop

print.start:
  br label %print.loop

print.loop:                                          ; i = 0..n-1
  %pi = phi i32 [ 0, %print.start ], [ %pi.next, %print.inc ]
  %print.cmp = icmp slt i32 %pi, %n
  br i1 %print.cmp, label %print.body, label %ret

print.body:
  %pi64 = sext i32 %pi to i64
  %dist.pi.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %pi64
  %dist.pi = load i32, i32* %dist.pi.ptr, align 4
  %is.inf = icmp eq i32 %dist.pi, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %pi)
  br label %print.inc

print.val:
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %pi, i32 %dist.pi)
  br label %print.inc

print.inc:
  %pi.next = add i32 %pi, 1
  br label %print.loop

ret:
  ret void
}