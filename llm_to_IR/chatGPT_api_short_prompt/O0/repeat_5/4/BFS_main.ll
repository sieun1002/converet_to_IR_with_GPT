; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a 7-node graph adjacency matrix, run bfs to compute order and distances from source 0, and print results (confidence=0.91). Evidence: adjacency matrix writes with n=7; call bfs(adj,n,src,dist,order,len) followed by formatted prints of order and dist.
; Preconditions: bfs expects a row-major n*n int matrix (0/1), and writes distances (int[n]), BFS order (size_t[]), and its length.
; Postconditions: Prints BFS order and dist(src -> v) for all v in [0,n).

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define dso_local i32 @main() local_unnamed_addr {
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

  ; n = 7; src = 0; order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; memset adj[49] = 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges to 1
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj0, align 4
  %adj1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj1, align 4
  %adj2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj2, align 4
  %adj3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj3, align 4
  %adj4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj4, align 4
  %adj5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj5, align 4
  %adj6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj6, align 4
  %adj7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj7, align 4
  %adj8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj8, align 4
  %adj9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj9, align 4
  %adj10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj10, align 4
  %adj11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj11, align 4
  %adj12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj12, align 4

  ; call bfs(adj, n, src, dist, order, order_len)
  %adjptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %distptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %orderptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adjptr, i64 %n.val, i64 %src.val, i32* %distptr, i64* %orderptr, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs, i64 %src.val)

  ; for (i = 0; i < order_len; ++i)
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:                                ; preds = %loop_order.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %olen = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i.cur, %olen
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:                                ; preds = %loop_order.cond
  ; choose separator
  %iplus = add i64 %i.cur, 1
  %has_more = icmp ult i64 %iplus, %olen
  %sp = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %sp, i8* %empty

  ; value = order[i]
  %ord.gep = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.gep, align 8

  ; printf("%zu%s", value, sep)
  %fmt_pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_pair, i64 %ord.val, i8* %sep)

  ; ++i
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:                                 ; preds = %loop_order.cond
  ; putchar('\n')
  %call2 = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", src, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %loop_dist.cond

loop_dist.cond:                                 ; preds = %loop_dist.body, %loop_order.end
  %j.cur = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmpj = icmp ult i64 %j.cur, %n.val2
  br i1 %cmpj, label %loop_dist.body, label %loop_dist.end

loop_dist.body:                                 ; preds = %loop_dist.cond
  %d.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %d.val = load i32, i32* %d.gep, align 4
  %fmt_dist = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dist, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 %src.val3, i64 %j.cur, i32 %d.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop_dist.cond

loop_dist.end:                                  ; preds = %loop_dist.cond
  ret i32 0
}