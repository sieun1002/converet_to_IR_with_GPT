; ModuleID = 'main.ll'
source_filename = "main.c"

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_num_sep = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %start = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; n = 7, start = 0, len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  ; zero adjacency matrix: 49 * 4 = 196 bytes
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges (adjacency matrix entries to 1)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; indices: 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %idx1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2, align 4
  %idx7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %idx7, align 4
  %idx10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx10, align 4
  %idx11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx11, align 4
  %idx14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %idx14, align 4
  %idx19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx19, align 4
  %idx22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx22, align 4
  %idx29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx29, align 4
  %idx33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx33, align 4
  %idx37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx37, align 4
  %idx39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx39, align 4
  %idx41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx41, align 4
  %idx47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx47, align 4

  ; call bfs(adj, n, start, dist, order, &len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %order.base, i64* %len)

  ; printf("BFS order from %zu: ", start)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %start.val2)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.order.cond

loop.order.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp.lt = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.lt, label %loop.order.body, label %loop.order.end

loop.order.body:
  ; sep = (i+1 < len) ? " " : ""
  %i.plus1 = add i64 %i.cur, 1
  %cmp.sep = icmp ult i64 %i.plus1, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.select = select i1 %cmp.sep, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; val = order[i]
  %order.idx.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %order.val = load i64, i64* %order.idx.ptr, align 8

  ; printf("%zu%s", order[i], sep)
  %fmt.num.sep = getelementptr inbounds [6 x i8], [6 x i8]* @.str_num_sep, i64 0, i64 0
  %call.printf.num = call i32 (i8*, ...) @printf(i8* %fmt.num.sep, i64 %order.val, i8* %sep.select)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.order.cond

loop.order.end:
  ; putchar('\n')
  %call.putchar = call i32 @putchar(i32 10)

  ; j = 0
  store i64 0, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.cond:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp.j, label %loop.dist.body, label %loop.dist.end

loop.dist.body:
  ; dist_val = dist[j]
  %dist.idx.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %dist.val32 = load i32, i32* %dist.idx.ptr, align 4
  ; printf("dist(%zu -> %zu) = %d\n", start, j, dist_val)
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start.val3 = load i64, i64* %start, align 8
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %start.val3, i64 %j.cur, i32 %dist.val32)
  ; j++
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.end:
  ret i32 0
}