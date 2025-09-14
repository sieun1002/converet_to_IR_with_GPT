; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a fixed 7-node directed graph, run bfs from source 0, then print BFS order and distances (confidence=0.93). Evidence: call to bfs with (adjacency,n,src,dist,order,order_len), strings "BFS order from %zu: ", "dist(%zu -> %zu) = %d\n"
; Preconditions: bfs expects an n x n adjacency matrix of i32 with 1 indicating an edge, n=7, src=0
; Postconditions: Prints BFS order and per-node distances; returns 0

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.sp = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; initialize adjacency matrix to zero
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; n = 7, src = 0; build directed edges by setting adj[i*n + j] = 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; indices set to 1: 7, 14, 10, 22, 11, 29, 19, 37, 33, 39, 41, 47
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
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

  ; order_len = 0
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, n=7, src=0, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; print "BFS order from %zu: " with src = 0
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  call i32 @_printf(i8* %fmt_bfs, i64 0)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], (i+1 < order_len) ? " " : "");
  store i64 0, i64* %i, align 8
  br label %ord.loop

ord.loop:
  %i.val = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %i.val, %len
  br i1 %cond, label %ord.body, label %ord.done

ord.body:
  %next = add i64 %i.val, 1
  %more = icmp ult i64 %next, %len
  %sptr.sel = select i1 %more, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.sp, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.empty, i64 0, i64 0)
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.val
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt_pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  call i32 @_printf(i8* %fmt_pair, i64 %ord.elem, i8* %sptr.sel)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %ord.loop

ord.done:
  call i32 @_putchar(i32 10)

  ; print distances
  store i64 0, i64* %j, align 8
  br label %dist.loop

dist.loop:
  %j.val = load i64, i64* %j, align 8
  %cmpj = icmp ult i64 %j.val, 7
  br i1 %cmpj, label %dist.body, label %dist.done

dist.body:
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.val
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  call i32 @_printf(i8* %fmt_dist, i64 0, i64 %j.val, i32 %d.val)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist.loop

dist.done:
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)