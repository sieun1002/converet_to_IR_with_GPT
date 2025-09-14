; ModuleID = 'dijkstra'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dijkstra ; Address: 0x401120
; Intent: Dijkstra single-source shortest paths over adjacency matrix, print distances (confidence=0.98). Evidence: INT_MAX as INF, visited flags, min-unvisited selection, relax using graph[u][v], final printf.
; Preconditions: 0 <= start < n <= 100; graph points to an adjacency matrix laid out as rows of 100 i32s (zero = no edge, non-negative weights).
; Postconditions: Prints dist[i] for all 0 <= i < n, using "INF" for unreachable; returns void.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define dso_local void @dijkstra(i32* nocapture noundef %graph, i32 noundef %n, i32 noundef %start) local_unnamed_addr {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                       ; i from 0 to n-1: dist[i]=INT_MAX; visited[i]=0
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i.sext = sext i32 %i to i64
  %dist.gep = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.gep, align 4
  %vis.gep = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.gep, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %start.sext = sext i32 %start to i64
  %dist.start = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %start.sext
  store i32 0, i32* %dist.start, align 4
  br label %outer.header

outer.header:                                    ; count from 0 to n-2
  %cnt = phi i32 [ 0, %init.end ], [ %cnt.next, %relax.end ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %cnt, %n.minus1
  br i1 %outer.cmp, label %select.init, label %print.init

select.init:                                     ; min = INF, u = -1
  br label %select.loop

select.loop:
  %v = phi i32 [ 0, %select.init ], [ %v.next, %select.inc ]
  %min.cur = phi i32 [ 2147483647, %select.init ], [ %min.next, %select.inc ]
  %u.cur = phi i32 [ -1, %select.init ], [ %u.next, %select.inc ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %select.iter, label %select.end

select.iter:
  %v.sext = sext i32 %v to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.v, 0
  br i1 %is.unvisited, label %select.cand, label %select.inc

select.cand:
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is.less = icmp slt i32 %dist.v, %min.cur
  %min.upd = select i1 %is.less, i32 %dist.v, i32 %min.cur
  %u.upd = select i1 %is.less, i32 %v, i32 %u.cur
  br label %select.inc

select.inc:
  %min.next = phi i32 [ %min.cur, %select.iter ], [ %min.upd, %select.cand ]
  %u.next = phi i32 [ %u.cur, %select.iter ], [ %u.upd, %select.cand ]
  %v.next = add nsw i32 %v, 1
  br label %select.loop

select.end:
  %u.sel = phi i32 [ %u.cur, %select.loop ]
  %u.is.neg1 = icmp eq i32 %u.sel, -1
  br i1 %u.is.neg1, label %print.init, label %mark.visited

mark.visited:
  %u.sext = sext i32 %u.sel to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.sext
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:
  %w = phi i32 [ 0, %mark.visited ], [ %w.next, %relax.inc ]
  %w.cmp = icmp slt i32 %w, %n
  br i1 %w.cmp, label %relax.iter, label %relax.end

relax.iter:
  %w.sext = sext i32 %w to i64
  ; weight = graph[u*100 + w]
  %u.mul100 = mul nsw i32 %u.sel, 100
  %idx.lin = add nsw i32 %u.mul100, %w
  %idx.lin.sext = sext i32 %idx.lin to i64
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.lin.sext
  %weight = load i32, i32* %edge.ptr, align 4
  %has.edge = icmp ne i32 %weight, 0
  br i1 %has.edge, label %relax.check.vis, label %relax.inc

relax.check.vis:
  %vis.w.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %w.sext
  %vis.w = load i32, i32* %vis.w.ptr, align 4
  %w.unvisited = icmp eq i32 %vis.w, 0
  br i1 %w.unvisited, label %relax.check.du, label %relax.inc

relax.check.du:
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.is.inf, label %relax.inc, label %relax.maybe

relax.maybe:
  %sum = add nsw i32 %dist.u, %weight
  %dist.w.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %w.sext
  %dist.w = load i32, i32* %dist.w.ptr, align 4
  %better = icmp slt i32 %sum, %dist.w
  br i1 %better, label %relax.update, label %relax.inc

relax.update:
  store i32 %sum, i32* %dist.w.ptr, align 4
  br label %relax.inc

relax.inc:
  %w.next = add nsw i32 %w, 1
  br label %relax.loop

relax.end:
  %cnt.next = add nsw i32 %cnt, 1
  br label %outer.header

print.init:
  br label %print.loop

print.loop:
  %p = phi i32 [ 0, %print.init ], [ %p.next, %print.inc ]
  %p.cmp = icmp slt i32 %p, %n
  br i1 %p.cmp, label %print.iter, label %ret

print.iter:
  %p.sext = sext i32 %p to i64
  %dist.p.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %p.sext
  %dist.p = load i32, i32* %dist.p.ptr, align 4
  %p.is.inf = icmp eq i32 %dist.p, 2147483647
  br i1 %p.is.inf, label %print.inf, label %print.val

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %p)
  br label %print.inc

print.val:
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %p, i32 %dist.p)
  br label %print.inc

print.inc:
  %p.next = add nsw i32 %p, 1
  br label %print.loop

ret:
  ret void
}