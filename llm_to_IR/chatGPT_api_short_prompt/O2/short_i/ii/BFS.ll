; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: BFS on a fixed 7-node undirected graph; print BFS order from 0 and distances (confidence=0.96). Evidence: queue-based neighbor scan with dist=-1 check; prints "%zu%s" order and "dist(%zu -> %zu) = %d\n".
; Preconditions: none
; Postconditions: returns 0 after printing

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@adj = internal constant [7 x [7 x i32]] [
  [7 x i32] [ i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 1, i32 0, i32 0, i32 1, i32 0, i32 1, i32 0 ],
  [7 x i32] [ i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0 ],
  [7 x i32] [ i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0 ],
  [7 x i32] [ i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1 ],
  [7 x i32] [ i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0 ]
], align 16

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue = alloca i64*, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %olen = alloca i64, align 8
  ; dist[i] = -1
  br label %init.loop

init.loop:                                          ; preds = %init.loop, %entry
  %i = phi i64 [ 0, %entry ], [ %inc.i, %init.loop ]
  %dst.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dst.ptr, align 4
  %inc.i = add nuw nsw i64 %i, 1
  %cont.i = icmp ult i64 %inc.i, 7
  br i1 %cont.i, label %init.loop, label %init.done

init.done:                                          ; preds = %init.loop
  ; malloc queue (7 * sizeof(size_t))
  %m = call noalias i8* @malloc(i64 56)
  %q = bitcast i8* %m to i64*
  store i64 0, i64* %head, align 8
  store i64 0, i64* %olen, align 8
  store i64* %q, i64** %queue, align 8
  ; if malloc failed, set tail=0 to skip BFS safely
  %isnull = icmp eq i64* %q, null
  br i1 %isnull, label %set_tail0, label %init.queue

set_tail0:                                          ; preds = %init.done
  store i64 0, i64* %tail, align 8
  br label %bfs.start

init.queue:                                         ; preds = %init.done
  ; dist[0]=0; queue[0]=0; tail=1
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 0, i64* %q0, align 8
  store i64 1, i64* %tail, align 8
  br label %bfs.start

bfs.start:                                          ; preds = %set_tail0, %init.queue
  br label %while.cond

while.cond:                                         ; preds = %while.body.end, %bfs.start
  %h = load i64, i64* %head, align 8
  %t = load i64, i64* %tail, align 8
  %more = icmp ult i64 %h, %t
  br i1 %more, label %while.body, label %while.end

while.body:                                         ; preds = %while.cond
  %qp = load i64*, i64** %queue, align 8
  %q.cur.ptr = getelementptr inbounds i64, i64* %qp, i64 %h
  %node = load i64, i64* %q.cur.ptr, align 8
  %h.next = add i64 %h, 1
  store i64 %h.next, i64* %head, align 8
  ; order[olen++] = node
  %ol = load i64, i64* %olen, align 8
  %o.slot = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ol
  store i64 %node, i64* %o.slot, align 8
  %ol.next = add i64 %ol, 1
  store i64 %ol.next, i64* %olen, align 8
  ; for j=0..6
  br label %forj.cond

forj.cond:                                          ; preds = %forj.inc, %while.body
  %j = phi i64 [ 0, %while.body ], [ %j.next, %forj.inc ]
  %j.lt = icmp ult i64 %j, 7
  br i1 %j.lt, label %forj.body, label %while.body.end

forj.body:                                          ; preds = %forj.cond
  ; adj[node][j]
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %node
  %cell = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %j
  %aval = load i32, i32* %cell, align 4
  %has = icmp ne i32 %aval, 0
  br i1 %has, label %check.unseen, label %forj.inc

check.unseen:                                       ; preds = %forj.body
  %d.j.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %d.j = load i32, i32* %d.j.ptr, align 4
  %is.unseen = icmp eq i32 %d.j, -1
  br i1 %is.unseen, label %enqueue, label %forj.inc

enqueue:                                            ; preds = %check.unseen
  ; queue[tail++] = j
  %t.cur = load i64, i64* %tail, align 8
  %qp2 = load i64*, i64** %queue, align 8
  %slot = getelementptr inbounds i64, i64* %qp2, i64 %t.cur
  store i64 %j, i64* %slot, align 8
  %t.next = add i64 %t.cur, 1
  store i64 %t.next, i64* %tail, align 8
  ; dist[j] = dist[node] + 1
  %d.node.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %node
  %d.node = load i32, i32* %d.node.ptr, align 4
  %d.new = add nsw i32 %d.node, 1
  store i32 %d.new, i32* %d.j.ptr, align 4
  br label %forj.inc

forj.inc:                                           ; preds = %enqueue, %check.unseen, %forj.body
  %j.next = add nuw nsw i64 %j, 1
  br label %forj.cond

while.body.end:                                     ; preds = %forj.cond
  br label %while.cond

while.end:                                          ; preds = %while.cond
  ; free(queue) if non-null
  %qp3 = load i64*, i64** %queue, align 8
  %nn = icmp ne i64* %qp3, null
  br i1 %nn, label %do.free, label %after.free

do.free:                                            ; preds = %while.end
  %q8 = bitcast i64* %qp3 to i8*
  call void @free(i8* %q8)
  br label %after.free

after.free:                                         ; preds = %do.free, %while.end
  ; print header
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %r0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)
  ; print order items
  br label %print.loop

print.loop:                                         ; preds = %print.loop, %after.free
  %k = phi i64 [ 0, %after.free ], [ %k.next, %print.loop ]
  %ol.cur = load i64, i64* %olen, align 8
  %done = icmp uge i64 %k, %ol.cur
  br i1 %done, label %after.items, label %do.item

do.item:                                            ; preds = %print.loop
  %item.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %k
  %item = load i64, i64* %item.ptr, align 8
  %last.idx = add i64 %k, 1
  %is.last = icmp eq i64 %last.idx, %ol.cur
  %sp.sel = select i1 %is.last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0)
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %r1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.item, i64 %item, i8* %sp.sel)
  %k.next = add i64 %k, 1
  br label %print.loop

after.items:                                        ; preds = %print.loop
  ; newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %r2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ; print distances
  br label %dist.loop

dist.loop:                                          ; preds = %dist.loop, %after.items
  %di = phi i64 [ 0, %after.items ], [ %di.next, %dist.loop ]
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %r3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.dist, i64 0, i64 %di, i32 %d.val)
  %di.next = add nuw nsw i64 %di, 1
  %more.di = icmp ult i64 %di.next, 7
  br i1 %more.di, label %dist.loop, label %ret

ret:                                                ; preds = %dist.loop
  ret i32 0
}