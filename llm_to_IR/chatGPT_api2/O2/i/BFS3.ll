; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: BFS traversal of a fixed 7-node graph; print BFS order and distances from node 0 (confidence=0.95). Evidence: queue malloc(56), dist[] init to -1 with dist[0]=0, adjacency row access with 7 stride.

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"
@.adj = private unnamed_addr constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
]

; Only the needed extern declarations:
declare i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  ; dist[i] = -1 for i=0..6
  %d0p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 -1, i32* %d0p, align 4
  %d1p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  store i32 -1, i32* %d1p, align 4
  %d2p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  store i32 -1, i32* %d2p, align 4
  %d3p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  store i32 -1, i32* %d3p, align 4
  %d4p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  store i32 -1, i32* %d4p, align 4
  %d5p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  store i32 -1, i32* %d5p, align 4
  %d6p = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  store i32 -1, i32* %d6p, align 4

  %qraw = call i8* @malloc(i64 56)
  %isnull = icmp eq i8* %qraw, null
  br i1 %isnull, label %post_bfs, label %bfs_start

bfs_start:                                       ; preds = %entry
  ; dist[0] = 0
  store i32 0, i32* %d0p, align 4
  %q = bitcast i8* %qraw to i64*
  ; queue[0] = 0
  store i64 0, i64* %q, align 8
  br label %while_hdr

while_hdr:                                       ; preds = %inner_end, %bfs_start
  %head = phi i64 [ 0, %bfs_start ], [ %head.next, %inner_end ]
  %tail = phi i64 [ 1, %bfs_start ], [ %tail.out, %inner_end ]
  %olen = phi i64 [ 0, %bfs_start ], [ %olen.next, %inner_end ]
  %cond = icmp slt i64 %head, %tail
  br i1 %cond, label %dequeue, label %bfs_done

dequeue:                                         ; preds = %while_hdr
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %v = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; order[olen] = v
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %olen
  store i64 %v, i64* %ord.ptr, align 8
  %olen.next = add i64 %olen, 1
  ; dv = dist[v]
  %dv.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  br label %inner_hdr

inner_hdr:                                       ; preds = %inner_body_skip, %inner_body_set, %dequeue
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %inner_body_skip ], [ %j.next1, %inner_body_set ]
  %tail.phi = phi i64 [ %tail, %dequeue ], [ %tail.phi, %inner_body_skip ], [ %tail.new, %inner_body_set ]
  %jcond = icmp slt i64 %j, 7
  br i1 %jcond, label %inner_body, label %inner_end

inner_body:                                      ; preds = %inner_hdr
  ; a = adj[v][j]
  %row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @.adj, i64 0, i64 %v
  %cell.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row.ptr, i64 0, i64 %j
  %a = load i32, i32* %cell.ptr, align 4
  %has_edge = icmp ne i32 %a, 0
  br i1 %has_edge, label %check_unseen, label %inner_body_skip

check_unseen:                                    ; preds = %inner_body
  %dju.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dju = load i32, i32* %dju.ptr, align 4
  %unseen = icmp eq i32 %dju, -1
  br i1 %unseen, label %inner_body_set, label %inner_body_skip

inner_body_set:                                  ; preds = %check_unseen
  ; queue[tail] = j
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.phi
  %j.zext = zext i64 %j to i64
  store i64 %j.zext, i64* %q.tail.ptr, align 8
  %tail.new = add i64 %tail.phi, 1
  ; dist[j] = dv + 1
  %dv1 = add i32 %dv, 1
  store i32 %dv1, i32* %dju.ptr, align 4
  %j.next1 = add i64 %j, 1
  br label %inner_hdr

inner_body_skip:                                 ; preds = %check_unseen, %inner_body
  %j.next = add i64 %j, 1
  br label %inner_hdr

inner_end:                                       ; preds = %inner_hdr
  ; loop back with updated head, tail, and olen
  %tail.out = phi i64 [ %tail.phi, %inner_hdr ]
  br label %while_hdr

bfs_done:                                        ; preds = %while_hdr
  call void @free(i8* %qraw)
  br label %post_bfs

post_bfs:                                        ; preds = %bfs_done, %entry
  %olen.final = phi i64 [ 0, %entry ], [ %olen, %bfs_done ]
  ; print header: "BFS order from %zu: " with start=0
  %bfs.str = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %bfs.str, i64 0)
  ; print BFS order list
  %has_items = icmp sgt i64 %olen.final, 0
  br i1 %has_items, label %print_list.hdr, label %after_list

print_list.hdr:                                   ; preds = %post_bfs
  %i = phi i64 [ 0, %post_bfs ], [ %i.next, %print_list.body ]
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  ; load value
  %ord.iptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ord.val = load i64, i64* %ord.iptr, align 8
  ; choose suffix
  %i.plus1 = add i64 %i, 1
  %is_last = icmp eq i64 %i.plus1, %olen.final
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suf.ptr = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i64 %ord.val, i8* %suf.ptr)
  %i.next = add i64 %i, 1
  %cont = icmp slt i64 %i.next, %olen.final
  br i1 %cont, label %print_list.body, label %after_list

print_list.body:                                  ; preds = %print_list.hdr
  br label %print_list.hdr

after_list:                                       ; preds = %print_list.hdr, %post_bfs
  ; print newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ; print distances
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  br label %dist.hdr

dist.hdr:                                         ; preds = %dist.body, %after_list
  %k = phi i64 [ 0, %after_list ], [ %k.next, %dist.body ]
  %dk.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k
  %dk = load i32, i32* %dk.ptr, align 4
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.dist, i64 0, i64 %k, i32 %dk)
  %k.next = add i64 %k, 1
  %k.cont = icmp slt i64 %k.next, 7
  br i1 %k.cont, label %dist.body, label %retblk

dist.body:                                        ; preds = %dist.hdr
  br label %dist.hdr

retblk:                                           ; preds = %dist.hdr
  ret i32 0
}