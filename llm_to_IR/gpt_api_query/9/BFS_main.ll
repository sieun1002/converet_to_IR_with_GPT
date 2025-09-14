; ModuleID = 'main_from_disasm'
source_filename = "main_from_disasm"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.sep_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.fmt_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.fmt_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  ; constants
  ; n = 7, start = 0

  ; memset adj[49] = 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Build undirected graph (n = 7), adjacency matrix in row-major adj[u*n + v] = 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0

  ; (0,1), (0,2)
  %p01 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p01, align 4
  %p02 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p02, align 4

  ; (1,0), (2,0)
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p10, align 4
  %p20 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p20, align 4

  ; (1,3), (3,1)
  %p13 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p13, align 4
  %p31 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p31, align 4

  ; (1,4), (4,1)
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p14, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p41, align 4

  ; (2,5), (5,2)
  %p25 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p25, align 4
  %p52 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p52, align 4

  ; (4,5), (5,4)
  %p45 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p45, align 4
  %p54 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p54, align 4

  ; (5,6), (6,5)
  %p56 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p56, align 4
  %p65 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p65, align 4

  ; order_len = 0
  store i64 0, i64* %order_len, align 8

  ; Call bfs(adj, n=7, start=0, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", start)
  %hdrp = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %hdrp.i8 = bitcast i8* %hdrp to i8*
  %_ = call i32 (i8*, ...) @printf(i8* %hdrp.i8, i64 0)

  ; i = 0
  br label %order.loop.cond

order.loop.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %order.loop.body ]
  %len.cur = load i64, i64* %order_len, align 8
  %i.lt.len = icmp ult i64 %i, %len.cur
  br i1 %i.lt.len, label %order.loop.body, label %order.loop.end

order.loop.body:
  ; sep = (i+1 < len) ? " " : ""
  %i.plus1 = add i64 %i, 1
  %i1.lt.len = icmp ult i64 %i.plus1, %len.cur
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep_space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.sep_empty, i64 0, i64 0
  %sep.ptr = select i1 %i1.lt.len, i8* %sep.space, i8* %sep.empty

  ; load order[i]
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i
  %ord.val = load i64, i64* %ord.ptr, align 8

  ; printf("%zu%s", order[i], sep)
  %fmt.pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt_pair, i64 0, i64 0
  %call.pair = call i32 (i8*, ...) @printf(i8* %fmt.pair, i64 %ord.val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i, 1
  br label %order.loop.cond

order.loop.end:
  ; putchar('\n')
  %pc = call i32 @putchar(i32 10)

  ; j loop: print distances
  br label %dist.loop.cond

dist.loop.cond:
  %j = phi i64 [ 0, %order.loop.end ], [ %j.next, %dist.loop.body ]
  %j.lt.n = icmp ult i64 %j, 7
  br i1 %j.lt.n, label %dist.loop.body, label %done

dist.loop.body:
  ; load dist[j]
  %dj.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j
  %dj = load i32, i32* %dj.ptr, align 4

  ; printf("dist(%zu -> %zu) = %d\n", start, j, dist[j])
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.fmt_dist, i64 0, i64 0
  %call.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 0, i64 %j, i32 %dj)

  ; j++
  %j.next = add i64 %j, 1
  br label %dist.loop.cond

done:
  ret i32 0
}