; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x00000000000010C0
; Intent: breadth-first search on a fixed 7-node graph, then print BFS order and distances (confidence=0.85). Evidence: adjacency-matrix-style neighbor iteration; format strings "BFS order from %zu:" and "dist(%zu -> %zu) = %d\n"
; Preconditions: None
; Postconditions: Prints BFS order from source 0, then distances to all nodes 0..6.

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %front = alloca i64, align 8
  %back = alloca i64, align 8
  %queue = alloca i64*, align 8

  ; zero adjacency, set distances to -1
  %adj.bc = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bc, i8 0, i64 196, i1 false)
  %dist.bc = bitcast [7 x i32]* %dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist.bc, i8 -1, i64 28, i1 false)

  ; build an undirected graph:
  ; 0-1, 0-2, 1-3, 1-4, 2-5, 5-6
  ; set both directions
  ; 0 <-> 1
  %a001 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  store i32 1, i32* %a001, align 4
  %a010 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  store i32 1, i32* %a010, align 4
  ; 0 <-> 2
  %a002 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 1, i32* %a002, align 4
  %a020 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 1, i32* %a020, align 4
  ; 1 <-> 3
  %a013 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 3
  store i32 1, i32* %a013, align 4
  %a031 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %a031, align 4
  ; 1 <-> 4
  %a014 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 4
  store i32 1, i32* %a014, align 4
  %a041 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 1, i32* %a041, align 4
  ; 2 <-> 5
  %a025 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %a025, align 4
  %a052 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 1, i32* %a052, align 4
  ; 5 <-> 6
  %a056 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %a056, align 4
  %a065 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %a065, align 4

  ; malloc queue of 7 64-bit entries
  %qmem8 = call noalias i8* @malloc(i64 56)
  %qnull = icmp eq i8* %qmem8, null
  br i1 %qnull, label %malloc_fail, label %malloc_ok

malloc_ok:
  %qmem = bitcast i8* %qmem8 to i64*
  store i64* %qmem, i64** %queue, align 8
  ; init BFS
  store i64 0, i64* %order_len, align 8
  store i64 0, i64* %front, align 8
  store i64 0, i64* %back, align 8
  ; dist[0] = 0
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0ptr, align 4
  ; enqueue 0
  %q0 = load i64*, i64** %queue, align 8
  %b0 = load i64, i64* %back, align 8
  %q0pos = getelementptr inbounds i64, i64* %q0, i64 %b0
  store i64 0, i64* %q0pos, align 8
  %b1 = add i64 %b0, 1
  store i64 %b1, i64* %back, align 8
  br label %bfs_loop

bfs_loop:
  ; while front < back
  %f = load i64, i64* %front, align 8
  %b = load i64, i64* %back, align 8
  %cmpfb = icmp ult i64 %f, %b
  br i1 %cmpfb, label %dequeue, label %after_bfs

dequeue:
  %qptr1 = load i64*, i64** %queue, align 8
  %qposf = getelementptr inbounds i64, i64* %qptr1, i64 %f
  %cur = load i64, i64* %qposf, align 8
  %fnext = add i64 %f, 1
  store i64 %fnext, i64* %front, align 8
  ; append to order
  %olen = load i64, i64* %order_len, align 8
  %optr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %olen
  store i64 %cur, i64* %optr, align 8
  %olen1 = add i64 %olen, 1
  store i64 %olen1, i64* %order_len, align 8
  ; neighbors loop j=0..6
  br label %nbr_loop

nbr_loop:
  %jphi = phi i64 [ 0, %dequeue ], [ %jnext, %nbr_cont ]
  %jcmp = icmp ult i64 %jphi, 7
  br i1 %jcmp, label %nbr_body, label %nbr_done

nbr_body:
  ; if adj[cur][j] != 0 and dist[j] == -1
  %cur32 = trunc i64 %cur to i32
  %cur_ext = sext i32 %cur32 to i64
  %arow = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur_ext
  %acell = getelementptr inbounds [7 x i32], [7 x i32]* %arow, i64 0, i64 %jphi
  %aval = load i32, i32* %acell, align 4
  %is_edge = icmp ne i32 %aval, 0
  br i1 %is_edge, label %check_unseen, label %nbr_cont

check_unseen:
  %djptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %jphi
  %dj = load i32, i32* %djptr, align 4
  %isunseen = icmp eq i32 %dj, -1
  br i1 %isunseen, label %enqueue_j, label %nbr_cont

enqueue_j:
  ; queue[back] = j
  %qptr2 = load i64*, i64** %queue, align 8
  %b2 = load i64, i64* %back, align 8
  %qposb = getelementptr inbounds i64, i64* %qptr2, i64 %b2
  store i64 %jphi, i64* %qposb, align 8
  %b3 = add i64 %b2, 1
  store i64 %b3, i64* %back, align 8
  ; dist[j] = dist[cur] + 1
  %dcurptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %cur_ext
  %dcur = load i32, i32* %dcurptr, align 4
  %dnext = add nsw i32 %dcur, 1
  store i32 %dnext, i32* %djptr, align 4
  br label %nbr_cont

nbr_cont:
  %jnext = add i64 %jphi, 1
  br label %nbr_loop

nbr_done:
  br label %bfs_loop

after_bfs:
  ; free queue
  %qptrf = load i64*, i64** %queue, align 8
  %qptrf8 = bitcast i64* %qptrf to i8*
  call void @free(i8* %qptrf8)
  br label %print_header

malloc_fail:
  ; on malloc failure, print header and newline, then distances (dist array already -1)
  store i64 0, i64* %order_len, align 8
  br label %print_header

print_header:
  ; print "BFS order from %zu: " with source 0
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs, i64 0)
  ; print order elements
  %olen_print = load i64, i64* %order_len, align 8
  %has_any = icmp ne i64 %olen_print, 0
  br i1 %has_any, label %order_loop, label %print_nl

order_loop:
  %i = phi i64 [ 0, %print_header ], [ %inext, %order_loop_cont ]
  %lastidx = sub i64 %olen_print, 1
  %is_last = icmp eq i64 %i, %lastidx
  %sep = select i1 %is_last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0)
  %pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %ovalptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %oval = load i64, i64* %ovalptr, align 8
  %call_pair = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %pair, i64 %oval, i8* %sep)
  %inext = add i64 %i, 1
  %icond = icmp ult i64 %inext, %olen_print
  br i1 %icond, label %order_loop_cont, label %print_nl

order_loop_cont:
  br label %order_loop

print_nl:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ; print distances
  br label %dist_loop

dist_loop:
  %k = phi i64 [ 0, %print_nl ], [ %knext, %dist_loop_cont ]
  %distfmt = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %dkptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k
  %dk = load i32, i32* %dkptr, align 4
  %call_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %distfmt, i64 0, i64 %k, i32 %dk)
  %knext = add i64 %k, 1
  %kcond = icmp ult i64 %knext, 7
  br i1 %kcond, label %dist_loop_cont, label %done

dist_loop_cont:
  br label %dist_loop

done:
  ret i32 0
}