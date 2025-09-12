; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: Breadth-first search on a fixed 7-node graph; prints BFS order from 0 and distances (confidence=0.86). Evidence: adjacency matrix locals and queue-based traversal; format strings.
; Preconditions:
; Postconditions: Writes traversal order and distances to stdout

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@.adj = private unnamed_addr constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
], align 16

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; locals
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue = alloca [7 x i64], align 16

  ; initialize distances to -1
  br label %init_loop

init_loop:                                        ; preds = %init_loop, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_loop ]
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add nuw nsw i64 %i, 1
  %init.cont = icmp ult i64 %i.next, 7
  br i1 %init.cont, label %init_loop, label %init_done

init_done:                                        ; preds = %init_loop
  ; dist[0] = 0
  %dist0.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0.ptr, align 4

  ; queue[0] = 0; head=0; tail=1; count=0
  %q0 = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 0
  store i64 0, i64* %q0, align 8
  br label %bfs_cond

bfs_cond:                                         ; preds = %after_neighbors, %init_done
  %head = phi i64 [ 0, %init_done ], [ %head.next, %after_neighbors ]
  %tail = phi i64 [ 1, %init_done ], [ %tail.out, %after_neighbors ]
  %count = phi i64 [ 0, %init_done ], [ %count.next, %after_neighbors ]
  %more = icmp ult i64 %head, %tail
  br i1 %more, label %bfs_body, label %bfs_done

bfs_body:                                         ; preds = %bfs_cond
  ; curr = queue[head]
  %q.head.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %head
  %curr = load i64, i64* %q.head.ptr, align 8
  %head.next = add nuw nsw i64 %head, 1

  ; order[count] = curr
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %count
  store i64 %curr, i64* %ord.ptr, align 8
  %count.next = add nuw nsw i64 %count, 1

  ; currDist = dist[curr]
  %dist.curr.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %curr
  %currDist = load i32, i32* %dist.curr.ptr, align 4

  ; iterate neighbors j = 0..6
  br label %nei_loop

nei_loop:                                         ; preds = %nei_next, %bfs_body
  %j = phi i64 [ 0, %bfs_body ], [ %j.next, %nei_next ]
  %tail.phi = phi i64 [ %tail, %bfs_body ], [ %tail.updated, %nei_next ]

  ; adj[curr][j]
  %adj.row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @.adj, i64 0, i64 %curr
  %adj.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 %j
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %has.edge = icmp ne i32 %adj.val, 0
  br i1 %has.edge, label %check_unseen, label %nei_next

check_unseen:                                     ; preds = %nei_loop
  %dist.nei.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dist.nei = load i32, i32* %dist.nei.ptr, align 4
  %is.unseen = icmp eq i32 %dist.nei, -1
  br i1 %is.unseen, label %enqueue, label %nei_next

enqueue:                                          ; preds = %check_unseen
  %newDist = add nsw i32 %currDist, 1
  store i32 %newDist, i32* %dist.nei.ptr, align 4
  %q.tail.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %tail.phi
  store i64 %j, i64* %q.tail.ptr, align 8
  %tail.inc = add nuw nsw i64 %tail.phi, 1
  br label %nei_next

nei_next:                                         ; preds = %enqueue, %check_unseen, %nei_loop
  %tail.updated = phi i64 [ %tail.inc, %enqueue ], [ %tail.phi, %check_unseen ], [ %tail.phi, %nei_loop ]
  %j.next = add nuw nsw i64 %j, 1
  %nei.more = icmp ult i64 %j.next, 7
  br i1 %nei.more, label %nei_loop, label %after_neighbors

after_neighbors:                                  ; preds = %nei_next
  %tail.out = phi i64 [ %tail.updated, %nei_next ]
  br label %bfs_cond

bfs_done:                                         ; preds = %bfs_cond
  ; print header: "BFS order from %zu: " with source 0
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %fmt.bfs.i8 = bitcast i8* %fmt.bfs.ptr to i8*
  %call.header = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.bfs.i8, i64 0)

  ; print order with spaces between, no trailing space
  br label %print_order.cond

print_order.cond:                                  ; preds = %print_order.body, %bfs_done
  %pi = phi i64 [ 0, %bfs_done ], [ %pi.next, %print_order.body ]
  %more.order = icmp ult i64 %pi, %count
  br i1 %more.order, label %print_order.body, label %print_order.done

print_order.body:                                  ; preds = %print_order.cond
  %ord.read.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
  %ord.val = load i64, i64* %ord.read.ptr, align 8
  %pi.plus1 = add nuw nsw i64 %pi, 1
  %last = icmp eq i64 %pi.plus1, %count
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sep = select i1 %last, i8* %empty.ptr, i8* %space.ptr
  %fmt.zu.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %fmt.zu.i8 = bitcast i8* %fmt.zu.ptr to i8*
  %call.item = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.zu.i8, i64 %ord.val, i8* %sep)
  %pi.next = add nuw nsw i64 %pi, 1
  br label %print_order.cond

print_order.done:                                  ; preds = %print_order.cond
  ; newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %nl.i8 = bitcast i8* %nl.ptr to i8*
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.i8)

  ; print distances
  br label %dist_loop

dist_loop:                                        ; preds = %dist_loop, %print_order.done
  %di = phi i64 [ 0, %print_order.done ], [ %di.next, %dist_loop ]
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %fmt.dist.i8 = bitcast i8* %fmt.dist.ptr to i8*
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.dist.i8, i64 0, i64 %di, i32 %d.val)
  %di.next = add nuw nsw i64 %di, 1
  %dist.more = icmp ult i64 %di.next, 7
  br i1 %dist.more, label %dist_loop, label %done

done:                                              ; preds = %dist_loop
  ret i32 0
}