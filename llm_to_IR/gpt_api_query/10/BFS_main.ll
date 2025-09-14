; ModuleID = 'bfs_main'
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %order, i64* %order_len)
declare i32 @printf(i8* nocapture readonly, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; n = 7, src = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; order_len = 0
  store i64 0, i64* %order_len, align 8

  ; adj[i*n + j] = 1 for undirected edges:
  ; 0-1, 0-2, 1-3, 1-4, 2-5, 4-5, 5-6 (both directions)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; indices to set to 1:
  ; 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %p1  = getelementptr inbounds i32, i32* %adj.base, i64 1
  %p2  = getelementptr inbounds i32, i32* %adj.base, i64 2
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47

  store i32 1, i32* %p1,  align 4
  store i32 1, i32* %p2,  align 4
  store i32 1, i32* %p7,  align 4
  store i32 1, i32* %p10, align 4
  store i32 1, i32* %p11, align 4
  store i32 1, i32* %p14, align 4
  store i32 1, i32* %p19, align 4
  store i32 1, i32* %p22, align 4
  store i32 1, i32* %p29, align 4
  store i32 1, i32* %p33, align 4
  store i32 1, i32* %p37, align 4
  store i32 1, i32* %p39, align 4
  store i32 1, i32* %p41, align 4
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, n, src, dist, order, &order_len)
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %src.val, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* %fmt.bfs.ptr, i64 %src.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.order.cond

loop.order.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %loop.order.body, label %loop.order.end

loop.order.body:
  ; value = order[i]
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.ptr, align 8
  ; choose separator: " " if i+1 < len else ""
  %i.next = add i64 %i.cur, 1
  %has.next = icmp ult i64 %i.next, %len.cur
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.sel = select i1 %has.next, i8* %sep.space, i8* %sep.empty
  ; printf("%zu%s", order[i], sep)
  %fmt.zu.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.zu.ptr, i64 %ord.val, i8* %sep.sel)
  ; i++
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop.order.cond

loop.order.end:
  ; putchar('\n')
  %nl = call i32 @putchar(i32 10)

  ; print distances for v = 0..n-1
  store i64 0, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.cond:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond2 = icmp ult i64 %j.cur, %n.cur
  br i1 %cond2, label %loop.dist.body, label %loop.dist.end

loop.dist.body:
  ; dist[j]
  %dj.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %dj.val = load i32, i32* %dj.ptr, align 4
  ; printf("dist(%zu -> %zu) = %d\n", src, j, dist[j])
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 %src.val, i64 %j.cur, i32 %dj.val)
  ; j++
  %j.inc = add i64 %j.cur, 1
  store i64 %j.inc, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.end:
  ret i32 0
}