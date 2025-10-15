; ModuleID = 'dijkstra_module'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* nocapture %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %vis = alloca [100 x i32], align 16
  br label %init.loop

init.loop:                                        ; preds = %init.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i64 = sext i32 %i to i64
  %dist.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64
  store i32 2147483647, i32* %dist.ptr0, align 4
  %vis.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %i64
  store i32 0, i32* %vis.ptr0, align 4
  br label %init.inc

init.inc:                                         ; preds = %init.body
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %n_minus1 = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %count, %n_minus1
  br i1 %cond.outer, label %select.loop, label %print.init

select.loop:                                      ; preds = %select.inc, %outer.loop
  %min = phi i32 [ 2147483647, %outer.loop ], [ %min.sel, %select.inc ]
  %u = phi i32 [ -1, %outer.loop ], [ %u.sel, %select.inc ]
  %j = phi i32 [ 0, %outer.loop ], [ %j.next, %select.inc ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %select.check, label %select.done

select.check:                                     ; preds = %select.loop
  %j64 = sext i32 %j to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %j64
  %visj = load i32, i32* %vis.j.ptr, align 4
  %vis.is0 = icmp eq i32 %visj, 0
  br i1 %vis.is0, label %if.vis0, label %select.inc

if.vis0:                                          ; preds = %select.check
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j64
  %distj = load i32, i32* %dist.j.ptr, align 4
  %lt = icmp slt i32 %distj, %min
  br i1 %lt, label %update, label %select.inc

update:                                           ; preds = %if.vis0
  br label %select.inc

select.inc:                                       ; preds = %update, %if.vis0, %select.check
  %min.sel = phi i32 [ %min, %select.check ], [ %min, %if.vis0 ], [ %distj, %update ]
  %u.sel = phi i32 [ %u, %select.check ], [ %u, %if.vis0 ], [ %j, %update ]
  %j.next = add nsw i32 %j, 1
  br label %select.loop

select.done:                                      ; preds = %select.loop
  %min.final = phi i32 [ %min, %select.loop ]
  %u.final = phi i32 [ %u, %select.loop ]
  %u.neg1 = icmp eq i32 %u.final, -1
  br i1 %u.neg1, label %print.init, label %mark.vis

mark.vis:                                         ; preds = %select.done
  %u64 = sext i32 %u.final to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %u64
  store i32 1, i32* %vis.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.inc, %mark.vis
  %v = phi i32 [ 0, %mark.vis ], [ %v.next, %relax.inc ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %relax.body, label %outer.inc

relax.body:                                       ; preds = %relax.loop
  %v64 = sext i32 %v to i64
  %mul = mul nsw i64 %u64, 100
  %idx = add nsw i64 %mul, %v64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %g.ptr, align 4
  %w.zero = icmp eq i32 %w, 0
  br i1 %w.zero, label %relax.inc, label %check.visv

check.visv:                                       ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %vis, i64 0, i64 %v64
  %visv = load i32, i32* %vis.v.ptr, align 4
  %visv.is0 = icmp eq i32 %visv, 0
  br i1 %visv.is0, label %check.distu, label %relax.inc

check.distu:                                      ; preds = %check.visv
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %distu = load i32, i32* %dist.u.ptr, align 4
  %distu.isinf = icmp eq i32 %distu, 2147483647
  br i1 %distu.isinf, label %relax.inc, label %check.relax

check.relax:                                      ; preds = %check.distu
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %distv = load i32, i32* %dist.v.ptr, align 4
  %sum = add nsw i32 %distu, %w
  %cmp.relax = icmp sgt i32 %distv, %sum
  br i1 %cmp.relax, label %do.relax, label %relax.inc

do.relax:                                         ; preds = %check.relax
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %do.relax, %check.relax, %check.distu, %check.visv, %relax.body
  %v.next = add nsw i32 %v, 1
  br label %relax.loop

outer.inc:                                        ; preds = %relax.loop
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

print.init:                                       ; preds = %select.done, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %print.init
  %k = phi i32 [ 0, %print.init ], [ %k.next, %print.inc ]
  %k.cmp = icmp slt i32 %k, %n
  br i1 %k.cmp, label %print.body, label %exit

print.body:                                       ; preds = %print.loop
  %k64 = sext i32 %k to i64
  %dist.k.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %k64
  %distk = load i32, i32* %dist.k.ptr, align 4
  %isinfk = icmp eq i32 %distk, 2147483647
  br i1 %isinfk, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %k)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %k, i32 %distk)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %k.next = add nsw i32 %k, 1
  br label %print.loop

exit:                                             ; preds = %print.loop
  ret void
}