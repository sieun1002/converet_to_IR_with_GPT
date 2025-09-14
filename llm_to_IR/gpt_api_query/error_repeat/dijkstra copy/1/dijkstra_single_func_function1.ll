; ModuleID = 'dijkstra_module'
source_filename = "dijkstra.ll"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [14 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                          ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i to i64
  %dist.gep = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.gep, align 4
  %vis.gep = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i64
  store i32 0, i32* %vis.gep, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                         ; count from 0 to n-2
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %count, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %after.outer

outer.body:
  br label %find.min.loop

find.min.loop:
  %u = phi i32 [ -1, %outer.body ], [ %u.sel, %find.min.inc ]
  %min = phi i32 [ 2147483647, %outer.body ], [ %min.sel, %find.min.inc ]
  %v1 = phi i32 [ 0, %outer.body ], [ %v1.next, %find.min.inc ]
  %cond = icmp slt i32 %v1, %n
  br i1 %cond, label %find.min.body, label %find.min.end

find.min.body:
  %v1_64 = sext i32 %v1 to i64
  %vis.v1.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v1_64
  %vis.v1 = load i32, i32* %vis.v1.ptr, align 4
  %is.not.visited = icmp eq i32 %vis.v1, 0
  br i1 %is.not.visited, label %check.dist, label %find.min.inc

check.dist:
  %dist.v1.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v1_64
  %dist.v1 = load i32, i32* %dist.v1.ptr, align 4
  %lt = icmp slt i32 %dist.v1, %min
  br i1 %lt, label %update.min, label %find.min.inc

update.min:
  br label %find.min.inc

find.min.inc:
  %min.sel = phi i32 [ %min, %check.dist ], [ %dist.v1, %update.min ], [ %min, %find.min.body ]
  %u.sel = phi i32 [ %u, %check.dist ], [ %v1, %update.min ], [ %u, %find.min.body ]
  %v1.next = add nsw i32 %v1, 1
  br label %find.min.loop

find.min.end:
  %u.end = phi i32 [ %u, %find.min.loop ]
  %cmp.u = icmp eq i32 %u.end, -1
  br i1 %cmp.u, label %after.outer, label %mark.visited

mark.visited:
  %u64 = sext i32 %u.end to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                         ; v from 0 to n-1
  %v2 = phi i32 [ 0, %mark.visited ], [ %v2.next, %relax.inc ]
  %cond.v2 = icmp slt i32 %v2, %n
  br i1 %cond.v2, label %relax.body, label %outer.inc

relax.body:
  %v2_64 = sext i32 %v2 to i64
  %u.row = sext i32 %u.end to i64
  %u.row.base = mul nsw i64 %u.row, 100
  %idx = add nsw i64 %u.row.base, %v2_64
  %elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %elem.ptr, align 4
  %w.nonzero = icmp ne i32 %w, 0
  br i1 %w.nonzero, label %check.relax.visited, label %relax.inc

check.relax.visited:
  %vis.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2_64
  %vis.v2 = load i32, i32* %vis.v2.ptr, align 4
  %v2.not.vis = icmp eq i32 %vis.v2, 0
  br i1 %v2.not.vis, label %check.distu.inf, label %relax.inc

check.distu.inf:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.not.inf = icmp ne i32 %dist.u, 2147483647
  br i1 %u.not.inf, label %compute.relax, label %relax.inc

compute.relax:
  %sum = add nsw i32 %dist.u, %w
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2_64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %improve = icmp sgt i32 %dist.v2, %sum
  br i1 %improve, label %do.relax, label %relax.inc

do.relax:
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.inc

relax.inc:
  %v2.next = add nsw i32 %v2, 1
  br label %relax.loop

outer.inc:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

after.outer:
  br label %print.loop

print.loop:                                         ; i from 0 to n-1
  %p = phi i32 [ 0, %after.outer ], [ %p.next, %print.inc ]
  %p.cond = icmp slt i32 %p, %n
  br i1 %p.cond, label %print.body, label %ret

print.body:
  %p64 = sext i32 %p to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p64
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %is.inf = icmp eq i32 %dist.p, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:
  %fmt1.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i32 %p)
  br label %print.inc

print.val:
  %fmt2.ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str_val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %p, i32 %dist.p)
  br label %print.inc

print.inc:
  %p.next = add nsw i32 %p, 1
  br label %print.loop

ret:
  ret void
}