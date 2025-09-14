; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a small undirected graph (adjacency matrix), run bfs from node 0, print BFS order and distances (confidence=0.95). Evidence: call to bfs with adjacency matrix and buffers; prints "BFS order..." and "dist(...)".
; Preconditions: bfs expects a row-major n x n adjacency matrix of i32 (0/1), n=7; outputs visitation order (i64) and count (i64), and distances (i32).

@.str_bfs_from = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.sp = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.fmt_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.fmt_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %count = alloca i64, align 8

  ; memset adj[49] to 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set undirected edges (n=7) in row-major adjacency matrix
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; prepare outputs and call bfs(adj, n=7, start=0, dist, order, &count)
  store i64 0, i64* %count, align 8
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %count)

  ; printf("BFS order from %zu: ", 0)
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs_from, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 0)

  ; loop over order[0..count-1]
  br label %loop1

loop1:                                            ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cnt = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i, %cnt
  br i1 %cmp, label %loop1.body, label %after.loop1

loop1.body:                                       ; preds = %loop1
  %i.plus1 = add i64 %i, 1
  %cnt2 = load i64, i64* %count, align 8
  %is_last = icmp uge i64 %i.plus1, %cnt2
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.sp, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sep = select i1 %is_last, i8* %empty.ptr, i8* %sp.ptr
  %val.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_zu_s, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %val, i8* %sep)
  %i.next = add i64 %i, 1
  br label %loop1

after.loop1:                                      ; preds = %loop1
  %pc = call i32 @putchar(i32 10)

  ; for j in [0, n)
  br label %loop2

loop2:                                            ; preds = %loop2.body, %after.loop1
  %j = phi i64 [ 0, %after.loop1 ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 7
  br i1 %cmp2, label %loop2.body, label %exit

loop2.body:                                       ; preds = %loop2
  %dptr = getelementptr inbounds i32, i32* %dist.base, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 0, i64 %j, i32 %dval)
  %j.next = add i64 %j, 1
  br label %loop2

exit:                                             ; preds = %loop2
  ret i32 0
}