; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x00000000000010C0
; Intent: breadth-first search over a fixed 7-node graph; print BFS order and distances from node 0 (confidence=0.90). Evidence: malloc-based queue, neighbor enqueue when distance == -1; prints "BFS order ..." and "dist(%zu -> %zu) = %d"
; Preconditions: none
; Postconditions: returns 0

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

@adj = private constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
]

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  ; init dist[] = -1
  br label %init_loop

init_loop:                                         ; i in [0..7]
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_body ]
  %cond = icmp ult i64 %i, 7
  br i1 %cond, label %init_body, label %init_done

init_body:
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dptr, align 4
  %i.next = add nuw nsw i64 %i, 1
  br label %init_loop

init_done:
  ; dist[0] = 0
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0ptr, align 4

  ; queue = malloc(56)
  %qraw = call i8* @malloc(i64 56)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %print_fail, label %bfs_start

bfs_start:
  %q = bitcast i8* %qraw to i64*
  ; head = 0, tail = 0, order_count = 0
  %head0 = phi i64 [ 0, %bfs_start ]
  %tail0 = phi i64 [ 0, %bfs_start ]
  %ocnt0 = phi i64 [ 0, %bfs_start ]

  ; enqueue(0)
  %qslot0 = getelementptr inbounds i64, i64* %q, i64 %tail0
  store i64 0, i64* %qslot0, align 8
  %tail1 = add nuw nsw i64 %tail0, 1

  br label %bfs_loop

bfs_loop:                                          ; while (head < tail)
  %head = phi i64 [ %head0, %bfs_start ], [ %head.next, %bfs_after_inner ]
  %tail = phi i64 [ %tail1, %bfs_start ], [ %tail.next, %bfs_after_inner ]
  %ocnt = phi i64 [ %ocnt0, %bfs_start ], [ %ocnt.next, %bfs_after_inner ]
  %not_empty = icmp ult i64 %head, %tail
  br i1 %not_empty, label %bfs_pop, label %bfs_done

bfs_pop:
  ; current = queue[head++]
  %qelem.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %current = load i64, i64* %qelem.ptr, align 8
  %head.next = add nuw nsw i64 %head, 1

  ; order[ocnt++] = current
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ocnt
  store i64 %current, i64* %ord.ptr, align 8
  %ocnt.next = add nuw nsw i64 %ocnt, 1

  ; for (j = 0..6)
  br label %inner_for

inner_for:
  %j = phi i64 [ 0, %bfs_pop ], [ %j.next, %inner_body_end ]
  %j.cond = icmp ult i64 %j, 7
  br i1 %j.cond, label %inner_body, label %bfs_after_inner

inner_body:
  ; if (adj[current][j] != 0 && dist[j] == -1) { dist[j] = dist[current] + 1; enqueue(j); }
  %adj.row = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %current
  %adj.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row, i64 0, i64 %j
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %adj.nz = icmp ne i32 %adj.val, 0

  ; dist[j]
  %dj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dj = load i32, i32* %dj.ptr, align 4
  %dj.unvis = icmp eq i32 %dj, -1

  %need_visit = and i1 %adj.nz, %dj.unvis
  br i1 %need_visit, label %visit_then, label %inner_body_end

visit_then:
  ; dnew = dist[current] + 1
  %dc.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %current
  %dc = load i32, i32* %dc.ptr, align 4
  %dnew = add nsw i32 %dc, 1
  store i32 %dnew, i32* %dj.ptr, align 4

  ; enqueue(j)
  %tail.slot = getelementptr inbounds i64, i64* %q, i64 %tail
  ; j is i64 already
  store i64 %j, i64* %tail.slot, align 8
  %tail.inc = add nuw nsw i64 %tail, 1
  br label %inner_body_end

inner_body_end:
  %tail.next = phi i64 [ %tail, %inner_body ], [ %tail.inc, %visit_then ]
  %j.next = add nuw nsw i64 %j, 1
  br label %inner_for

bfs_after_inner:
  br label %bfs_loop

bfs_done:
  ; free queue
  call void @free(i8* %qraw)
  ; print header
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)

  ; print BFS order with spaces
  br label %print_order

print_fail:
  ; header then newline, then distances (no BFS performed)
  %hdr.ptr.fail = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %_pf = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr.fail, i64 0)
  %nl.ptr.fail = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %_pf2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr.fail)
  br label %print_dists

print_order:
  %po.i = phi i64 [ 0, %bfs_done ], [ %po.next, %po.body ]
  ; if po.i < ocnt then print element
  %po.cmp = icmp ult i64 %po.i, %ocnt
  br i1 %po.cmp, label %po.body, label %after_order

po.body:
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %po.i
  %val = load i64, i64* %val.ptr, align 8
  ; choose suffix
  %next.i = add nuw nsw i64 %po.i, 1
  %is_last = icmp eq i64 %next.i, %ocnt
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %is_last, i8* %empty.ptr, i8* %sp.ptr
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt2, i64 0, i64 0
  %_po = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt2.ptr, i64 %val, i8* %suffix)
  %po.next = add nuw nsw i64 %po.i, 1
  br label %print_order

after_order:
  ; newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  br label %print_dists

print_dists:
  %k = phi i64 [ 0, %print_fail ], [ 0, %after_order ]
  br label %dist_loop

dist_loop:
  %k.cur = phi i64 [ %k, %print_dists ], [ %k.next, %dist_body ]
  %k.cond = icmp ult i64 %k.cur, 7
  br i1 %k.cond, label %dist_body, label %done

dist_body:
  %dk.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k.cur
  %dk = load i32, i32* %dk.ptr, align 4
  %fmt3.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %_pd = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt3.ptr, i64 0, i64 %k.cur, i32 %dk)
  %k.next = add nuw nsw i64 %k.cur, 1
  br label %dist_loop

done:
  ret i32 0
}