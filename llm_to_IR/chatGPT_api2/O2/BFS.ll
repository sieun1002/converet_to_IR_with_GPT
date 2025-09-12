; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: BFS over a fixed 7-node undirected graph; print BFS order and distances from node 0 (confidence=0.95). Evidence: format strings for BFS order/distances; queue + visited array with adjacency matrix traversal.
; Preconditions: None
; Postconditions: Prints traversal order and distances

@.str_bfs = private unnamed_addr constant [20 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@adj = internal constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
], align 16

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %visited = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  ; init visited[i] = -1 for i=0..6
  br label %init_loop

init_loop:                                        ; preds = %init_loop, %entry
  %i.init = phi i64 [ 0, %entry ], [ %i.next, %init_loop ]
  %iv.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %visited, i64 0, i64 %i.init
  store i32 -1, i32* %iv.ptr, align 4
  %i.cmp = icmp eq i64 %i.init, 6
  %i.next = add nuw nsw i64 %i.init, 1
  br i1 %i.cmp, label %after_init, label %init_loop

after_init:                                       ; preds = %init_loop
  ; malloc queue of 7 x i64 = 56 bytes
  %qmem = call noalias i8* @malloc(i64 56)
  %isnull = icmp eq i8* %qmem, null
  br i1 %isnull, label %malloc_fail, label %bfs_start

bfs_start:                                        ; preds = %after_init
  %queue = bitcast i8* %qmem to i64*
  ; queue[0] = 0
  store i64 0, i64* %queue, align 8
  ; head = 0, tail = 1, count = 0
  br label %bfs_cond

bfs_cond:                                         ; preds = %bfs_body_end, %bfs_start
  %head = phi i64 [ 0, %bfs_start ], [ %head.next, %bfs_body_end ]
  %tail = phi i64 [ 1, %bfs_start ], [ %tail.next, %bfs_body_end ]
  %count = phi i64 [ 0, %bfs_start ], [ %count.next, %bfs_body_end ]
  ; ensure visited[0] = 0 (source)
  ; do once (only first entry), but harmless to set each time before processing
  %v0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %visited, i64 0, i64 0
  store i32 0, i32* %v0ptr, align 4
  %cond = icmp ult i64 %head, %tail
  br i1 %cond, label %bfs_body, label %bfs_done

bfs_body:                                         ; preds = %bfs_cond
  ; cur = queue[head]
  %qheadelem.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %cur = load i64, i64* %qheadelem.ptr, align 8
  ; order[count] = cur
  %order.slot = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %count
  store i64 %cur, i64* %order.slot, align 8
  ; head++, count++
  %head.next = add nuw nsw i64 %head, 1
  %count.next = add nuw nsw i64 %count, 1

  ; load visited[cur] once
  %vcur.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %visited, i64 0, i64 %cur
  %vcur = load i32, i32* %vcur.ptr, align 4

  ; row pointer for adjacency[cur][0]
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %cur, i64 0

  ; neighbor loop
  br label %nbr_loop

nbr_loop:                                         ; preds = %nbr_loop, %bfs_body
  %j = phi i64 [ 0, %bfs_body ], [ %j.next, %nbr_loop ]
  %adj.elem.ptr = getelementptr inbounds i32, i32* %rowptr, i64 %j
  %adj.elem = load i32, i32* %adj.elem.ptr, align 4
  %has_edge = icmp ne i32 %adj.elem, 0
  br i1 %has_edge, label %check_unseen, label %advance_j

check_unseen:                                     ; preds = %nbr_loop
  %vj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %visited, i64 0, i64 %j
  %vj = load i32, i32* %vj.ptr, align 4
  %is_unseen = icmp eq i32 %vj, -1
  br i1 %is_unseen, label %enqueue, label %advance_j

enqueue:                                          ; preds = %check_unseen
  ; queue[tail] = j
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail
  store i64 %j, i64* %qtail.ptr, align 8
  ; visited[j] = visited[cur] + 1
  %newdist = add nsw i32 %vcur, 1
  store i32 %newdist, i32* %vj.ptr, align 4
  ; tail++
  %tail.inc = add nuw nsw i64 %tail, 1
  br label %advance_j.tail

advance_j.tail:                                   ; preds = %enqueue
  br label %advance_j

advance_j:                                        ; preds = %advance_j.tail, %check_unseen, %nbr_loop
  %tail.phi = phi i64 [ %tail.inc, %advance_j.tail ], [ %tail, %check_unseen ], [ %tail, %nbr_loop ]
  %j.islast = icmp eq i64 %j, 6
  %j.next = add nuw nsw i64 %j, 1
  br i1 %j.islast, label %bfs_body_end, label %nbr_loop

bfs_body_end:                                     ; preds = %advance_j
  %tail.next = phi i64 [ %tail.phi, %advance_j ]
  br label %bfs_cond

bfs_done:                                         ; preds = %bfs_cond
  ; free(queue)
  call void @free(i8* %qmem)

  ; print header: "BFS order from %zu: " with 0
  %fmt_bfs.ptr = getelementptr inbounds [20 x i8], [20 x i8]* @.str_bfs, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs.ptr, i64 0)

  ; print order list
  br label %print_order_cond

print_order_cond:                                 ; preds = %print_order_body, %bfs_done
  %pi = phi i64 [ 0, %bfs_done ], [ %pi.next, %print_order_body ]
  %has_items = icmp ult i64 %pi, %count
  br i1 %has_items, label %print_order_body, label %after_order

print_order_body:                                 ; preds = %print_order_cond
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
  %val = load i64, i64* %val.ptr, align 8
  ; choose delimiter: " " unless last
  %nexti = add nuw nsw i64 %pi, 1
  %is_last = icmp eq i64 %nexti, %count
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %is_last, i8* %empty.ptr, i8* %sp.ptr
  %fmt_zu_s.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call_item = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_zu_s.ptr, i64 %val, i8* %delim)
  %pi.next = add nuw nsw i64 %pi, 1
  br label %print_order_cond

after_order:                                      ; preds = %print_order_cond
  ; newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)

  ; print distances loop for i=0..6
  br label %dist_loop

malloc_fail:                                      ; preds = %after_init
  ; print header with 0
  %fmt_bfs.ptr.fail = getelementptr inbounds [20 x i8], [20 x i8]* @.str_bfs, i64 0, i64 0
  %call_hdr.fail = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs.ptr.fail, i64 0)
  ; newline
  %nl.ptr.fail = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl.fail = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr.fail)
  br label %dist_loop

dist_loop:                                        ; preds = %after_order, %malloc_fail, %dist_loop
  %di = phi i64 [ 0, %after_order ], [ 0, %malloc_fail ], [ %di.next, %dist_loop ]
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %visited, i64 0, i64 %di
  %dist = load i32, i32* %dist.ptr, align 4
  %fmt_dist.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dist, i64 0, i64 0
  %call_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_dist.ptr, i64 0, i64 %di, i32 %dist)
  %is_last_di = icmp eq i64 %di, 6
  %di.next = add nuw nsw i64 %di, 1
  br i1 %is_last_di, label %done, label %dist_loop

done:                                             ; preds = %dist_loop
  ret i32 0
}