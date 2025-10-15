; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.perczu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_len) {
entry:
  %queue = alloca i64, i64 %n, align 8
  br label %init

init:
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.body ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %init.body, label %init.end

init.body:
  %dptr.init = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dptr.init, align 4
  %i.next = add i64 %i, 1
  br label %init

init.end:
  %dptr.start = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dptr.start, align 4
  %order.first.ptr = getelementptr inbounds i64, i64* %order, i64 0
  store i64 %start, i64* %order.first.ptr, align 8
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  br label %bfs.loop

bfs.loop:
  %head = phi i64 [ 0, %init.end ], [ %head.next, %bfs.after.vloop ]
  %tail = phi i64 [ 1, %init.end ], [ %tail.updated.lift, %bfs.after.vloop ]
  %len = phi i64 [ 1, %init.end ], [ %len.updated.lift, %bfs.after.vloop ]
  %notempty = icmp ult i64 %head, %tail
  br i1 %notempty, label %dequeue, label %done

dequeue:
  %q.h.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q.h.ptr, align 8
  %head.next = add i64 %head, 1
  br label %v.loop

v.loop:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %v.loop ]
  %curr.len = phi i64 [ %len, %dequeue ], [ %len.updated, %v.loop ]
  %curr.tail = phi i64 [ %tail, %dequeue ], [ %tail.updated, %v.loop ]
  %v.cmp = icmp ult i64 %v, %n
  br i1 %v.cmp, label %v.body, label %bfs.after.vloop

v.body:
  %mul.un = mul i64 %u, %n
  %idx = add i64 %mul.un, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %adj.ptr, align 4
  %isEdge = icmp ne i32 %aval, 0
  %dptr.v = getelementptr inbounds i32, i32* %dist, i64 %v
  %dval.v = load i32, i32* %dptr.v, align 4
  %unseen = icmp eq i32 %dval.v, -1
  %ok = and i1 %isEdge, %unseen
  br i1 %ok, label %discover, label %skip

discover:
  %dptr.u = getelementptr inbounds i32, i32* %dist, i64 %u
  %dval.u = load i32, i32* %dptr.u, align 4
  %dplus1 = add i32 %dval.u, 1
  store i32 %dplus1, i32* %dptr.v, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %queue, i64 %curr.tail
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.new = add i64 %curr.tail, 1
  %order.ptr = getelementptr inbounds i64, i64* %order, i64 %curr.len
  store i64 %v, i64* %order.ptr, align 8
  %len.new = add i64 %curr.len, 1
  br label %advance

skip:
  br label %advance

advance:
  %len.updated = phi i64 [ %len.new, %discover ], [ %curr.len, %skip ]
  %tail.updated = phi i64 [ %tail.new, %discover ], [ %curr.tail, %skip ]
  %v.next = add i64 %v, 1
  br label %v.loop

bfs.after.vloop:
  %len.updated.lift = phi i64 [ %len.updated, %v.loop ]
  %tail.updated.lift = phi i64 [ %tail.updated, %v.loop ]
  br label %bfs.loop

done:
  store i64 %len, i64* %out_len, align 8
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %n = add i64 0, 7
  %adj = alloca i32, i64 49, align 16
  %dist = alloca i32, i64 7, align 16
  %order = alloca i64, i64 7, align 16
  %order_len = alloca i64, align 8
  br label %zero.loop

zero.loop:
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcmp = icmp ult i64 %zi, 49
  br i1 %zcmp, label %zero.body, label %zero.end

zero.body:
  %zptr = getelementptr inbounds i32, i32* %adj, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.end:
  ; Set undirected edges for the graph
  ; Edge 0-1
  %idx01a.m = mul i64 0, %n
  %idx01a = add i64 %idx01a.m, 1
  %ptr01a = getelementptr inbounds i32, i32* %adj, i64 %idx01a
  store i32 1, i32* %ptr01a, align 4
  %idx01b.m = mul i64 1, %n
  %idx01b = add i64 %idx01b.m, 0
  %ptr01b = getelementptr inbounds i32, i32* %adj, i64 %idx01b
  store i32 1, i32* %ptr01b, align 4
  ; Edge 0-2
  %idx02a.m = mul i64 0, %n
  %idx02a = add i64 %idx02a.m, 2
  %ptr02a = getelementptr inbounds i32, i32* %adj, i64 %idx02a
  store i32 1, i32* %ptr02a, align 4
  %idx02b.m = mul i64 2, %n
  %idx02b = add i64 %idx02b.m, 0
  %ptr02b = getelementptr inbounds i32, i32* %adj, i64 %idx02b
  store i32 1, i32* %ptr02b, align 4
  ; Edge 1-3
  %idx13a.m = mul i64 1, %n
  %idx13a = add i64 %idx13a.m, 3
  %ptr13a = getelementptr inbounds i32, i32* %adj, i64 %idx13a
  store i32 1, i32* %ptr13a, align 4
  %idx13b.m = mul i64 3, %n
  %idx13b = add i64 %idx13b.m, 1
  %ptr13b = getelementptr inbounds i32, i32* %adj, i64 %idx13b
  store i32 1, i32* %ptr13b, align 4
  ; Edge 1-4
  %idx14a.m = mul i64 1, %n
  %idx14a = add i64 %idx14a.m, 4
  %ptr14a = getelementptr inbounds i32, i32* %adj, i64 %idx14a
  store i32 1, i32* %ptr14a, align 4
  %idx14b.m = mul i64 4, %n
  %idx14b = add i64 %idx14b.m, 1
  %ptr14b = getelementptr inbounds i32, i32* %adj, i64 %idx14b
  store i32 1, i32* %ptr14b, align 4
  ; Edge 2-5
  %idx25a.m = mul i64 2, %n
  %idx25a = add i64 %idx25a.m, 5
  %ptr25a = getelementptr inbounds i32, i32* %adj, i64 %idx25a
  store i32 1, i32* %ptr25a, align 4
  %idx25b.m = mul i64 5, %n
  %idx25b = add i64 %idx25b.m, 2
  %ptr25b = getelementptr inbounds i32, i32* %adj, i64 %idx25b
  store i32 1, i32* %ptr25b, align 4
  ; Edge 4-5
  %idx45a.m = mul i64 4, %n
  %idx45a = add i64 %idx45a.m, 5
  %ptr45a = getelementptr inbounds i32, i32* %adj, i64 %idx45a
  store i32 1, i32* %ptr45a, align 4
  %idx45b.m = mul i64 5, %n
  %idx45b = add i64 %idx45b.m, 4
  %ptr45b = getelementptr inbounds i32, i32* %adj, i64 %idx45b
  store i32 1, i32* %ptr45b, align 4
  ; Edge 5-6
  %idx56a.m = mul i64 5, %n
  %idx56a = add i64 %idx56a.m, 6
  %ptr56a = getelementptr inbounds i32, i32* %adj, i64 %idx56a
  store i32 1, i32* %ptr56a, align 4
  %idx56b.m = mul i64 6, %n
  %idx56b = add i64 %idx56b.m, 5
  %ptr56b = getelementptr inbounds i32, i32* %adj, i64 %idx56b
  store i32 1, i32* %ptr56b, align 4
  %order_len.init = getelementptr inbounds i64, i64* %order_len, i64 0
  store i64 0, i64* %order_len.init, align 8
  call void @bfs(i32* %adj, i64 %n, i64 0, i32* %dist, i64* %order, i64* %order_len)
  %fmt1.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 0)
  %olen = load i64, i64* %order_len, align 8
  br label %print.loop

print.loop:
  %pi = phi i64 [ 0, %zero.end ], [ %pi.next, %print.body ]
  %pcmp = icmp ult i64 %pi, %olen
  br i1 %pcmp, label %print.body, label %after.print

print.body:
  %pi.plus1 = add i64 %pi, 1
  %hasnext = icmp ult i64 %pi.plus1, %olen
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %hasnext, i8* %space.ptr, i8* %empty.ptr
  %optr = getelementptr inbounds i64, i64* %order, i64 %pi
  %oval = load i64, i64* %optr, align 8
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.perczu_s, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %oval, i8* %suffix)
  %pi.next = add i64 %pi, 1
  br label %print.loop

after.print:
  %nl = call i32 @putchar(i32 10)
  br label %dist.loop

dist.loop:
  %vi = phi i64 [ 0, %after.print ], [ %vi.next, %dist.body ]
  %vcmp = icmp ult i64 %vi, %n
  br i1 %vcmp, label %dist.body, label %retblk

dist.body:
  %dptr = getelementptr inbounds i32, i32* %dist, i64 %vi
  %dval = load i32, i32* %dptr, align 4
  %fmt3.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt3.ptr, i64 0, i64 %vi, i32 %dval)
  %vi.next = add i64 %vi, 1
  br label %dist.loop

retblk:
  ret i32 0
}