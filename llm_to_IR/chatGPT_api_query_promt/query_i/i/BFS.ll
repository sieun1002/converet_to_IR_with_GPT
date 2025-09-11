; ModuleID = 'bfs_from_disasm'
source_filename = "bfs_from_disasm"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs   = private unnamed_addr constant [20 x i8] c"BFS order from %zu: \00", align 1
@.str_pair  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl    = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; dist[7] (i32), adj[7][7] (i32), order[7] (i64)
  %dist  = alloca [7 x i32], align 16
  %adj   = alloca [7 x [7 x i32]], align 16
  %order = alloca [7 x i64], align 16
  %proc  = alloca i64, align 8
  %tail  = alloca i64, align 8

  ; dist = -1
  %dist_i8 = bitcast [7 x i32]* %dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist_i8, i8 -1, i64 28, i1 false)

  ; adj = 0
  %adj_i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; set undirected edges:
  ; 0-1
  %a01r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0
  %a01  = getelementptr inbounds [7 x i32], [7 x i32]* %a01r, i64 0, i64 1
  store i32 1, i32* %a01, align 4
  %a10r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1
  %a10  = getelementptr inbounds [7 x i32], [7 x i32]* %a10r, i64 0, i64 0
  store i32 1, i32* %a10, align 4

  ; 0-2
  %a02  = getelementptr inbounds [7 x i32], [7 x i32]* %a01r, i64 0, i64 2
  store i32 1, i32* %a02, align 4
  %a20r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2
  %a20  = getelementptr inbounds [7 x i32], [7 x i32]* %a20r, i64 0, i64 0
  store i32 1, i32* %a20, align 4

  ; 1-3
  %a13  = getelementptr inbounds [7 x i32], [7 x i32]* %a10r, i64 0, i64 3
  store i32 1, i32* %a13, align 4
  %a31r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3
  %a31  = getelementptr inbounds [7 x i32], [7 x i32]* %a31r, i64 0, i64 1
  store i32 1, i32* %a31, align 4

  ; 1-4
  %a14  = getelementptr inbounds [7 x i32], [7 x i32]* %a10r, i64 0, i64 4
  store i32 1, i32* %a14, align 4
  %a41r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4
  %a41  = getelementptr inbounds [7 x i32], [7 x i32]* %a41r, i64 0, i64 1
  store i32 1, i32* %a41, align 4

  ; 2-5
  %a25  = getelementptr inbounds [7 x i32], [7 x i32]* %a20r, i64 0, i64 5
  store i32 1, i32* %a25, align 4
  %a52r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5
  %a52  = getelementptr inbounds [7 x i32], [7 x i32]* %a52r, i64 0, i64 2
  store i32 1, i32* %a52, align 4

  ; 4-5
  %a45  = getelementptr inbounds [7 x i32], [7 x i32]* %a41r, i64 0, i64 5
  store i32 1, i32* %a45, align 4
  %a54  = getelementptr inbounds [7 x i32], [7 x i32]* %a52r, i64 0, i64 4
  store i32 1, i32* %a54, align 4

  ; 5-6
  %a56  = getelementptr inbounds [7 x i32], [7 x i32]* %a52r, i64 0, i64 6
  store i32 1, i32* %a56, align 4
  %a65r = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6
  %a65  = getelementptr inbounds [7 x i32], [7 x i32]* %a65r, i64 0, i64 5
  store i32 1, i32* %a65, align 4

  ; queue = malloc(7 * 8)
  %qraw = call noalias i8* @malloc(i64 56)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %malloc_fail, label %bfs_start

malloc_fail:
  ; "BFS order from %zu: " with src=0
  %fmt_bfs0 = getelementptr inbounds [20 x i8], [20 x i8]* @.str_bfs, i64 0, i64 0
  %_p0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs0, i64 0)
  br label %print_nl_and_dists

bfs_start:
  ; dist[0] = 0
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0ptr, align 16
  ; init queue
  %q = bitcast i8* %qraw to i64*
  store i64 0, i64* %q, align 8
  store i64 0, i64* %proc, align 8
  store i64 1, i64* %tail, align 8
  br label %loop

loop:                                             ; BFS outer loop
  %cur = phi i64 [ 0, %bfs_start ], [ %nextCur, %after_neighbors ]
  ; order[proc] = cur ; proc++
  %pval = load i64, i64* %proc, align 8
  %ordptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pval
  store i64 %cur, i64* %ordptr, align 8
  %pinc = add i64 %pval, 1
  store i64 %pinc, i64* %proc, align 8

  ; neighbor loop j=0..6
  br label %neighbor_loop

neighbor_loop:
  %j = phi i64 [ 0, %loop ], [ %j_next, %neighbor_next ]
  ; load adj[cur][j]
  %row = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur
  %elem = getelementptr inbounds [7 x i32], [7 x i32]* %row, i64 0, i64 %j
  %adjv = load i32, i32* %elem, align 4
  %is_edge = icmp ne i32 %adjv, 0
  br i1 %is_edge, label %maybe_enqueue, label %neighbor_next

maybe_enqueue:
  ; if dist[j] == -1
  %djptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dj = load i32, i32* %djptr, align 4
  %unvis = icmp eq i32 %dj, -1
  br i1 %unvis, label %do_enqueue, label %neighbor_next

do_enqueue:
  ; queue[tail] = j ; tail++
  %tval = load i64, i64* %tail, align 8
  %qt = getelementptr inbounds i64, i64* %q, i64 %tval
  store i64 %j, i64* %qt, align 8
  %tinc = add i64 %tval, 1
  store i64 %tinc, i64* %tail, align 8
  ; dist[j] = dist[cur] + 1
  %dcptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %cur
  %dc = load i32, i32* %dcptr, align 4
  %dnext = add nsw i32 %dc, 1
  store i32 %dnext, i32* %djptr, align 4
  br label %neighbor_next

neighbor_next:
  %j_next = add i64 %j, 1
  %more = icmp ult i64 %j_next, 7
  br i1 %more, label %neighbor_loop, label %after_neighbors

after_neighbors:
  ; if proc >= tail break
  %pnow = load i64, i64* %proc, align 8
  %tnow = load i64, i64* %tail, align 8
  %done = icmp uge i64 %pnow, %tnow
  br i1 %done, label %bfs_done, label %load_next

load_next:
  ; cur = queue[proc]
  %qptr = getelementptr inbounds i64, i64* %q, i64 %pnow
  %nextCur = load i64, i64* %qptr, align 8
  br label %loop

bfs_done:
  call void @free(i8* %qraw)
  ; "BFS order from %zu: " with src=0
  %fmt_bfs1 = getelementptr inbounds [20 x i8], [20 x i8]* @.str_bfs, i64 0, i64 0
  %_p1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs1, i64 0)
  ; print order with spaces except last
  %count = load i64, i64* %proc, align 8
  br label %print_order

print_order:
  %i = phi i64 [ 0, %bfs_done ], [ %i_next, %print_order ]
  %pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %ordv_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ordv = load i64, i64* %ordv_ptr, align 8
  %i1 = add i64 %i, 1
  %is_last = icmp eq i64 %i1, %count
  %sep = select i1 %is_last, i8* %empty, i8* %space
  %_p2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %pair, i64 %ordv, i8* %sep)
  %i_next = add i64 %i, 1
  %cont = icmp ult i64 %i_next, %count
  br i1 %cont, label %print_order, label %print_nl_and_dists

print_nl_and_dists:
  ; newline
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %_p3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ; print distances: for k in 0..6: dist(0 -> k) = dist[k]
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  br label %print_dists

print_dists:
  %k = phi i64 [ 0, %print_nl_and_dists ], [ %k_next, %print_dists ]
  %dk_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k
  %dk = load i32, i32* %dk_ptr, align 4
  %_p4 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_dist, i64 0, i64 %k, i32 %dk)
  %k_next = add i64 %k, 1
  %more_k = icmp ult i64 %k_next, 7
  br i1 %more_k, label %print_dists, label %exit

exit:
  ret i32 0
}