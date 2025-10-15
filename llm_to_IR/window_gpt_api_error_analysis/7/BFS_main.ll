; ModuleID = 'bfs_windows_msvc'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %src, i32* nocapture %dist, i64* nocapture %order, i64* nocapture %order_len) local_unnamed_addr {
entry:
  %visited = alloca i8, i64 %n, align 1
  %queue = alloca i64, i64 %n, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %visited.i8 = bitcast i8* %visited to i8*
  call void @llvm.memset.p0i8.i64(i8* %visited.i8, i8 0, i64 %n, i1 false)
  br label %dist.init

dist.init:                                        ; preds = %dist.init, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %dist.body ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %dist.body, label %after.init

dist.body:                                        ; preds = %dist.init
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.elem.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist.init

after.init:                                       ; preds = %dist.init
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  %src.vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %src
  store i8 1, i8* %src.vis.ptr, align 1
  store i64 0, i64* %head, align 8
  store i64 1, i64* %tail, align 8
  %q0.ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %src, i64* %q0.ptr, align 8
  store i64 0, i64* %order_len, align 8
  br label %bfs.loop

bfs.loop:                                         ; preds = %for.v, %after.init
  %head.val = load i64, i64* %head, align 8
  %tail.val = load i64, i64* %tail, align 8
  %notEmpty = icmp ult i64 %head.val, %tail.val
  br i1 %notEmpty, label %dequeue, label %done

dequeue:                                          ; preds = %bfs.loop
  %u.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.val
  %u = load i64, i64* %u.ptr, align 8
  %head.next = add i64 %head.val, 1
  store i64 %head.next, i64* %head, align 8
  %olen = load i64, i64* %order_len, align 8
  %ord.slot = getelementptr inbounds i64, i64* %order, i64 %olen
  store i64 %u, i64* %ord.slot, align 8
  %olen.next = add i64 %olen, 1
  store i64 %olen.next, i64* %order_len, align 8
  br label %for.v

for.v:                                            ; preds = %for.v.cont, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %for.v.cont ]
  %cmpv = icmp ult i64 %v, %n
  br i1 %cmpv, label %for.v.body, label %bfs.loop

for.v.body:                                       ; preds = %for.v
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %isEdge = icmp ne i32 %adj.val, 0
  br i1 %isEdge, label %check.visited, label %for.v.cont

check.visited:                                    ; preds = %for.v.body
  %vis.v.ptr = getelementptr inbounds i8, i8* %visited, i64 %v
  %was = load i8, i8* %vis.v.ptr, align 1
  %isNew = icmp eq i8 %was, 0
  br i1 %isNew, label %enqueue, label %for.v.cont

enqueue:                                          ; preds = %check.visited
  store i8 1, i8* %vis.v.ptr, align 1
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du1 = add i32 %du, 1
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  store i32 %du1, i32* %dv.ptr, align 4
  %tail.cur = load i64, i64* %tail, align 8
  %qv.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %qv.ptr, align 8
  %tail.next = add i64 %tail.cur, 1
  store i64 %tail.next, i64* %tail, align 8
  br label %for.v.cont

for.v.cont:                                       ; preds = %enqueue, %check.visited, %for.v.body
  %v.next = add i64 %v, 1
  br label %for.v

done:                                             ; preds = %bfs.loop
  ret void
}

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj.arr = alloca [49 x i32], align 16
  %dist.arr = alloca [7 x i32], align 16
  %order.arr = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj.ptr = bitcast [49 x i32]* %adj.arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.ptr, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj.arr, i64 0, i64 0
  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1.ptr, align 4
  %idx7.ptr = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %idx7.ptr, align 4
  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2.ptr, align 4
  %idx14.ptr = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %idx14.ptr, align 4
  %idx10.ptr = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx10.ptr, align 4
  %idx22.ptr = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx22.ptr, align 4
  %idx11.ptr = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx11.ptr, align 4
  %idx29.ptr = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx29.ptr, align 4
  %idx19.ptr = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx19.ptr, align 4
  %idx37.ptr = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx37.ptr, align 4
  %idx33.ptr = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx33.ptr, align 4
  %idx39.ptr = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx39.ptr, align 4
  %idx41.ptr = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx41.ptr, align 4
  %idx47.ptr = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx47.ptr, align 4
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist.arr, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order.arr, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.hdr = call i32 (i8*, ...) @printf(i8* %fmt.bfs.ptr, i64 0)
  store i64 0, i64* %order_len, align 8
  %olen.load0 = load i64, i64* %order_len, align 8
  br label %loadolen

loadolen:                                         ; preds = %print.item, %entry
  %olen.cur = load i64, i64* %order_len, align 8
  br label %loop.init

loop.init:                                        ; preds = %loop.inc, %loadolen
  %i = phi i64 [ 0, %loadolen ], [ %i.next, %loop.inc ]
  %olen = phi i64 [ %olen.cur, %loadolen ], [ %olen.next2, %loop.inc ]
  %olen.real = load i64, i64* %order_len, align 8
  %cmp.start = icmp ult i64 %i, %olen.real
  br i1 %cmp.start, label %print.item, label %after.items

print.item:                                       ; preds = %loop.init
  %i.plus = add i64 %i, 1
  %olen.now = load i64, i64* %order_len, align 8
  %has.space = icmp ult i64 %i.plus, %olen.now
  %suffix.ptr = select i1 %has.space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %ord.i.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i
  %ord.val = load i64, i64* %ord.i.ptr, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %ord.val, i8* %suffix.ptr)
  br label %loop.inc

loop.inc:                                         ; preds = %print.item
  %i.next = add i64 %i, 1
  %olen.next2 = load i64, i64* %order_len, align 8
  br label %loop.init

after.items:                                      ; preds = %loop.init
  %nl = call i32 @putchar(i32 10)
  br label %dist.loop.entry

dist.loop.entry:                                  ; preds = %dist.loop.inc, %after.items
  %v = phi i64 [ 0, %after.items ], [ %v.next, %dist.loop.inc ]
  %cmp.v = icmp ult i64 %v, 7
  br i1 %cmp.v, label %dist.loop.body, label %ret

dist.loop.body:                                   ; preds = %dist.loop.entry
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 0, i64 %v, i32 %d.val)
  br label %dist.loop.inc

dist.loop.inc:                                    ; preds = %dist.loop.body
  %v.next = add i64 %v, 1
  br label %dist.loop.entry

ret:                                              ; preds = %dist.loop.entry
  ret i32 0
}