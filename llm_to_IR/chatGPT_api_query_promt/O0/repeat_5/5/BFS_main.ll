; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [8 x i32], align 16
  %order = alloca [8 x i64], align 16
  %order_len = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %k = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; memset adj to zero (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %adj.i8, i8 0, i64 196, i1 false)

  ; Set edges: adj[n] = 1
  %nv = load i64, i64* %n, align 8
  %p0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %nv
  store i32 1, i32* %p0, align 4

  ; adj[2n] = 1
  %mul2 = mul i64 %nv, 2
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %p1, align 4

  ; adj[n+3] = 1
  %add_n_3 = add i64 %nv, 3
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_n_3
  store i32 1, i32* %p2, align 4

  ; adj[3n+1] = 1
  %mul3 = mul i64 %nv, 3
  %add_3n_1 = add i64 %mul3, 1
  %p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_3n_1
  store i32 1, i32* %p3, align 4

  ; adj[n+4] = 1
  %add_n_4 = add i64 %nv, 4
  %p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_n_4
  store i32 1, i32* %p4, align 4

  ; adj[4n+1] = 1
  %mul4 = mul i64 %nv, 4
  %add_4n_1 = add i64 %mul4, 1
  %p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_4n_1
  store i32 1, i32* %p5, align 4

  ; adj[2n+5] = 1
  %add_2n_5 = add i64 %mul2, 5
  %p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_2n_5
  store i32 1, i32* %p6, align 4

  ; adj[5n+2] = 1
  %mul5 = mul i64 %nv, 5
  %add_5n_2 = add i64 %mul5, 2
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_5n_2
  store i32 1, i32* %p7, align 4

  ; adj[4n+5] = 1
  %add_4n_5 = add i64 %mul4, 5
  %p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_4n_5
  store i32 1, i32* %p8, align 4

  ; adj[5n+4] = 1
  %add_5n_4 = add i64 %mul5, 4
  %p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_5n_4
  store i32 1, i32* %p9, align 4

  ; adj[5n+6] = 1
  %add_5n_6 = add i64 %mul5, 6
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_5n_6
  store i32 1, i32* %p10, align 4

  ; adj[6n+5] = 1
  %mul6 = mul i64 %nv, 6
  %add_6n_5 = add i64 %mul6, 5
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %add_6n_5
  store i32 1, i32* %p11, align 4

  ; Call bfs(adj, n, src, dist, order, &order_len)
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist0 = getelementptr inbounds [8 x i32], [8 x i32]* %dist, i64 0, i64 0
  %order0 = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  %n.v = load i64, i64* %n, align 8
  %src.v = load i64, i64* %src, align 8
  call void @bfs(i32* %adj0, i64 %n.v, i64 %src.v, i32* %dist0, i64* %order0, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %src.v)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                          ; preds = %loop1.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                          ; preds = %loop1.cond
  ; choose suffix: (i+1 < len) ? " " : ""
  %ip1 = add i64 %i.cur, 1
  %cond.sp = icmp ult i64 %ip1, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %cond.sp, i8* %space.ptr, i8* %empty.ptr

  ; value = order[i]
  %ord.iptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.iptr, align 8

  ; printf("%zu%s", value, suffix)
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zus, i64 0, i64 0
  %__ = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord.val, i8* %suffix)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                           ; preds = %loop1.cond
  ; putchar('\n')
  %ch = call i32 @putchar(i32 10)

  ; k = 0
  store i64 0, i64* %k, align 8
  br label %loop2.cond

loop2.cond:                                          ; preds = %loop2.body, %loop1.end
  %k.cur = load i64, i64* %k, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %k.cur, %n.cur
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                          ; preds = %loop2.cond
  ; dist[k]
  %dist.kptr = getelementptr inbounds [8 x i32], [8 x i32]* %dist, i64 0, i64 %k.cur
  %dist.k = load i32, i32* %dist.kptr, align 4

  ; printf("dist(%zu -> %zu) = %d\n", src, k, dist[k])
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %___ = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %src.v, i64 %k.cur, i32 %dist.k)

  ; k++
  %k.next = add i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  br label %loop2.cond

loop2.end:                                           ; preds = %loop2.cond
  ret i32 0
}