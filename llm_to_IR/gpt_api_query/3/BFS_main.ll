; ModuleID = 'recovered.ll'
source_filename = "recovered.c"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %orderLen = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %k = alloca i64, align 8

  ; src = 0, orderLen = 0
  store i64 0, i64* %src, align 8
  store i64 0, i64* %orderLen, align 8

  ; memset adj to zero (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; adjacency matrix entries set to 1 (column-major: index = col*7 + row)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0

  ; idx 7  -> (row 0, col 1)
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4

  ; idx 14 -> (row 0, col 2)
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4

  ; idx 10 -> (row 3, col 1)
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4

  ; idx 22 -> (row 1, col 3)
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4

  ; idx 11 -> (row 4, col 1)
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4

  ; idx 29 -> (row 1, col 4)
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4

  ; idx 19 -> (row 5, col 2)
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4

  ; idx 37 -> (row 2, col 5)
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4

  ; idx 33 -> (row 5, col 4)
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4

  ; idx 39 -> (row 4, col 5)
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4

  ; idx 41 -> (row 6, col 5)
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4

  ; idx 47 -> (row 5, col 6)
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, 7, src, dist, order, &orderLen)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 7, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %orderLen)

  ; printf("BFS order from %zu: ", src)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %src.val2 = load i64, i64* %src, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.val2)

  ; for (i = 0; i < orderLen; ++i) print "%zu%s"
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %orderLen, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:
  %next = add i64 %i.cur, 1
  %is_last = icmp uge i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr

  %ord.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %ord.ptr = getelementptr inbounds i64, i64* %ord.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.ptr, align 8

  %fmt.zus = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zus, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.zus, i64 %ord.val, i8* %delim)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:
  ; putchar('\n')
  %call2 = call i32 @putchar(i32 10)

  ; for (k = 0; k < 7; ++k) printf("dist(%zu -> %zu) = %d\n", src, k, dist[k])
  store i64 0, i64* %k, align 8
  br label %loop_dist.cond

loop_dist.cond:
  %k.cur = load i64, i64* %k, align 8
  %cmpk = icmp ult i64 %k.cur, 7
  br i1 %cmpk, label %loop_dist.body, label %loop_dist.end

loop_dist.body:
  %d.ptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %k.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.val3, i64 %k.cur, i32 %d.val)
  %k.next = add i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  br label %loop_dist.cond

loop_dist.end:
  ret i32 0
}