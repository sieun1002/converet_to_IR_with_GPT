; ModuleID = 'dijkstra_single_func.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.dist = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 0, i32* %var4, align 4
  %fmt_two_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_two_ptr, i32* %n, i32* %m)
  %s_as_i8 = bitcast [10000 x i32]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_as_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt_three_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.three, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_three_ptr, i32* %u, i32* %v, i32* %w)
  %w.val = load i32, i32* %w, align 4
  %u.val = load i32, i32* %u, align 4
  %u.ext = sext i32 %u.val to i64
  %mul.row = mul nsw i64 %u.ext, 100
  %v.val = load i32, i32* %v, align 4
  %v.ext = sext i32 %v.val to i64
  %idx.uv = add nsw i64 %mul.row, %v.ext
  %elem.uv.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.uv
  store i32 %w.val, i32* %elem.uv.ptr, align 4
  %w2.val = load i32, i32* %w, align 4
  %v2.val = load i32, i32* %v, align 4
  %v2.ext = sext i32 %v2.val to i64
  %mul.row.v = mul nsw i64 %v2.ext, 100
  %u2.val = load i32, i32* %u, align 4
  %u2.ext = sext i32 %u2.val to i64
  %idx.vu = add nsw i64 %mul.row.v, %u2.ext
  %elem.vu.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.vu
  store i32 %w2.val, i32* %elem.vu.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt_one_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_one_ptr, i32* %src)
  %s.base = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* %s.base, i32 %n.load, i32 %src.load)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %graph.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %src.addr = alloca i32, align 4
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %iter = alloca i32, align 4
  %u = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %v = alloca i32, align 4
  store i32* %graph, i32** %graph.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 %src, i32* %src.addr, align 4
  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %cmp.init = icmp slt i32 %i.val, %n.val
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.sext = sext i32 %i.val to i64
  %dist.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.sext
  store i32 2147483647, i32* %dist.ptr0, align 4
  %vis.ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.sext
  store i32 0, i32* %vis.ptr0, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src.val = load i32, i32* %src.addr, align 4
  %src.sext = sext i32 %src.val to i64
  %dist.ptr.src = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src.sext
  store i32 0, i32* %dist.ptr.src, align 4
  store i32 0, i32* %iter, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %relax.end, %init.end
  %iter.val = load i32, i32* %iter, align 4
  %n.val2 = load i32, i32* %n.addr, align 4
  %n.minus1 = add nsw i32 %n.val2, -1
  %cmp.outer = icmp slt i32 %iter.val, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %after.outer

outer.body:                                       ; preds = %outer.cond
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %j, align 4
  br label %findmin.cond

findmin.cond:                                     ; preds = %findmin.inc, %outer.body
  %j.val = load i32, i32* %j, align 4
  %n.val3 = load i32, i32* %n.addr, align 4
  %cmp.j = icmp slt i32 %j.val, %n.val3
  br i1 %cmp.j, label %findmin.body, label %findmin.end

findmin.body:                                     ; preds = %findmin.cond
  %j.sext = sext i32 %j.val to i64
  %vis.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %j.sext
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %vis.zero = icmp eq i32 %vis.j, 0
  br i1 %vis.zero, label %check.min, label %findmin.inc

check.min:                                        ; preds = %findmin.body
  %dist.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %j.sext
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %min.val = load i32, i32* %min, align 4
  %cmp.min = icmp slt i32 %dist.j, %min.val
  br i1 %cmp.min, label %update.min, label %findmin.inc

update.min:                                       ; preds = %check.min
  store i32 %dist.j, i32* %min, align 4
  store i32 %j.val, i32* %u, align 4
  br label %findmin.inc

findmin.inc:                                      ; preds = %update.min, %check.min, %findmin.body
  %j.next = add nsw i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %findmin.cond

findmin.end:                                      ; preds = %findmin.cond
  %u.val = load i32, i32* %u, align 4
  %cmp.u = icmp eq i32 %u.val, -1
  br i1 %cmp.u, label %after.outer, label %cont1

cont1:                                            ; preds = %findmin.end
  %u.sext = sext i32 %u.val to i64
  %vis.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.sext
  store i32 1, i32* %vis.u.ptr, align 4
  store i32 0, i32* %v, align 4
  br label %relax.cond

relax.cond:                                       ; preds = %relax.inc, %cont1
  %v.val = load i32, i32* %v, align 4
  %n.val4 = load i32, i32* %n.addr, align 4
  %cmp.v = icmp slt i32 %v.val, %n.val4
  br i1 %cmp.v, label %relax.body, label %relax.end

relax.body:                                       ; preds = %relax.cond
  %v.sext = sext i32 %v.val to i64
  %u.curr = load i32, i32* %u, align 4
  %u64 = sext i32 %u.curr to i64
  %mul.row = mul nsw i64 %u64, 100
  %idx = add nsw i64 %mul.row, %v.sext
  %graph.base = load i32*, i32** %graph.addr, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %graph.base, i64 %idx
  %w = load i32, i32* %elem.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %relax.inc, label %check.visited.v

check.visited.v:                                  ; preds = %relax.body
  %vis.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.sext
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.v.zero = icmp eq i32 %vis.v, 0
  br i1 %vis.v.zero, label %check.distu.inf, label %relax.inc

check.distu.inf:                                  ; preds = %check.visited.v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.inf, label %relax.inc, label %calc.alt

calc.alt:                                         ; preds = %check.distu.inf
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmp.dv = icmp sgt i32 %dist.v, %sum
  br i1 %cmp.dv, label %update.dv, label %relax.inc

update.dv:                                        ; preds = %calc.alt
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %relax.inc

relax.inc:                                        ; preds = %update.dv, %calc.alt, %check.distu.inf, %check.visited.v, %relax.body
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %relax.cond

relax.end:                                        ; preds = %relax.cond
  %iter.next = add nsw i32 %iter.val, 1
  store i32 %iter.next, i32* %iter, align 4
  br label %outer.cond

after.outer:                                      ; preds = %findmin.end, %outer.cond
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:                                       ; preds = %print.inc, %after.outer
  %i2 = load i32, i32* %i, align 4
  %n.val5 = load i32, i32* %n.addr, align 4
  %cmp.i = icmp slt i32 %i2, %n.val5
  br i1 %cmp.i, label %print.body, label %return

print.body:                                       ; preds = %print.cond
  %i2.sext = sext i32 %i2 to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i2.sext
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print.inf, label %print.val

print.inf:                                        ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %i.arg.inf = load i32, i32* %i, align 4
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.arg.inf)
  br label %print.inc

print.val:                                        ; preds = %print.body
  %fmt.val.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.dist, i64 0, i64 0
  %i.arg.val = load i32, i32* %i, align 4
  %dist.i2 = load i32, i32* %dist.i.ptr, align 4
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %i.arg.val, i32 %dist.i2)
  br label %print.inc

print.inc:                                        ; preds = %print.val, %print.inf
  %i.next2 = add nsw i32 %i2, 1
  store i32 %i.next2, i32* %i, align 4
  br label %print.cond

return:                                           ; preds = %print.cond
  ret void
}

declare i32 @printf(i8*, ...)
