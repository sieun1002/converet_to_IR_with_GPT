; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print BFS order and distances on a fixed 7-node graph starting from 0 (confidence=0.95). Evidence: adjacency matrix initialization and queue-based traversal, printf formats for BFS order and dist.
; Preconditions: None
; Postconditions: Prints BFS order from node 0 and dist(0 -> v) for v in [0..6]

@.fmt_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.fmt_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.fmt_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.fmt_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@.adj = private unnamed_addr constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
], align 4

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  ; initialize dist[i] = -1
  br label %init.loop

init.loop:                                          ; preds = %init.loop, %entry
  %i.init = phi i32 [ 0, %entry ], [ %i.next, %init.loop ]
  %dist.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (i64 ptrtoint (i32* getelementptr ([7 x i32], [7 x i32]* null, i32 0, i32 0) to i64) / 4)
  ; above noop trick not needed; do direct GEP
  %i64 = zext i32 %i.init to i64
  %dist.ptr.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i64
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add nuw nsw i32 %i.init, 1
  %init.done = icmp eq i32 %i.next, 7
  br i1 %init.done, label %init.end, label %init.loop

init.end:                                           ; preds = %init.loop
  ; allocate queue of 7 x i64 (56 bytes)
  %qraw = call noalias i8* @malloc(i64 56)
  %queue.null = icmp eq i8* %qraw, null
  br i1 %queue.null, label %bfs.skip, label %bfs.start

bfs.start:                                          ; preds = %init.end
  ; queue[0] = 0, head = 0, tail = 1, orderN = 0, dist[0] = 0
  %queue = bitcast i8* %qraw to i64*
  store i64 0, i64* %queue, align 8
  %dist0.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0.ptr, align 4
  br label %bfs.cond

bfs.cond:                                           ; preds = %neighbors.end, %bfs.start
  %head = phi i64 [ 0, %bfs.start ], [ %head.next, %neighbors.end ]
  %tail = phi i64 [ 1, %bfs.start ], [ %tail.out, %neighbors.end ]
  %orderN = phi i64 [ 0, %bfs.start ], [ %orderN.next, %neighbors.end ]
  %cont = icmp ult i64 %head, %tail
  br i1 %cont, label %bfs.body, label %bfs.end

bfs.body:                                           ; preds = %bfs.cond
  %q.elem.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %v = load i64, i64* %q.elem.ptr, align 8
  %head.next = add nuw nsw i64 %head, 1
  ; record order
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %orderN
  store i64 %v, i64* %order.ptr, align 8
  %orderN.next = add nuw nsw i64 %orderN, 1
  ; dist[v]
  %v.i32 = trunc i64 %v to i32
  %v.i64 = zext i32 %v.i32 to i64
  %dist.v.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.i64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  br label %neighbors.loop

neighbors.loop:                                     ; preds = %neighbors.loop, %bfs.body
  %i = phi i32 [ 0, %bfs.body ], [ %i.next2, %neighbors.loop ]
  %i64.n = zext i32 %i to i64
  ; adj[v][i]
  %row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @.adj, i64 0, i64 %v.i64
  %adj.elt.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row.ptr, i64 0, i64 %i64.n
  %adj.val = load i32, i32* %adj.elt.ptr, align 4
  %has.edge = icmp ne i32 %adj.val, 0
  br i1 %has.edge, label %maybe.visit, label %neighbors.next

maybe.visit:                                        ; preds = %neighbors.loop
  %dist.i.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i64.n
  %dist.i = load i32, i32* %dist.i.ptr, align 4
  %unvisited = icmp eq i32 %dist.i, -1
  br i1 %unvisited, label %do.visit, label %neighbors.next

do.visit:                                           ; preds = %maybe.visit
  ; enqueue i
  %q.tail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail
  %i.z = zext i32 %i to i64
  store i64 %i.z, i64* %q.tail.ptr, align 8
  ; update tail
  %tail.inc = add nuw nsw i64 %tail, 1
  ; dist[i] = dist[v] + 1
  %dist.v.plus1 = add nsw i32 %dist.v, 1
  store i32 %dist.v.plus1, i32* %dist.i.ptr, align 4
  br label %neighbors.next.tail

neighbors.next.tail:                                ; preds = %do.visit
  br label %neighbors.next

neighbors.next:                                     ; preds = %neighbors.next.tail, %maybe.visit, %neighbors.loop
  %tail.phi = phi i64 [ %tail.inc, %neighbors.next.tail ], [ %tail, %maybe.visit ], [ %tail, %neighbors.loop ]
  %i.next2 = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next2, 7
  br i1 %i.done, label %neighbors.end, label %neighbors.loop

neighbors.end:                                      ; preds = %neighbors.next
  %tail.out = phi i64 [ %tail.phi, %neighbors.next ]
  br label %bfs.cond

bfs.end:                                            ; preds = %bfs.cond
  call void @free(i8* %qraw)
  br label %print.header

bfs.skip:                                           ; preds = %init.end
  ; orderN = 0 when malloc fails; distances remain -1
  br label %print.header

print.header:                                       ; preds = %bfs.skip, %bfs.end
  ; print header with start node 0
  %fmt_hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_hdr, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_hdr.ptr, i64 0)
  ; determine order count
  %orderN.final = phi i64 [ 0, %bfs.skip ], [ %orderN, %bfs.end ]
  ; print order items
  br label %order.loop

order.loop:                                         ; preds = %order.loop, %print.header
  %j = phi i64 [ 0, %print.header ], [ %j.next, %order.loop ]
  %done = icmp eq i64 %j, %orderN.final
  br i1 %done, label %order.end, label %order.body

order.body:                                         ; preds = %order.loop
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %j
  %ord.val = load i64, i64* %ord.ptr, align 8
  %j.plus1 = add nuw nsw i64 %j, 1
  %is.last = icmp eq i64 %j.plus1, %orderN.final
  %sep.sel = select i1 %is.last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.space, i64 0, i64 0)
  %fmt_item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_item, i64 0, i64 0
  %call.item = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_item.ptr, i64 %ord.val, i8* %sep.sel)
  %j.next = add nuw nsw i64 %j, 1
  br label %order.loop

order.end:                                          ; preds = %order.loop
  ; newline
  %fmt_nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.fmt_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_nl.ptr)
  ; print distances
  br label %dist.loop

dist.loop:                                          ; preds = %dist.loop, %order.end
  %k = phi i32 [ 0, %order.end ], [ %k.next, %dist.loop ]
  %k64 = zext i32 %k to i64
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k64
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt_dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_dist.ptr, i64 0, i64 %k64, i32 %d.val)
  %k.next = add nuw nsw i32 %k, 1
  %k.done = icmp eq i32 %k.next, 7
  br i1 %k.done, label %ret, label %dist.loop

ret:                                                ; preds = %dist.loop
  ret i32 0
}