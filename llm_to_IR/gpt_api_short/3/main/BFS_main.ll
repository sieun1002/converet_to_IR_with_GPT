; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: BFS driver: build 7x7 adjacency matrix, run bfs, print order and distances (confidence=0.86). Evidence: builds symmetric 7x7 int matrix; prints "BFS order..." and "dist(...)=..." using arrays filled by bfs.
; Preconditions: None
; Postconditions: Prints BFS visit order and per-vertex distances from start 0.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.sep.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; n = 7; start = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8

  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set symmetric undirected edges:
  ; edges: (0,1),(1,0),(0,2),(2,0),(1,3),(3,1),(1,4),(4,1),(2,5),(5,2),(4,5),(5,4),(5,6),(6,5)
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

  ; order_len = 0
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, n, start, dist, order, &order_len)
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", start)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start.val2)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], (i+1<order_len) ? " " : "")
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %loop1.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond1 = icmp ult i64 %i.cur, %len.cur
  br i1 %cond1, label %loop1.body, label %after1

loop1.body:                                       ; preds = %loop1
  %next = add i64 %i.cur, 1
  %hasnext = icmp ult i64 %next, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.sep.empty, i64 0, i64 0
  %sep.ptr = select i1 %hasnext, i8* %sep.space.ptr, i8* %sep.empty.ptr
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord.elem, i8* %sep.ptr)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  %putc = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", start, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %loop2.body, %after1
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond2 = icmp ult i64 %j.cur, %n.cur
  br i1 %cond2, label %loop2.body, label %after2

loop2.body:                                       ; preds = %loop2
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %start.val3 = load i64, i64* %start, align 8
  %call.printf3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %start.val3, i64 %j.cur, i32 %d.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  ret i32 0
}