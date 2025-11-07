; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb_10c0:
  %canary.slot = alloca i64, align 8
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canary.slot, align 8

  ; initialize dist[] = -1
  %d0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %d1 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  %d2 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  %d3 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  %d4 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  %d5 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  %d6 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  store i32 -1, i32* %d0, align 4
  store i32 -1, i32* %d1, align 4
  store i32 -1, i32* %d2, align 4
  store i32 -1, i32* %d3, align 4
  store i32 -1, i32* %d4, align 4
  store i32 -1, i32* %d5, align 4
  store i32 -1, i32* %d6, align 4

  ; zero adjacency matrix
  %adj.i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges (see analysis)
  ; [0][1]=1, [0][2]=1
  %a01 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  %a02 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 1, i32* %a01, align 4
  store i32 1, i32* %a02, align 4
  ; [1][0]=1, [1][3]=1, [1][4]=1
  %a10 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  %a13 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 3
  %a14 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 4
  store i32 1, i32* %a10, align 4
  store i32 1, i32* %a13, align 4
  store i32 1, i32* %a14, align 4
  ; [2][0]=1, [2][5]=1
  %a20 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  %a25 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %a20, align 4
  store i32 1, i32* %a25, align 4
  ; [3][1]=1
  %a31 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %a31, align 4
  ; [4][1]=1, [4][5]=1
  %a41 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  %a45 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 1, i32* %a41, align 4
  store i32 1, i32* %a45, align 4
  ; [5][2]=1, [5][4]=1, [5][6]=1
  %a52 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  %a54 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  %a56 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %a52, align 4
  store i32 1, i32* %a54, align 4
  store i32 1, i32* %a56, align 4
  ; [6][5]=1
  %a65 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %a65, align 4

  ; dist[0] = 0
  store i32 0, i32* %d0, align 4

  ; call malloc(0x38)
  %qheap.raw = call i8* @malloc(i64 56)
  %isnull = icmp eq i8* %qheap.raw, null
  br i1 %isnull, label %bb_1414, label %bb_1196

bb_1196:                                           ; malloc ok, init queue/back/front
  %qheap = bitcast i8* %qheap.raw to i64*
  ; queue[0] = 0
  %q0ptr = getelementptr inbounds i64, i64* %qheap, i64 0
  store i64 0, i64* %q0ptr, align 8
  ; back = 1, front = 0, last_eax = 0
  br label %bb_11d3

bb_11c0:                                           ; compute col0 = adj[curr][0] for next loop
  ; incoming from 1320 when front < back
  %front.in.11c0 = phi i64 [ %front.next, %bb_1320 ]
  %back.in.11c0 = phi i64 [ %back.out.12f8, %bb_1320 ]
  %curr.idx.11c0.ptr = getelementptr inbounds i64, i64* %qheap, i64 %front.in.11c0
  %curr.idx.11c0 = load i64, i64* %curr.idx.11c0.ptr, align 8
  ; col0
  %row0.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr.idx.11c0, i64 0
  %col0.val = load i32, i32* %row0.ptr, align 4
  br label %bb_11d3

bb_11d3:
  ; PHIs for front, back, col0, queue ptr
  %front.in = phi i64 [ 0, %bb_1196 ], [ %front.in.11c0, %bb_11c0 ]
  %back.in = phi i64 [ 1, %bb_1196 ], [ %back.in.11c0, %bb_11c0 ]
  %col0.in = phi i32 [ 0, %bb_1196 ], [ %col0.val, %bb_11c0 ]
  ; front = front + 1
  %front.inc = add i64 %front.in, 1
  ; current = queue[front-1]
  %front.prev = add i64 %front.inc, -1
  %curr.ptr = getelementptr inbounds i64, i64* %qheap, i64 %front.prev
  %curr = load i64, i64* %curr.ptr, align 8
  ; compute pointer to dist[curr]
  %d.curr.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %curr
  ; save order[front-1] = curr
  %ord.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %front.prev
  store i64 %curr, i64* %ord.base, align 8
  ; test col0
  %col0.nz = icmp ne i32 %col0.in, 0
  br i1 %col0.nz, label %bb_11e5, label %bb_1200

; check dist[0] == -1 then enqueue 0
bb_11e5:
  %dist0 = load i32, i32* %d0, align 4
  %dist0.neg1 = icmp eq i32 %dist0, -1
  br i1 %dist0.neg1, label %bb_11eb_then, label %bb_1200

bb_11eb_then:
  ; dist[curr] + 1
  %d.curr = load i32, i32* %d.curr.ptr, align 4
  %d.curr.inc = add i32 %d.curr, 1
  ; enqueue 0 at back.in
  %qb.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in
  store i64 0, i64* %qb.ptr, align 8
  %back.a = add i64 %back.in, 1
  store i32 %d.curr.inc, i32* %d0, align 4
  br label %bb_1200

bb_1200:
  ; PHI for back after optional neighbor 0
  %back.in.1200 = phi i64 [ %back.in, %bb_11d3 ], [ %back.in, %bb_11e5 ], [ %back.a, %bb_11eb_then ]
  ; r11d = adj[curr][1]
  %a1.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 1
  %a1 = load i32, i32* %a1.ptr, align 4
  %a1.nz = icmp ne i32 %a1, 0
  br i1 %a1.nz, label %bb_121d, label %bb_1240

bb_121d:
  %dist1.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  %dist1 = load i32, i32* %dist1.ptr, align 4
  %dist1.neg1 = icmp eq i32 %dist1, -1
  br i1 %dist1.neg1, label %bb_1224_then, label %bb_1240

bb_1224_then:
  %d.curr.1 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.1.inc = add i32 %d.curr.1, 1
  %qb1.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.1200
  store i64 1, i64* %qb1.ptr, align 8
  %back.b = add i64 %back.in.1200, 1
  store i32 %d.curr.1.inc, i32* %dist1.ptr, align 4
  br label %bb_1240

bb_1240:
  %back.in.1240 = phi i64 [ %back.in.1200, %bb_1200 ], [ %back.in.1200, %bb_121d ], [ %back.b, %bb_1224_then ]
  ; r10d = adj[curr][2]
  %a2.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 2
  %a2 = load i32, i32* %a2.ptr, align 4
  %a2.nz = icmp ne i32 %a2, 0
  br i1 %a2.nz, label %bb_124a, label %bb_1270

bb_124a:
  %dist2.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  %dist2 = load i32, i32* %dist2.ptr, align 4
  %dist2.neg1 = icmp eq i32 %dist2, -1
  br i1 %dist2.neg1, label %bb_1251_then, label %bb_1270

bb_1251_then:
  %d.curr.2 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.2.inc = add i32 %d.curr.2, 1
  %qb2.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.1240
  store i64 2, i64* %qb2.ptr, align 8
  %back.c = add i64 %back.in.1240, 1
  store i32 %d.curr.2.inc, i32* %dist2.ptr, align 4
  br label %bb_1270

bb_1270:
  %back.in.1270 = phi i64 [ %back.in.1240, %bb_1240 ], [ %back.in.1240, %bb_124a ], [ %back.c, %bb_1251_then ]
  ; r9d = adj[curr][3]
  %a3.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 3
  %a3 = load i32, i32* %a3.ptr, align 4
  %a3.nz = icmp ne i32 %a3, 0
  br i1 %a3.nz, label %bb_127a, label %bb_12a0

bb_127a:
  %dist3.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  %dist3 = load i32, i32* %dist3.ptr, align 4
  %dist3.neg1 = icmp eq i32 %dist3, -1
  br i1 %dist3.neg1, label %bb_1281_then, label %bb_12a0

bb_1281_then:
  %d.curr.3 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.3.inc = add i32 %d.curr.3, 1
  %qb3.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.1270
  store i64 3, i64* %qb3.ptr, align 8
  %back.d = add i64 %back.in.1270, 1
  store i32 %d.curr.3.inc, i32* %dist3.ptr, align 4
  br label %bb_12a0

bb_12a0:
  %back.in.12a0 = phi i64 [ %back.in.1270, %bb_1270 ], [ %back.in.1270, %bb_127a ], [ %back.d, %bb_1281_then ]
  ; r8d = adj[curr][4]
  %a4.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 4
  %a4 = load i32, i32* %a4.ptr, align 4
  %a4.nz = icmp ne i32 %a4, 0
  br i1 %a4.nz, label %bb_12aa, label %bb_12d0

bb_12aa:
  %dist4.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  %dist4 = load i32, i32* %dist4.ptr, align 4
  %dist4.neg1 = icmp eq i32 %dist4, -1
  br i1 %dist4.neg1, label %bb_12b1_then, label %bb_12d0

bb_12b1_then:
  %d.curr.4 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.4.inc = add i32 %d.curr.4, 1
  %qb4.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.12a0
  store i64 4, i64* %qb4.ptr, align 8
  %back.e = add i64 %back.in.12a0, 1
  store i32 %d.curr.4.inc, i32* %dist4.ptr, align 4
  br label %bb_12d0

bb_12d0:
  %back.in.12d0 = phi i64 [ %back.in.12a0, %bb_12a0 ], [ %back.in.12a0, %bb_12aa ], [ %back.e, %bb_12b1_then ]
  ; ecx = adj[curr][5]
  %a5.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 5
  %a5 = load i32, i32* %a5.ptr, align 4
  %a5.nz = icmp ne i32 %a5, 0
  br i1 %a5.nz, label %bb_12d8, label %bb_12f8

bb_12d8:
  %dist5.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  %dist5 = load i32, i32* %dist5.ptr, align 4
  %dist5.neg1 = icmp eq i32 %dist5, -1
  br i1 %dist5.neg1, label %bb_12df_then, label %bb_12f8

bb_12df_then:
  %d.curr.5 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.5.inc = add i32 %d.curr.5, 1
  %qb5.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.12d0
  store i64 5, i64* %qb5.ptr, align 8
  %back.f = add i64 %back.in.12d0, 1
  store i32 %d.curr.5.inc, i32* %dist5.ptr, align 4
  br label %bb_12f8

bb_12f8:
  %back.in.12f8 = phi i64 [ %back.in.12d0, %bb_12d0 ], [ %back.in.12d0, %bb_12d8 ], [ %back.f, %bb_12df_then ]
  ; eax = adj[curr][6]
  %a6.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %curr, i64 6
  %a6 = load i32, i32* %a6.ptr, align 4
  %a6.nz = icmp ne i32 %a6, 0
  br i1 %a6.nz, label %bb_1300, label %bb_1320

bb_1300:
  %dist6.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  %dist6 = load i32, i32* %dist6.ptr, align 4
  %dist6.neg1 = icmp eq i32 %dist6, -1
  br i1 %dist6.neg1, label %bb_1307_then, label %bb_1320

bb_1307_then:
  %d.curr.6 = load i32, i32* %d.curr.ptr, align 4
  %d.curr.6.inc = add i32 %d.curr.6, 1
  %qb6.ptr = getelementptr inbounds i64, i64* %qheap, i64 %back.in.12f8
  store i64 6, i64* %qb6.ptr, align 8
  %back.g = add i64 %back.in.12f8, 1
  store i32 %d.curr.6.inc, i32* %dist6.ptr, align 4
  br label %bb_1320

bb_1320:
  %back.out.12f8 = phi i64 [ %back.in.12f8, %bb_12f8 ], [ %back.in.12f8, %bb_1300 ], [ %back.g, %bb_1307_then ]
  %front.next = phi i64 [ %front.inc, %bb_12f8 ], [ %front.inc, %bb_1300 ], [ %front.inc, %bb_1307_then ]
  ; if front < back -> continue loop
  %cond.more = icmp ult i64 %front.next, %back.out.12f8
  br i1 %cond.more, label %bb_11c0, label %bb_1329

bb_1329:
  ; free(queue)
  call void @free(i8* %qheap.raw)
  br label %bb_1330

bb_1330:
  ; print header: "BFS order from %zu: " with source 0
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.header = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs, i64 0)
  br label %bb_1345

bb_1345:
  ; first element
  %first.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %first = load i64, i64* %first.ptr, align 8
  ; rbx == 1 ?
  %onlyone = icmp eq i64 %front.next, 1
  br i1 %onlyone, label %bb_1360, label %bb_13dd

bb_13dd:
  ; print order[0..(front.next-2)] with trailing spaces
  ; i = 0
  %limit.m1 = add i64 %front.next, -1
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %bb_13f0

bb_13f0:
  %i.ph = phi i64 [ 0, %bb_13dd ], [ %i.next, %bb_140a ]
  %ord.i.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.ph
  %ord.i = load i64, i64* %ord.i.ptr, align 8
  %call.item = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.item, i64 %ord.i, i8* %space.ptr)
  br label %bb_140a

bb_140a:
  %i.next = add i64 %i.ph, 1
  %cond.loop = icmp ult i64 %i.next, %limit.m1
  br i1 %cond.loop, label %bb_13f0, label %bb_1360

bb_1360:
  ; print last element with empty suffix
  %last.idx = add i64 %front.next, -1
  %last.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %last.idx
  %last = load i64, i64* %last.ptr, align 8
  %fmt.item2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %call.last = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.item2, i64 %last, i8* %empty.ptr)
  br label %bb_1376

bb_1376:
  ; print newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ; print distances: for i=0..6
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  br label %bb_1398

bb_1398:
  %di = phi i64 [ 0, %bb_1376 ], [ %di.next, %bb_13b4 ]
  %dist.i.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %dist.i32 = load i32, i32* %dist.i.ptr, align 4
  ; args: 2, fmt, (size_t)0, (size_t)i, (int)dist
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist, i64 0, i64 %di, i32 %dist.i32)
  %di.next = add i64 %di, 1
  br label %bb_13b4

bb_13b4:
  %cont = icmp ult i64 %di.next, 7
  br i1 %cont, label %bb_1398, label %bb_13ba

bb_13ba:
  ; stack canary check
  %guard.end = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.slot, align 8
  %guard.eq = icmp eq i64 %guard.end, %guard.saved
  br i1 %guard.eq, label %bb_13cd, label %bb_142e

bb_13cd:
  ret i32 0

bb_1414:
  ; malloc failed: print header and then newline branch (no order elements)
  %fmt.bfs2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.header2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs2, i64 0)
  br label %bb_1376

bb_142e:
  call void @__stack_chk_fail()
  unreachable
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)