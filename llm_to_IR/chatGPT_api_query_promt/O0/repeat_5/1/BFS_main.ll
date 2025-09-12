; ModuleID = 'main_from_disasm'
source_filename = "main.ll"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; zero adjacency matrix (49 ints = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set symmetric undirected edges:
  ; indices: 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %p1  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p7  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  ; init outputs
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, n=7, src=0, dist, order, &order_len)
  %adj.ptr   = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr  = getelementptr inbounds [7 x i32],  [7 x i32]*  %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64],  [7 x i64]*  %order, i64 0, i64 0
  call void @bfs(i32* %adj.ptr, i64 7, i64 0, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  ; print header
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 0)

  ; print BFS order
  store i64 0, i64* %i, align 8
order.loop.cond:
  %i.val = load i64, i64* %i, align 8
  %len   = load i64, i64* %order_len, align 8
  %cont  = icmp ult i64 %i.val, %len
  br i1 %cont, label %order.loop.body, label %order.loop.end

order.loop.body:
  %next = add i64 %i.val, 1
  %has_space = icmp ult i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.val
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt.zu.s = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.zu.s, i64 %ord.elem, i8* %sep)

  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %order.loop.cond

order.loop.end:
  call i32 @putchar(i32 10)

  ; print distances
  store i64 0, i64* %j, align 8
dist.loop.cond:
  %j.val = load i64, i64* %j, align 8
  %j.cont = icmp ult i64 %j.val, 7
  br i1 %j.cont, label %dist.loop.body, label %dist.loop.end

dist.loop.body:
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.val
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 0, i64 %j.val, i32 %d.val)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist.loop.cond

dist.loop.end:
  ret i32 0
}