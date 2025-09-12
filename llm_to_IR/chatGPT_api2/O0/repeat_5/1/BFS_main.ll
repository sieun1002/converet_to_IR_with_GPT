; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7-node undirected graph (adjacency matrix), run BFS from node 0, then print BFS order and per-node distances (confidence=0.95). Evidence: initializes a 7x7 i32 matrix with symmetric 1s; calls bfs with matrix, n, src, dist, order, order_len; prints "%zu%s" list and "dist(%zu -> %zu) = %d".
; Preconditions: bfs expects: i32* adj (n*n row-major), i64 n, i64 src, i32* dist[n], i64* order[n], i64* order_len (output count).
; Postconditions: Prints BFS visitation order and distances from src.

@.str.hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; constants
  %adj.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.i32 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.i64 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0

  ; memset adj[49] = 0
  %adj.bc = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bc, i8 0, i64 196, i1 false)

  ; set specific edges to 1
  %p1 = getelementptr inbounds i32, i32* %adj.i32, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.i32, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.i32, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.i32, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.i32, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.i32, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.i32, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.i32, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.i32, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.i32, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.i32, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.i32, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.i32, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.i32, i64 47
  store i32 1, i32* %p47, align 4

  ; order_len = 0
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  call void @bfs(i32* %adj.i32, i64 7, i64 0, i32* %dist.i32, i64* %order.i64, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %hdr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.hdr, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* %hdr, i64 0)

  ; for (j = 0; j < order_len; ++j) print "%zu%s"
  store i64 0, i64* %j, align 8
  br label %order.cond

order.cond:
  %j.val = load i64, i64* %j, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cmp.ol = icmp ult i64 %j.val, %len.cur
  br i1 %cmp.ol, label %order.body, label %order.end

order.body:
  %j.next = add i64 %j.val, 1
  %len.cur2 = load i64, i64* %order_len, align 8
  %has_more = icmp ult i64 %j.next, %len.cur2
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.sel = select i1 %has_more, i8* %sep.space.ptr, i8* %sep.empty.ptr

  %elem.ptr = getelementptr inbounds i64, i64* %order.i64, i64 %j.val
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt_elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zus, i64 0, i64 0
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt_elem, i64 %elem, i8* %sep.sel)

  %j.inc = add i64 %j.val, 1
  store i64 %j.inc, i64* %j, align 8
  br label %order.cond

order.end:
  %nl = call i32 @putchar(i32 10)

  ; for (i = 0; i < 7; ++i) printf("dist(%zu -> %zu) = %d\n", 0, i, dist[i])
  store i64 0, i64* %i, align 8
  br label %dist.cond

dist.cond:
  %i.val = load i64, i64* %i, align 8
  %cmp.n = icmp ult i64 %i.val, 7
  br i1 %cmp.n, label %dist.body, label %dist.end

dist.body:
  %di.ptr = getelementptr inbounds i32, i32* %dist.i32, i64 %i.val
  %di = load i32, i32* %di.ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 0, i64 %i.val, i32 %di)
  %i.inc = add i64 %i.val, 1
  store i64 %i.inc, i64* %i, align 8
  br label %dist.cond

dist.end:
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)