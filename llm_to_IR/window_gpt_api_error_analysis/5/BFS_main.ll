; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@.str0 = private unnamed_addr constant [22 x i8] c"BFS order from %zu: \00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str3 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str4 = private unnamed_addr constant [22 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define void @bfs(i32* nocapture %matrix, i64 %n, i64 %start, i64* nocapture %orderOut, i64* nocapture %orderLenOut, i32* nocapture %distOut) local_unnamed_addr {
entry:
  %visited = alloca i8, i64 %n, align 1
  %queue = alloca i64, i64 %n, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %len = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %len, align 8
  br label %init.loop

init.loop:                                         ; i = 0..n-1
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.cont ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %init.body, label %init.done

init.body:
  %dist.ptr = getelementptr inbounds i32, i32* %distOut, i64 %i
  store i32 -1, i32* %dist.ptr, align 4
  %vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %i
  store i8 0, i8* %vis.ptr, align 1
  br label %init.cont

init.cont:
  %i.next = add i64 %i, 1
  br label %init.loop

init.done:
  %start.vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %start
  store i8 1, i8* %start.vis.ptr, align 1
  %start.dist.ptr = getelementptr inbounds i32, i32* %distOut, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  %q.tail0 = load i64, i64* %tail, align 8
  %q.slot = getelementptr inbounds i64, i64* %queue, i64 %q.tail0
  store i64 %start, i64* %q.slot, align 8
  %q.tail1 = add i64 %q.tail0, 1
  store i64 %q.tail1, i64* %tail, align 8
  br label %bfs.while

bfs.while:
  %h.cur = load i64, i64* %head, align 8
  %t.cur = load i64, i64* %tail, align 8
  %has.elem = icmp ult i64 %h.cur, %t.cur
  br i1 %has.elem, label %deq.body, label %bfs.done

deq.body:
  %u.ptr = getelementptr inbounds i64, i64* %queue, i64 %h.cur
  %u = load i64, i64* %u.ptr, align 8
  %h.next = add i64 %h.cur, 1
  store i64 %h.next, i64* %head, align 8
  %len.cur = load i64, i64* %len, align 8
  %ord.slot = getelementptr inbounds i64, i64* %orderOut, i64 %len.cur
  store i64 %u, i64* %ord.slot, align 8
  %len.next = add i64 %len.cur, 1
  store i64 %len.next, i64* %len, align 8
  br label %for.v.loop

for.v.loop:
  %v = phi i64 [ 0, %deq.body ], [ %v.next, %for.v.cont ]
  %cmp.v = icmp ult i64 %v, %n
  br i1 %cmp.v, label %for.v.body, label %for.v.done

for.v.body:
  %mul.un = mul i64 %u, %n
  %idx = add i64 %mul.un, %v
  %a.ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %a.val = load i32, i32* %a.ptr, align 4
  %edge.exists = icmp ne i32 %a.val, 0
  %vis.v.ptr = getelementptr inbounds i8, i8* %visited, i64 %v
  %vis.v = load i8, i8* %vis.v.ptr, align 1
  %not.vis = icmp eq i8 %vis.v, 0
  %cond = and i1 %edge.exists, %not.vis
  br i1 %cond, label %enqueue, label %for.v.cont

enqueue:
  store i8 1, i8* %vis.v.ptr, align 1
  %dist.u.ptr = getelementptr inbounds i32, i32* %distOut, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.v.val = add i32 %dist.u, 1
  %dist.v.ptr = getelementptr inbounds i32, i32* %distOut, i64 %v
  store i32 %dist.v.val, i32* %dist.v.ptr, align 4
  %t.cur2 = load i64, i64* %tail, align 8
  %q.slot2 = getelementptr inbounds i64, i64* %queue, i64 %t.cur2
  store i64 %v, i64* %q.slot2, align 8
  %t.next2 = add i64 %t.cur2, 1
  store i64 %t.next2, i64* %tail, align 8
  br label %for.v.cont

for.v.cont:
  %v.next = add i64 %v, 1
  br label %for.v.loop

for.v.done:
  br label %bfs.while

bfs.done:
  %len.final = load i64, i64* %len, align 8
  store i64 %len.final, i64* %orderLenOut, align 8
  ret void
}

define i32 @main() local_unnamed_addr {
entry:
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %n.val = load i64, i64* %n, align 8
  %nn = mul i64 %n.val, %n.val
  %matrix.arr = alloca i32, i64 %nn, align 4
  %idx.init = alloca i64, align 8
  store i64 0, i64* %idx.init, align 8
  br label %zero.loop

zero.loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %zero.cont ]
  %cmp = icmp ult i64 %i, %nn
  br i1 %cmp, label %zero.body, label %zero.done

zero.body:
  %m.ptr = getelementptr inbounds i32, i32* %matrix.arr, i64 %i
  store i32 0, i32* %m.ptr, align 4
  br label %zero.cont

zero.cont:
  %i.next = add i64 %i, 1
  br label %zero.loop

zero.done:
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  %order = alloca i64, i64 %n.val, align 8
  %orderLen = alloca i64, align 8
  store i64 0, i64* %orderLen, align 8
  %dist = alloca i32, i64 %n.val, align 4

  ; Helper to set undirected edge (u,v): set A[u*n+v]=1 and A[v*n+u]=1
  ; We'll emit explicit stores for each required edge.

  ; Edge (0,1) and (1,0)
  %mul0 = mul i64 0, %n.val
  %idx01 = add i64 %mul0, 1
  %ptr01 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx01
  store i32 1, i32* %ptr01, align 4
  %mul1 = mul i64 1, %n.val
  %idx10 = add i64 %mul1, 0
  %ptr10 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx10
  store i32 1, i32* %ptr10, align 4

  ; Edge (0,2) and (2,0)
  %idx02 = add i64 %mul0, 2
  %ptr02 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx02
  store i32 1, i32* %ptr02, align 4
  %mul2 = mul i64 2, %n.val
  %idx20 = add i64 %mul2, 0
  %ptr20 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx20
  store i32 1, i32* %ptr20, align 4

  ; Edge (1,3) and (3,1)
  %idx13 = add i64 %mul1, 3
  %ptr13 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx13
  store i32 1, i32* %ptr13, align 4
  %mul3 = mul i64 3, %n.val
  %idx31 = add i64 %mul3, 1
  %ptr31 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx31
  store i32 1, i32* %ptr31, align 4

  ; Edge (1,4) and (4,1)
  %idx14 = add i64 %mul1, 4
  %ptr14 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx14
  store i32 1, i32* %ptr14, align 4
  %mul4 = mul i64 4, %n.val
  %idx41 = add i64 %mul4, 1
  %ptr41 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx41
  store i32 1, i32* %ptr41, align 4

  ; Edge (2,5) and (5,2)
  %idx25 = add i64 %mul2, 5
  %ptr25 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx25
  store i32 1, i32* %ptr25, align 4
  %mul5 = mul i64 5, %n.val
  %idx52 = add i64 %mul5, 2
  %ptr52 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx52
  store i32 1, i32* %ptr52, align 4

  ; Edge (4,5) and (5,4)
  %idx45 = add i64 %mul4, 5
  %ptr45 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx45
  store i32 1, i32* %ptr45, align 4
  %idx54 = add i64 %mul5, 4
  %ptr54 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx54
  store i32 1, i32* %ptr54, align 4

  ; Edge (5,6) and (6,5)
  %idx56 = add i64 %mul5, 6
  %ptr56 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx56
  store i32 1, i32* %ptr56, align 4
  %mul6 = mul i64 6, %n.val
  %idx65 = add i64 %mul6, 5
  %ptr65 = getelementptr inbounds i32, i32* %matrix.arr, i64 %idx65
  store i32 1, i32* %ptr65, align 4

  %start.v = load i64, i64* %start, align 8
  call void @bfs(i32* %matrix.arr, i64 %n.val, i64 %start.v, i64* %order, i64* %orderLen, i32* %dist)

  %fmt0.ptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str0, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0.ptr, i64 %start.v)
  %len.out = load i64, i64* %orderLen, align 8

  ; Print BFS order
  br label %print.loop

print.loop:
  %k = phi i64 [ 0, %zero.done ], [ %k.next, %print.cont ]
  %cmp.k = icmp ult i64 %k, %len.out
  br i1 %cmp.k, label %print.body, label %print.done

print.body:
  %k.plus1 = add i64 %k, 1
  %need.space = icmp ult i64 %k.plus1, %len.out
  %space.ptr.sel = select i1 %need.space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str3, i64 0, i64 0)
  %ord.k.ptr = getelementptr inbounds i64, i64* %order, i64 %k
  %ord.k = load i64, i64* %ord.k.ptr, align 8
  %fmt1.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %ord.k, i8* %space.ptr.sel)
  br label %print.cont

print.cont:
  %k.next = add i64 %k, 1
  br label %print.loop

print.done:
  %nl = call i32 @putchar(i32 10)

  ; Print distances
  br label %dist.loop

dist.loop:
  %didx = phi i64 [ 0, %print.done ], [ %didx.next, %dist.cont ]
  %cmp.d = icmp ult i64 %didx, %n.val
  br i1 %cmp.d, label %dist.body, label %dist.done

dist.body:
  %dval.ptr = getelementptr inbounds i32, i32* %dist, i64 %didx
  %dval = load i32, i32* %dval.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str4, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %start.v, i64 %didx, i32 %dval)
  br label %dist.cont

dist.cont:
  %didx.next = add i64 %didx, 1
  br label %dist.loop

dist.done:
  ret i32 0
}