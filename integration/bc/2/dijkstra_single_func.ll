; ModuleID = 'dijkstra_single_func.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private constant [16 x i8] c"dist[%d] = INF\0A\00"
@.str_val = private constant [15 x i8] c"dist[%d] = %d\0A\00"

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %t = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 0, i32* %var4, align 4
  %fmt2_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %n_ptr = bitcast i32* %n to i8*
  %m_ptr = bitcast i32* %m to i8*
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2_ptr, i8* %n_ptr, i8* %m_ptr)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset_call = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %t, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %tval = load i32, i32* %t, align 4
  %mval = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %tval, %mval
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt3_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %i_ptr_i8 = bitcast i32* %i to i8*
  %j_ptr_i8 = bitcast i32* %j to i8*
  %w_ptr_i8 = bitcast i32* %w to i8*
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3_ptr, i8* %i_ptr_i8, i8* %j_ptr_i8, i8* %w_ptr_i8)
  %iv = load i32, i32* %i, align 4
  %jv = load i32, i32* %j, align 4
  %wv = load i32, i32* %w, align 4
  %iv64 = sext i32 %iv to i64
  %jv64 = sext i32 %jv to i64
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %iv64
  %elemPtr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %jv64
  store i32 %wv, i32* %elemPtr, align 4
  %rowptr_t = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %jv64
  %elemPtr_t = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr_t, i64 0, i64 %iv64
  store i32 %wv, i32* %elemPtr_t, align 4
  %tprev = load i32, i32* %t, align 4
  %tinc = add nsw i32 %tprev, 1
  store i32 %tinc, i32* %t, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt1_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %src_ptr_i8 = bitcast i32* %src to i8*
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1_ptr, i8* %src_ptr_i8)
  %s_i32 = bitcast [100 x [100 x i32]]* %s to i32*
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  call void @dijkstra(i32* %s_i32, i32 %nval, i32 %srcval)
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

init.loop:                                        ; preds = %init.latch, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp slt i32 %i.init, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.init.64 = sext i32 %i.init to i64
  %dist.ptr.init = getelementptr inbounds i32, i32* %dist, i64 %i.init.64
  store i32 2147483647, i32* %dist.ptr.init, align 4
  %visited.ptr.init = getelementptr inbounds i32, i32* %visited, i64 %i.init.64
  store i32 0, i32* %visited.ptr.init, align 4
  br label %init.latch

init.latch:                                       ; preds = %init.body
  %i.next = add nsw i32 %i.init, 1
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
  br i1 %outer.cmp, label %select.init, label %after.outer

select.init:                                      ; preds = %outer.loop
  br label %select.loop

select.loop:                                      ; preds = %select.latch, %select.init
  %v.sel = phi i32 [ 0, %select.init ], [ %v.sel.next, %select.latch ]
  %u.cur = phi i32 [ -1, %select.init ], [ %u.next, %select.latch ]
  %min.cur = phi i32 [ 2147483647, %select.init ], [ %min.next, %select.latch ]
  %sel.cmp = icmp slt i32 %v.sel, %n
  br i1 %sel.cmp, label %select.body, label %select.end

select.body:                                      ; preds = %select.loop
  %v.sel.64 = sext i32 %v.sel to i64
  %vis.v.ptr = getelementptr inbounds i32, i32* %visited, i64 %v.sel.64
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %is.unvisited = icmp eq i32 %vis.v, 0
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sel.64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is.less = icmp slt i32 %dist.v, %min.cur
  %cond.update = and i1 %is.unvisited, %is.less
  %min.next = select i1 %cond.update, i32 %dist.v, i32 %min.cur
  %u.next = select i1 %cond.update, i32 %v.sel, i32 %u.cur
  br label %select.latch

select.latch:                                     ; preds = %select.body
  %v.sel.next = add nsw i32 %v.sel, 1
  br label %select.loop

select.end:                                       ; preds = %select.loop
  %u.fin = phi i32 [ %u.cur, %select.loop ]
  %u.neg1 = icmp eq i32 %u.fin, -1
  br i1 %u.neg1, label %after.outer, label %relax.init

relax.init:                                       ; preds = %select.end
  %u.fin.64 = sext i32 %u.fin to i64
  %visited.u.ptr = getelementptr inbounds i32, i32* %visited, i64 %u.fin.64
  store i32 1, i32* %visited.u.ptr, align 4
  br label %relax.loop

relax.loop:                                       ; preds = %relax.latch, %relax.init
  %v.rel = phi i32 [ 0, %relax.init ], [ %v.rel.next, %relax.latch ]
  %rel.cmp = icmp slt i32 %v.rel, %n
  br i1 %rel.cmp, label %relax.body, label %outer.latch

relax.body:                                       ; preds = %relax.loop
  %v.rel.64 = sext i32 %v.rel to i64
  %u.mul = mul i64 %u.fin.64, 100
  %idx.linear = add i64 %u.mul, %v.rel.64
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
  br i1 %do.update, label %relax.update, label %relax.latch

relax.update:                                     ; preds = %relax.body
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax.latch

relax.latch:                                      ; preds = %relax.update, %relax.body
  %v.rel.next = add nsw i32 %v.rel, 1
  br label %relax.loop

outer.latch:                                      ; preds = %relax.loop
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

after.outer:                                      ; preds = %select.end, %outer.loop
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %after.outer
  %i.print = phi i32 [ 0, %after.outer ], [ %i.print.next, %print.latch ]
  %print.cmp = icmp slt i32 %i.print, %n
  br i1 %print.cmp, label %print.body, label %ret

print.body:                                       ; preds = %print.loop
  %i.print.64 = sext i32 %i.print to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.print.64
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %fmt.inf = bitcast i8* %fmt.inf.ptr to i8*
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %i.print)
  br label %print.latch

print.val:                                        ; preds = %print.body
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %fmt.val = bitcast i8* %fmt.val.ptr to i8*
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %i.print, i32 %dist.i)
  br label %print.latch

print.latch:                                      ; preds = %print.val, %print.inf
  %i.print.next = add nsw i32 %i.print, 1
  br label %print.loop

ret:                                              ; preds = %print.loop
  ret void
}

declare i32 @printf(i8*, ...)
