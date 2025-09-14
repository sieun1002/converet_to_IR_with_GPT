; ModuleID = 'dijkstra'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.inc, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %cmp.init = icmp slt i32 %i.init, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.init64 = sext i32 %i.init to i64
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.init64
  store i32 2147483647, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i.init64
  store i32 0, i32* %vis.ptr, align 4
  br label %init.inc

init.inc:                                         ; preds = %init.body
  %i.next = add nsw i32 %i.init, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp sge i32 %count, %nminus1
  br i1 %cmp.outer, label %print.init, label %select.loop

select.loop:                                      ; preds = %select.next, %outer.loop
  %v.sel = phi i32 [ 0, %outer.loop ], [ %v.next, %select.next ]
  %u.cur = phi i32 [ -1, %outer.loop ], [ %u.new, %select.next ]
  %min.cur = phi i32 [ 2147483647, %outer.loop ], [ %min.new, %select.next ]
  %cond.sel = icmp slt i32 %v.sel, %n
  br i1 %cond.sel, label %select.body, label %select.end

select.body:                                      ; preds = %select.loop
  %v.sel64 = sext i32 %v.sel to i64
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v.sel64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %unvisited = icmp eq i32 %vis.v, 0
  br i1 %unvisited, label %sel.check.dist, label %select.keep

sel.check.dist:                                   ; preds = %select.body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sel64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  br i1 %lt.min, label %select.set, label %select.keep

select.keep:                                      ; preds = %sel.check.dist, %select.body
  br label %select.next

select.set:                                       ; preds = %sel.check.dist
  br label %select.next

select.next:                                      ; preds = %select.set, %select.keep
  %u.new = phi i32 [ %u.cur, %select.keep ], [ %v.sel, %select.set ]
  %min.new = phi i32 [ %min.cur, %select.keep ], [ %dist.v, %select.set ]
  %v.next = add nsw i32 %v.sel, 1
  br label %select.loop

select.end:                                       ; preds = %select.loop
  %u.sel = phi i32 [ %u.cur, %select.loop ]
  %break = icmp eq i32 %u.sel, -1
  br i1 %break, label %print.init, label %relax.init

relax.init:                                       ; preds = %select.end
  %u.sel64 = sext i32 %u.sel to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u.sel64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.next, %relax.init
  %v.rel = phi i32 [ 0, %relax.init ], [ %v.rel.next, %relax.next ]
  %cond.rel = icmp slt i32 %v.rel, %n
  br i1 %cond.rel, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v.rel64 = sext i32 %v.rel to i64
  %u.idx64 = sext i32 %u.sel to i64
  %u.times100 = mul nsw i64 %u.idx64, 100
  %idx.flat = add nsw i64 %u.times100, %v.rel64
  %g.elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.flat
  %w = load i32, i32* %g.elem.ptr, align 4
  %has.edge = icmp ne i32 %w, 0
  br i1 %has.edge, label %check.vis, label %relax.next

check.vis:                                        ; preds = %relax.body
  %vis.v.ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v.rel64
  %vis.v2 = load i32, i32* %vis.v.ptr2, align 4
  %unvisited2 = icmp eq i32 %vis.v2, 0
  br i1 %unvisited2, label %check.distu, label %relax.next

check.distu:                                      ; preds = %check.vis
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u.sel64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.not.inf = icmp ne i32 %dist.u, 2147483647
  br i1 %u.not.inf, label %calc.new, label %relax.next

calc.new:                                         ; preds = %check.distu
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.rel64
  %dist.v2 = load i32, i32* %dist.v.ptr2, align 4
  %better = icmp sgt i32 %dist.v2, %sum
  br i1 %better, label %update, label %relax.next

update:                                           ; preds = %calc.new
  store i32 %sum, i32* %dist.v.ptr2, align 4
  br label %relax.next

relax.next:                                       ; preds = %update, %calc.new, %check.distu, %check.vis, %relax.body
  %v.rel.next = add nsw i32 %v.rel, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

print.init:                                       ; preds = %select.end, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.init
  %i.pr = phi i32 [ 0, %print.init ], [ %i.next2, %print.inc ]
  %cond.print = icmp slt i32 %i.pr, %n
  br i1 %cond.print, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %i.pr64 = sext i32 %i.pr to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.pr64
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i.pr)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i.pr, i32 %dist.i)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %i.next2 = add nsw i32 %i.pr, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}