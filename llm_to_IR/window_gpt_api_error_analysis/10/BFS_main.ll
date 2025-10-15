; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

@str_fmt_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @bfs(i32* %adj, i64 %n, i64 %src, i64* %order_out, i64* %order_len_out, i32* %dist_out) {
entry:
  %visited = alloca i8, i64 %n, align 1
  %queue = alloca i64, i64 %n, align 8
  %i.addr = alloca i64, align 8
  store i64 0, i64* %i.addr, align 8
  br label %init.loop

init.loop:
  %i.load = load i64, i64* %i.addr, align 8
  %cmp.init = icmp ult i64 %i.load, %n
  br i1 %cmp.init, label %init.body, label %init.done

init.body:
  %v.ptr = getelementptr inbounds i8, i8* %visited, i64 %i.load
  store i8 0, i8* %v.ptr, align 1
  %d.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %i.load
  store i32 -1, i32* %d.ptr, align 4
  %i.next = add i64 %i.load, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %init.loop

init.done:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %count = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %count, align 8
  %src.inrange = icmp ult i64 %src, %n
  br i1 %src.inrange, label %src.ok, label %end

src.ok:
  %src.v.ptr = getelementptr inbounds i8, i8* %visited, i64 %src
  store i8 1, i8* %src.v.ptr, align 1
  %src.d.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %src
  store i32 0, i32* %src.d.ptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail0
  store i64 %src, i64* %q.enq.ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8
  br label %bfs.cond

bfs.cond:
  %head.cur = load i64, i64* %head, align 8
  %tail.cur = load i64, i64* %tail, align 8
  %has.items = icmp ult i64 %head.cur, %tail.cur
  br i1 %has.items, label %bfs.pop, label %bfs.done

bfs.pop:
  %q.pop.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.cur
  %v = load i64, i64* %q.pop.ptr, align 8
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head, align 8
  %cnt.cur = load i64, i64* %count, align 8
  %ord.ptr = getelementptr inbounds i64, i64* %order_out, i64 %cnt.cur
  store i64 %v, i64* %ord.ptr, align 8
  %cnt.next = add i64 %cnt.cur, 1
  store i64 %cnt.next, i64* %count, align 8
  %u.addr = alloca i64, align 8
  store i64 0, i64* %u.addr, align 8
  br label %u.loop

u.loop:
  %u.cur = load i64, i64* %u.addr, align 8
  %u.cmp = icmp ult i64 %u.cur, %n
  br i1 %u.cmp, label %u.body, label %u.done

u.body:
  %vn = mul i64 %v, %n
  %idx = add i64 %vn, %u.cur
  %a.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a.val = load i32, i32* %a.ptr, align 4
  %is.edge = icmp ne i32 %a.val, 0
  br i1 %is.edge, label %check.visit, label %u.inc

check.visit:
  %u.vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %u.cur
  %u.vis = load i8, i8* %u.vis.ptr, align 1
  %u.not.vis = icmp eq i8 %u.vis, 0
  br i1 %u.not.vis, label %enqueue.u, label %u.inc

enqueue.u:
  store i8 1, i8* %u.vis.ptr, align 1
  %dv.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %dv1 = add i32 %dv, 1
  %du.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %u.cur
  store i32 %dv1, i32* %du.ptr, align 4
  %t.cur = load i64, i64* %tail, align 8
  %q.enq2.ptr = getelementptr inbounds i64, i64* %queue, i64 %t.cur
  store i64 %u.cur, i64* %q.enq2.ptr, align 8
  %t.next = add i64 %t.cur, 1
  store i64 %t.next, i64* %tail, align 8
  br label %u.inc

u.inc:
  %u.next = add i64 %u.cur, 1
  store i64 %u.next, i64* %u.addr, align 8
  br label %u.loop

u.done:
  br label %bfs.cond

bfs.done:
  %cnt.final = load i64, i64* %count, align 8
  store i64 %cnt.final, i64* %order_len_out, align 8
  br label %end

end:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %src = alloca i64, align 8
  store i64 0, i64* %src, align 8
  %n.load = load i64, i64* %n, align 8
  %n2 = mul i64 %n.load, %n.load
  %adj = alloca i32, i64 %n2, align 16
  %i.z = alloca i64, align 8
  store i64 0, i64* %i.z, align 8
  br label %zero.loop

zero.loop:
  %i.cur = load i64, i64* %i.z, align 8
  %zcmp = icmp ult i64 %i.cur, %n2
  br i1 %zcmp, label %zero.body, label %zero.done

zero.body:
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %i.cur
  store i32 0, i32* %adj.ptr, align 4
  %i.next3 = add i64 %i.cur, 1
  store i64 %i.next3, i64* %i.z, align 8
  br label %zero.loop

zero.done:
  %n.reload = load i64, i64* %n, align 8
  %row0 = mul i64 0, %n.reload
  %idx01 = add i64 %row0, 1
  %p01 = getelementptr inbounds i32, i32* %adj, i64 %idx01
  store i32 1, i32* %p01, align 4
  %idx02 = add i64 %row0, 2
  %p02 = getelementptr inbounds i32, i32* %adj, i64 %idx02
  store i32 1, i32* %p02, align 4
  %row1 = mul i64 1, %n.reload
  %idx13 = add i64 %row1, 3
  %p13 = getelementptr inbounds i32, i32* %adj, i64 %idx13
  store i32 1, i32* %p13, align 4
  %idx14 = add i64 %row1, 4
  %p14 = getelementptr inbounds i32, i32* %adj, i64 %idx14
  store i32 1, i32* %p14, align 4
  %row2 = mul i64 2, %n.reload
  %idx25 = add i64 %row2, 5
  %p25 = getelementptr inbounds i32, i32* %adj, i64 %idx25
  store i32 1, i32* %p25, align 4
  %idx24 = add i64 %row2, 4
  %p24 = getelementptr inbounds i32, i32* %adj, i64 %idx24
  store i32 1, i32* %p24, align 4
  %row3 = mul i64 3, %n.reload
  %idx36 = add i64 %row3, 6
  %p36 = getelementptr inbounds i32, i32* %adj, i64 %idx36
  store i32 1, i32* %p36, align 4
  %row4 = mul i64 4, %n.reload
  %idx45 = add i64 %row4, 5
  %p45 = getelementptr inbounds i32, i32* %adj, i64 %idx45
  store i32 1, i32* %p45, align 4
  %row5 = mul i64 5, %n.reload
  %idx56 = add i64 %row5, 6
  %p56 = getelementptr inbounds i32, i32* %adj, i64 %idx56
  store i32 1, i32* %p56, align 4
  %dist = alloca i32, i64 %n.reload, align 16
  %order = alloca i64, i64 %n.reload, align 16
  %order_len = alloca i64, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj, i64 %n.reload, i64 %src.val, i64* %order, i64* %order_len, i32* %dist)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @str_fmt_bfs, i64 0, i64 0
  %src.print = load i64, i64* %src, align 8
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.bfs.ptr, i64 %src.print)
  %i.order = alloca i64, align 8
  store i64 0, i64* %i.order, align 8
  br label %order.loop

order.loop:
  %i.o.cur = load i64, i64* %i.order, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cmp.order = icmp ult i64 %i.o.cur, %len.cur
  br i1 %cmp.order, label %order.body, label %order.done

order.body:
  %next.idx = add i64 %i.o.cur, 1
  %is.not.last = icmp ult i64 %next.idx, %len.cur
  br i1 %is.not.last, label %use.space, label %use.empty

use.space:
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @str_space, i64 0, i64 0
  br label %sel.space

use.empty:
  %sp.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @str_empty, i64 0, i64 0
  br label %sel.space

sel.space:
  %phi.space = phi i8* [ %sp.ptr, %use.space ], [ %sp.empty.ptr, %use.empty ]
  %val.ptr = getelementptr inbounds i64, i64* %order, i64 %i.o.cur
  %val.load = load i64, i64* %val.ptr, align 8
  %fmt.zu.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @str_zu_s, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.zu.ptr, i64 %val.load, i8* %phi.space)
  %i.o.next = add i64 %i.o.cur, 1
  store i64 %i.o.next, i64* %i.order, align 8
  br label %order.loop

order.done:
  %nl = call i32 @putchar(i32 10)
  %i.dist = alloca i64, align 8
  store i64 0, i64* %i.dist, align 8
  br label %dist.loop

dist.loop:
  %i.d.cur = load i64, i64* %i.dist, align 8
  %cmp.dist = icmp ult i64 %i.d.cur, %n.reload
  br i1 %cmp.dist, label %dist.body, label %dist.done

dist.body:
  %d.ptr2 = getelementptr inbounds i32, i32* %dist, i64 %i.d.cur
  %d.val = load i32, i32* %d.ptr2, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @str_dist, i64 0, i64 0
  %src.print2 = load i64, i64* %src, align 8
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 %src.print2, i64 %i.d.cur, i32 %d.val)
  %i.d.next = add i64 %i.d.cur, 1
  store i64 %i.d.next, i64* %i.dist, align 8
  br label %dist.loop

dist.done:
  ret i32 0
}