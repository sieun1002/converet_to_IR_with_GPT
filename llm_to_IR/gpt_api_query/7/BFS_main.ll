; target triple can be set by your toolchain; IR is compatible with LLVM 14

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %order, i64* %order_len)

@.str.bfs   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep   = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  ; locals
  %adj        = alloca [49 x i32], align 16
  %dist       = alloca [7 x i32], align 16
  %order      = alloca [7 x i64], align 16
  %n          = alloca i64, align 8
  %src        = alloca i64, align 8
  %order_len  = alloca i64, align 8
  %i          = alloca i64, align 8
  %j          = alloca i64, align 8

  ; n = 7, src = 0, order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; build undirected graph edges (n = 7), adjacency stored row-major
  ; 0-1, 0-2, 1-3, 1-4, 2-5, 4-5, 5-6
  ; [0,1] and [1,0]
  %p1  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p7  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  ; [0,2] and [2,0]
  %p2  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  ; [1,3] and [3,1]
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  ; [1,4] and [4,1]
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  ; [2,5] and [5,2]
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  ; [4,5] and [5,4]
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  ; [5,6] and [6,5]
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, n, src, dist, order, &order_len)
  %adj.decay   = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.decay  = getelementptr inbounds [7 x i32],  [7 x i32]*  %dist, i64 0, i64 0
  %order.decay = getelementptr inbounds [7 x i64],  [7 x i64]*  %order, i64 0, i64 0
  %n.val       = load i64, i64* %n, align 8
  %src.val     = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.decay, i64 %n.val, i64 %src.val, i32* %dist.decay, i64* %order.decay, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %src.val2 = load i64, i64* %src, align 8
  call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.val2)

  ; for (i = 0; i < order_len; ++i) print "%zu%s" with sep = " " except last => ""
  store i64 0, i64* %i, align 8
  br label %loop.order.cond

loop.order.cond:
  %i.cur   = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %lt      = icmp ult i64 %i.cur, %len.cur
  br i1 %lt, label %loop.order.body, label %loop.order.end

loop.order.body:
  ; choose separator: (i+1 < len) ? " " : ""
  %i.plus1 = add i64 %i.cur, 1
  %has.space = icmp ult i64 %i.plus1, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.space, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; load order[i]
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8

  ; printf("%zu%s", ord.val, sep)
  %fmt.zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.zu_s, i64 %ord.val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.order.cond

loop.order.end:
  ; newline
  call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", src, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.cond:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %lt2   = icmp ult i64 %j.cur, %n.cur
  br i1 %lt2, label %loop.dist.body, label %done

loop.dist.body:
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.val3, i64 %j.cur, i32 %dist.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop.dist.cond

done:
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)