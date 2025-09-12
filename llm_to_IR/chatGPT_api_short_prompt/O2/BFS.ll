; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: breadth-first search on a fixed 7-node graph from source 0, then print BFS order and distances (confidence=0.83). Evidence: malloc/free queue, adjacency matrix on stack, __printf_chk with "BFS order..." and "dist(%zu -> %zu) = %d\n"
; Preconditions:
; Postconditions: prints BFS order from node 0 and distances to nodes 0..6

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_elem = private unnamed_addr constant [5 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; locals
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  ; initialize dist[] = -1
  br label %init_loop

init_loop:                                           ; i = 0..6
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_loop.body ]
  %dist.iptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dist.iptr, align 4
  %i.next = add nuw nsw i64 %i, 1
  %cont.init = icmp ule i64 %i, 5
  br i1 %cont.init, label %init_loop.body, label %init_done

init_loop.body:
  br label %init_loop

init_done:
  ; malloc queue for up to 7 nodes (7 * 8 bytes)
  %qraw = call noalias i8* @malloc(i64 56)
  %queue = bitcast i8* %qraw to i64*
  ; count of printed/visited order
  %count.init = phi i64 [ 0, %init_done ]
  %hasq = icmp ne i8* %qraw, null
  br i1 %hasq, label %bfs.begin, label %after_bfs

bfs.begin:
  ; adjacency matrix adj[7][7] (i32)
  %adj = alloca [7 x [7 x i32]], align 16
  ; zero it
  %adj.i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges to 1 (indices (row,col)):
  ; (0,1),(0,2)
  %a001 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  store i32 1, i32* %a001, align 4
  %a002 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 1, i32* %a002, align 4
  ; (2,0),(2,5)
  %a200 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 1, i32* %a200, align 4
  %a205 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %a205, align 4
  ; (3,1)
  %a301 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %a301, align 4
  ; (4,0),(4,1),(4,5)
  %a400 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 0
  store i32 1, i32* %a400, align 4
  %a401 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 1, i32* %a401, align 4
  %a405 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 1, i32* %a405, align 4
  ; (5,2),(5,4),(5,5),(5,6)
  %a502 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 1, i32* %a502, align 4
  %a504 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  store i32 1, i32* %a504, align 4
  %a505 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 5
  store i32 1, i32* %a505, align 4
  %a506 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %a506, align 4
  ; (6,2),(6,5)
  %a602 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 2
  store i32 1, i32* %a602, align 4
  %a605 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %a605, align 4

  ; initialize queue and dist
  ; queue[0] = 0
  store i64 0, i64* %queue, align 8
  ; dist[0] = 0
  %dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0, align 4

  ; head = 0, size = 1, count = 0
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %bfs.begin ], [ %head.next, %after_j ]
  %size = phi i64 [ 1, %bfs.begin ], [ %size.out, %after_j ]
  %count = phi i64 [ 0, %bfs.begin ], [ %count.next, %after_j ]
  ; while (head < size)
  %cmp.hs = icmp ult i64 %head, %size
  br i1 %cmp.hs, label %process_node, label %bfs_done

process_node:
  ; cur = queue[head]
  %q.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %cur = load i64, i64* %q.ptr, align 8
  %head.next = add nuw nsw i64 %head, 1
  ; order[count] = cur
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %count
  store i64 %cur, i64* %ord.ptr, align 8
  %count.next = add nuw nsw i64 %count, 1
  ; dist_cur_plus1 = dist[cur] + 1
  %dcur.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %cur
  %dcur = load i32, i32* %dcur.ptr, align 4
  %dcurp1 = add nsw i32 %dcur, 1
  ; j loop
  br label %j_loop

j_loop:
  %j = phi i64 [ 0, %process_node ], [ %j.next, %j_loop_end ]
  %size.in = phi i64 [ %size, %process_node ], [ %size.upd, %j_loop_end ]
  ; if j < 7
  %cmp.j = icmp ult i64 %j, 7
  br i1 %cmp.j, label %j_body, label %after_j

j_body:
  ; if adj[cur][j] != 0
  %adj.cur.j = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur, i64 %j
  %a = load i32, i32* %adj.cur.j, align 4
  %a.nz = icmp ne i32 %a, 0
  br i1 %a.nz, label %check_dist, label %j_loop_end

check_dist:
  ; if dist[j] == -1
  %dj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dj = load i32, i32* %dj.ptr, align 4
  %dj.unseen = icmp eq i32 %dj, -1
  br i1 %dj.unseen, label %enqueue, label %j_loop_end

enqueue:
  ; queue[size.in] = j
  %q.size.ptr = getelementptr inbounds i64, i64* %queue, i64 %size.in
  store i64 %j, i64* %q.size.ptr, align 8
  %size.plus = add nuw nsw i64 %size.in, 1
  ; dist[j] = dist[cur] + 1
  store i32 %dcurp1, i32* %dj.ptr, align 4
  br label %j_loop_end

j_loop_end:
  %size.upd = phi i64 [ %size.in, %j_body ], [ %size.in, %check_dist ], [ %size.plus, %enqueue ]
  %j.next = add nuw nsw i64 %j, 1
  br label %j_loop

after_j:
  %size.out = phi i64 [ %size.in, %j_loop ], [ %size.upd, %j_loop_end ]
  br label %outer_loop

bfs_done:
  ; free(queue)
  call void @free(i8* %qraw)
  br label %after_bfs

after_bfs:
  ; print header: "BFS order from %zu: " with source 0
  %fmt.h = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %p0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.h, i64 0)

  ; decide count for printing (0 if no BFS run)
  %count.fin = phi i64 [ 0, %init_done ], [ %count, %bfs_done ]

  ; if count.fin > 0, print elements with spaces, else skip
  %has_elems = icmp ugt i64 %count.fin, 0
  br i1 %has_elems, label %print_loop, label %print_nl

print_loop:
  ; i = 0
  br label %print_iter

print_iter:
  %pi = phi i64 [ 0, %print_loop ], [ %pi.next, %print_iter ]
  ; load value
  %ord.ptr.pi = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
  %val = load i64, i64* %ord.ptr.pi, align 8
  ; choose separator: space for i < count-1, else empty
  %last_idx = add nsw i64 %count.fin, -1
  %is_last = icmp eq i64 %pi, %last_idx
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.sel = select i1 %is_last, i8* %sep.empty, i8* %sep.space
  ; print "%zu%s"
  %fmt.elem = getelementptr inbounds [5 x i8], [5 x i8]* @.str_elem, i64 0, i64 0
  %p1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.elem, i64 %val, i8* %sep.sel)
  ; next
  %pi.next = add nuw nsw i64 %pi, 1
  %cont.print = icmp ult i64 %pi.next, %count.fin
  br i1 %cont.print, label %print_iter, label %print_nl

print_nl:
  ; newline
  %fmt.nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %pnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.nl)

  ; print distances for nodes 0..6
  br label %dist_loop

dist_loop:
  %di = phi i64 [ 0, %print_nl ], [ %di.next, %dist_loop ]
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %dval = load i32, i32* %dptr, align 4
  %fmt.d = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %pdist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.d, i64 0, i64 %di, i32 %dval)
  %di.next = add nuw nsw i64 %di, 1
  %cont.dist = icmp ule i64 %di, 5
  br i1 %cont.dist, label %dist_loop, label %retblk

retblk:
  ret i32 0
}