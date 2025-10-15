; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

@.str1 = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str3 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %order_len) {
entry:
  %q = alloca i64, i64 %n, align 8
  %i = alloca i64, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %len = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %init.loop.cond

init.loop.cond:
  %i.val = load i64, i64* %i, align 8
  %cmp.init = icmp ult i64 %i.val, %n
  br i1 %cmp.init, label %init.loop.body, label %init.loop.end

init.loop.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.val
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %init.loop.cond

init.loop.end:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %len, align 8
  %start.dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %q.enq.ptr = getelementptr inbounds i64, i64* %q, i64 %tail0
  store i64 %start, i64* %q.enq.ptr, align 8
  %tail.next = add i64 %tail0, 1
  store i64 %tail.next, i64* %tail, align 8
  br label %bfs.outer.cond

bfs.outer.cond:
  %head.cur = load i64, i64* %head, align 8
  %tail.cur = load i64, i64* %tail, align 8
  %cmp.queue = icmp ult i64 %head.cur, %tail.cur
  br i1 %cmp.queue, label %bfs.outer.body, label %bfs.end

bfs.outer.body:
  %q.deq.ptr = getelementptr inbounds i64, i64* %q, i64 %head.cur
  %u = load i64, i64* %q.deq.ptr, align 8
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head, align 8
  %len.cur = load i64, i64* %len, align 8
  %order.ptr = getelementptr inbounds i64, i64* %order, i64 %len.cur
  store i64 %u, i64* %order.ptr, align 8
  %len.next = add i64 %len.cur, 1
  store i64 %len.next, i64* %len, align 8
  store i64 0, i64* %i, align 8
  br label %bfs.inner.cond

bfs.inner.cond:
  %v = load i64, i64* %i, align 8
  %cmp.v = icmp ult i64 %v, %n
  br i1 %cmp.v, label %bfs.inner.body, label %bfs.outer.cond

bfs.inner.body:
  %mul.un = mul i64 %u, %n
  %idx = add i64 %mul.un, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj.ptr, align 4
  %has.edge = icmp ne i32 %edge, 0
  br i1 %has.edge, label %check.unvisited, label %inner.next

check.unvisited:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is.unvisited = icmp eq i32 %dist.v, -1
  br i1 %is.unvisited, label %visit.v, label %inner.next

visit.v:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %tail.enq = load i64, i64* %tail, align 8
  %q.enq.v.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.enq
  store i64 %v, i64* %q.enq.v.ptr, align 8
  %tail.enq.next = add i64 %tail.enq, 1
  store i64 %tail.enq.next, i64* %tail, align 8
  br label %inner.next

inner.next:
  %v.next = add i64 %v, 1
  store i64 %v.next, i64* %i, align 8
  br label %bfs.inner.cond

bfs.end:
  %final.len = load i64, i64* %len, align 8
  store i64 %final.len, i64* %order_len, align 8
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  %adjarr = alloca [49 x i32], align 16
  %distarr = alloca [7 x i32], align 16
  %orderarr = alloca [7 x i64], align 16
  %orderlen = alloca i64, align 8
  store i64 0, i64* %orderlen, align 8
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %zero.loop.cond

zero.loop.cond:
  %i.val = load i64, i64* %i, align 8
  %cmp.zero = icmp ult i64 %i.val, 49
  br i1 %cmp.zero, label %zero.loop.body, label %zero.loop.end

zero.loop.body:
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adjarr, i64 0, i64 0
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %i.val
  store i32 0, i32* %adj.elem.ptr, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %zero.loop.cond

zero.loop.end:
  %n.val = load i64, i64* %n, align 8
  %adj.base2 = getelementptr inbounds [49 x i32], [49 x i32]* %adjarr, i64 0, i64 0
  ; Edge 0-1 and 1-0
  %idx01 = add i64 1, 0
  %p01 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx01
  store i32 1, i32* %p01, align 4
  %idx10.r = mul i64 1, %n.val
  %p10 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx10.r
  store i32 1, i32* %p10, align 4
  ; Edge 0-2 and 2-0
  %idx02 = add i64 2, 0
  %p02 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx02
  store i32 1, i32* %p02, align 4
  %idx20.r = mul i64 2, %n.val
  %p20 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx20.r
  store i32 1, i32* %p20, align 4
  ; Edge 1-3 and 3-1
  %idx13.r0 = mul i64 1, %n.val
  %idx13 = add i64 %idx13.r0, 3
  %p13 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx13
  store i32 1, i32* %p13, align 4
  %idx31.r0 = mul i64 3, %n.val
  %idx31 = add i64 %idx31.r0, 1
  %p31 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx31
  store i32 1, i32* %p31, align 4
  ; Edge 1-4 and 4-1
  %idx14.r0 = mul i64 1, %n.val
  %idx14 = add i64 %idx14.r0, 4
  %p14 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx14
  store i32 1, i32* %p14, align 4
  %idx41.r0 = mul i64 4, %n.val
  %idx41 = add i64 %idx41.r0, 1
  %p41 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx41
  store i32 1, i32* %p41, align 4
  ; Edge 2-5 and 5-2
  %idx25.r0 = mul i64 2, %n.val
  %idx25 = add i64 %idx25.r0, 5
  %p25 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx25
  store i32 1, i32* %p25, align 4
  %idx52.r0 = mul i64 5, %n.val
  %idx52 = add i64 %idx52.r0, 2
  %p52 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx52
  store i32 1, i32* %p52, align 4
  ; Edge 4-5 and 5-4
  %idx45.r0 = mul i64 4, %n.val
  %idx45 = add i64 %idx45.r0, 5
  %p45 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx45
  store i32 1, i32* %p45, align 4
  %idx54.r0 = mul i64 5, %n.val
  %idx54 = add i64 %idx54.r0, 4
  %p54 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx54
  store i32 1, i32* %p54, align 4
  ; Edge 5-6 and 6-5
  %idx56.r0 = mul i64 5, %n.val
  %idx56 = add i64 %idx56.r0, 6
  %p56 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx56
  store i32 1, i32* %p56, align 4
  %idx65.r0 = mul i64 6, %n.val
  %idx65 = add i64 %idx65.r0, 5
  %p65 = getelementptr inbounds i32, i32* %adj.base2, i64 %idx65
  store i32 1, i32* %p65, align 4
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %distarr, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %orderarr, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.base2, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %order.base, i64* %orderlen)
  %fmt1.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str1, i64 0, i64 0
  %printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %start.val)
  %i2 = alloca i64, align 8
  store i64 0, i64* %i2, align 8
  br label %print.loop.cond

print.loop.cond:
  %i2.val = load i64, i64* %i2, align 8
  %len.val = load i64, i64* %orderlen, align 8
  %cmp.pl = icmp ult i64 %i2.val, %len.val
  br i1 %cmp.pl, label %print.loop.body, label %print.loop.end

print.loop.body:
  %i2.plus1 = add i64 %i2.val, 1
  %cond.sep = icmp ult i64 %i2.plus1, %len.val
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %suffix = select i1 %cond.sep, i8* %spc.ptr, i8* %empty.ptr
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i2.val
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %ord.val, i8* %suffix)
  %i2.next = add i64 %i2.val, 1
  store i64 %i2.next, i64* %i2, align 8
  br label %print.loop.cond

print.loop.end:
  %nl = call i32 @putchar(i32 10)
  %j = alloca i64, align 8
  store i64 0, i64* %j, align 8
  br label %dist.loop.cond

dist.loop.cond:
  %j.val = load i64, i64* %j, align 8
  %cmp.dj = icmp ult i64 %j.val, %n.val
  br i1 %cmp.dj, label %dist.loop.body, label %dist.loop.end

dist.loop.body:
  %dist.ptr.v = getelementptr inbounds i32, i32* %dist.base, i64 %j.val
  %dist.v = load i32, i32* %dist.ptr.v, align 4
  %fmt3.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str3, i64 0, i64 0
  %printf3 = call i32 (i8*, ...) @printf(i8* %fmt3.ptr, i64 %start.val, i64 %j.val, i32 %dist.v)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist.loop.cond

dist.loop.end:
  ret i32 0
}