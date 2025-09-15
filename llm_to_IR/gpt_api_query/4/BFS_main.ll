; ModuleID = 'main_bfs.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.bfs_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %len = alloca i64, align 8
  %k = alloca i64, align 8
  %v = alloca i64, align 8

  ; n = 7; src = 0; len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %len, align 8

  ; zero adj[48]
  %adj.bytes = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %adj.bytes, i8 0, i64 192, i1 false)

  ; Build undirected edges in adjacency matrix (flattened, row-major, n = 7)
  ; Set adj[1], adj[2], adj[7], adj[14], adj[10], adj[22], adj[11], adj[29],
  ;     adj[19], adj[37], adj[33], adj[39], adj[41], adj[47] = 1
  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %p1  = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2  = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, n, src, dist, order, &len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %src.val, i32* %dist.base, i64* %order.base, i64* %len)

  ; printf("BFS order from %zu: ", src)
  %hdr.ptr = bitcast [21 x i8]* @.str.bfs_header to i8*
  %src.for.print = load i64, i64* %src, align 8
  %call.hdr = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 %src.for.print)

  ; for (k = 0; k < len; ++k) print "%zu%s" order[k], (k+1<len ? " " : "")
  store i64 0, i64* %k, align 8
  br label %loop.bfs

loop.bfs:
  %k.cur = load i64, i64* %k, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %k.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %kp1 = add i64 %k.cur, 1
  %need.space = icmp ult i64 %kp1, %len.cur
  %space.ptr = select i1 %need.space, i8* bitcast ([2 x i8]* @.str.space to i8*), i8* bitcast ([1 x i8]* @.str.empty to i8*)
  %ord.gep = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %k.cur
  %ord.val = load i64, i64* %ord.gep, align 8
  %pair.ptr = bitcast [6 x i8]* @.str.pair to i8*
  %call.pair = call i32 (i8*, ...) @printf(i8* %pair.ptr, i64 %ord.val, i8* %space.ptr)
  %k.next = add i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  br label %loop.bfs

loop.end:
  %nl = call i32 @putchar(i32 10)

  ; for (v = 0; v < n; ++v) printf("dist(%zu -> %zu) = %d\n", src, v, dist[v])
  store i64 0, i64* %v, align 8
  br label %loop.dist

loop.dist:
  %v.cur = load i64, i64* %v, align 8
  %n.cur2 = load i64, i64* %n, align 8
  %cmp.v = icmp ult i64 %v.cur, %n.cur2
  br i1 %cmp.v, label %dist.body, label %dist.end

dist.body:
  %d.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.cur
  %d.val = load i32, i32* %d.gep, align 4
  %dist.ptr = bitcast [23 x i8]* @.str.dist to i8*
  %src.print2 = load i64, i64* %src, align 8
  %call.dist = call i32 (i8*, ...) @printf(i8* %dist.ptr, i64 %src.print2, i64 %v.cur, i32 %d.val)
  %v.next = add i64 %v.cur, 1
  store i64 %v.next, i64* %v, align 8
  br label %loop.dist

dist.end:
  ret i32 0
}

; memset intrinsic
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)