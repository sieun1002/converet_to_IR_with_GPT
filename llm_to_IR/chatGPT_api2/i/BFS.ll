; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print BFS order and distances from node 0 on a hardcoded 7-node graph (confidence=0.95). Evidence: queue via malloc/free, strings "BFS order from %zu: ", "dist(%zu -> %zu) = %d\n"
; Preconditions: None
; Postconditions: Writes formatted output to stdout

@.fmt_hdr = private unnamed_addr constant [20 x i8] c"BFS order from %zu: \00"
@.fmt_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.fmt_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"
@.spc = private unnamed_addr constant [2 x i8] c" \00"
@.emp = private unnamed_addr constant [1 x i8] zeroinitializer
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00"

; Binary-tree-like undirected graph with 7 nodes:
; 0: 1,2
; 1: 0,3,4
; 2: 0,5,6
; 3: 1
; 4: 1
; 5: 2
; 6: 2
@adj = private unnamed_addr constant [7 x [7 x i32]] [
  [7 x i32] [ i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0 ],
  [7 x i32] [ i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 1 ],
  [7 x i32] [ i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0 ],
  [7 x i32] [ i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0 ]
]

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  ; initialize dist[i] = -1
  br label %init_loop

init_loop:                                           ; preds = %init_loop, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_loop ]
  %dist.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add nuw nsw i64 %i, 1
  %init_done = icmp eq i64 %i.next, 7
  br i1 %init_done, label %init_end, label %init_loop

init_end:                                            ; preds = %init_loop
  ; dist[0] = 0
  %dist0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0ptr, align 4

  ; queue = malloc(7 * 8)
  %qbytes = mul nuw nsw i64 7, 8
  %qraw = call noalias i8* @malloc(i64 %qbytes)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %no_queue, label %have_queue

have_queue:                                          ; preds = %init_end
  %queue = bitcast i8* %qraw to i64*
  ; front=0, back=1, queue[0]=0, pos=0
  store i64 0, i64* %queue, align 8
  br label %bfs_outer

bfs_outer:                                           ; preds = %bfs_after_neighbors, %have_queue
  %front = phi i64 [ 0, %have_queue ], [ %front.next, %bfs_after_neighbors ]
  %back = phi i64 [ 1, %have_queue ], [ %back.next, %bfs_after_neighbors ]
  %pos = phi i64 [ 0, %have_queue ], [ %pos.next, %bfs_after_neighbors ]
  %cont = icmp ult i64 %front, %back
  br i1 %cont, label %bfs_pop, label %bfs_done

bfs_pop:                                             ; preds = %bfs_outer
  ; u = queue[front]; front++
  %q.u.ptr = getelementptr inbounds i64, i64* %queue, i64 %front
  %u = load i64, i64* %q.u.ptr, align 8
  %front.next = add nuw nsw i64 %front, 1
  ; order[pos] = u; pos++
  %order.slot = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pos
  store i64 %u, i64* %order.slot, align 8
  %pos.next = add nuw nsw i64 %pos, 1
  ; iterate neighbors v=0..6
  br label %nbr_loop

nbr_loop:                                            ; preds = %nbr_loop, %bfs_pop
  %v = phi i64 [ 0, %bfs_pop ], [ %v.next, %nbr_loop ]
  ; if adj[u][v] != 0 && dist[v] == -1:
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %u
  %cellptr = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %v
  %cell = load i32, i32* %cellptr, align 4
  %has = icmp ne i32 %cell, 0
  %dist.v.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %unvis = icmp eq i32 %dist.v, -1
  %take = and i1 %has, %unvis
  br i1 %take, label %enqueue, label %next_v

enqueue:                                             ; preds = %nbr_loop
  ; dist[v] = dist[u] + 1
  %dist.u.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %d.add = add nsw i32 %dist.u, 1
  store i32 %d.add, i32* %dist.v.ptr, align 4
  ; queue[back] = v; back++
  %q.back.ptr = getelementptr inbounds i64, i64* %queue, i64 %back
  store i64 %v, i64* %q.back.ptr, align 8
  %back.next0 = add nuw nsw i64 %back, 1
  br label %next_v

next_v:                                              ; preds = %enqueue, %nbr_loop
  %back.phi = phi i64 [ %back.next0, %enqueue ], [ %back, %nbr_loop ]
  %v.next = add nuw nsw i64 %v, 1
  %v.done = icmp eq i64 %v.next, 7
  br i1 %v.done, label %bfs_after_neighbors, label %nbr_loop

bfs_after_neighbors:                                 ; preds = %next_v
  %back.next = phi i64 [ %back.phi, %next_v ]
  br label %bfs_outer

bfs_done:                                            ; preds = %bfs_outer
  ; free(queue)
  call void @free(i8* %qraw)
  br label %print_header

no_queue:                                            ; preds = %init_end
  ; proceed to printing with whatever we have (dist initialized with dist[0]=0)
  br label %print_header

print_header:                                        ; preds = %no_queue, %bfs_done
  ; print header with source 0
  %hdr.ptr = getelementptr inbounds [20 x i8], [20 x i8]* @.fmt_hdr, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)

  ; compute count to print in order: if queue path ran, it's %pos from bfs; else, if no BFS, print 0 items.
  %pos.final = phi i64 [ 0, %no_queue ], [ %pos, %bfs_done ]

  ; print order elements with spaces
  %has_items = icmp ne i64 %pos.final, 0
  br i1 %has_items, label %print_loop, label %print_nl

print_loop:                                          ; preds = %print_loop, %print_header
  %pi = phi i64 [ 0, %print_header ], [ %pi.next, %print_loop ]
  %last.idx = add nsw i64 %pos.final, -1
  %is_last = icmp eq i64 %pi, %last.idx
  %sep.ptr = select i1 %is_last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.emp, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.spc, i64 0, i64 0)
  %fmt_pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_pair, i64 0, i64 0
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
  %ord.val = load i64, i64* %ord.ptr, align 8
  %call_pair = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_pair.ptr, i64 %ord.val, i8* %sep.ptr)
  %pi.next = add nuw nsw i64 %pi, 1
  %done = icmp eq i64 %pi.next, %pos.final
  br i1 %done, label %print_nl, label %print_loop

print_nl:                                            ; preds = %print_loop, %print_header
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  br label %print_dist_loop

print_dist_loop:                                     ; preds = %print_dist_loop, %print_nl
  %di = phi i64 [ 0, %print_nl ], [ %di.next, %print_dist_loop ]
  %dist.iptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %dval = load i32, i32* %dist.iptr, align 4
  %fmt_dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  %call_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_dist.ptr, i64 0, i64 %di, i32 %dval)
  %di.next = add nuw nsw i64 %di, 1
  %dist.done = icmp eq i64 %di.next, 7
  br i1 %dist.done, label %ret, label %print_dist_loop

ret:                                                 ; preds = %print_dist_loop
  ret i32 0
}