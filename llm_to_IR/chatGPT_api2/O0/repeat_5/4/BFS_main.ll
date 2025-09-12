; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7-node undirected graph adjacency matrix, run BFS from source 0, then print BFS order and distances (confidence=0.95). Evidence: 7x7 matrix indices set symmetrically; call to bfs with (adj, n, src, dist, order, order_len) and prints using "%zu" and distances.
; Preconditions: bfs(i32* adj, i64 n, i64 src, i32* dist, i64* order, i64* order_len) expects adj to be n*n ints (row-major), dist/order buffers of length n, and order_len pointer writable.
; Postconditions: Prints BFS order and distances to stdout.

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  ; stack protector setup
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8

  ; n = 7, src = 0
  store i64 0, i64* %order_len, align 8

  ; zero adj[49] (196 bytes)
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; adj[0][1] = 1  -> index 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  ; adj[1][0] = 1  -> index 7
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  ; adj[0][2] = 1  -> index 2
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  ; adj[2][0] = 1  -> index 14
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  ; adj[1][3] = 1  -> index 10
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  ; adj[3][1] = 1  -> index 22
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  ; adj[1][4] = 1  -> index 11
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  ; adj[4][1] = 1  -> index 29
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  ; adj[2][5] = 1  -> index 19
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  ; adj[5][2] = 1  -> index 37
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  ; adj[4][5] = 1  -> index 33
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  ; adj[5][4] = 1  -> index 39
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  ; adj[5][6] = 1  -> index 41
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  ; adj[6][5] = 1  -> index 47
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt.header = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %call.ph = call i32 (i8*, ...) @printf(i8* %fmt.header, i64 0)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], (i+1<len)?" ":"")
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:                                   ; preds = %loop_order.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i.val, %len
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:                                   ; preds = %loop_order.cond
  %idx.next = add i64 %i.val, 1
  %sep.choose = icmp ult i64 %idx.next, %len
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %sep.choose, i8* %sp.ptr, i8* %empty.ptr
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.val
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt.pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str.pair, i64 0, i64 0
  %call.loop = call i32 (i8*, ...) @printf(i8* %fmt.pair, i64 %ord.val, i8* %sep)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:                                    ; preds = %loop_order.cond
  %nl = call i32 @putchar(i32 10)

  ; for (j = 0; j < 7; ++j) printf("dist(%zu -> %zu) = %d\n", 0, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %loop_dist.cond

loop_dist.cond:                                    ; preds = %loop_dist.body, %loop_order.end
  %j.val = load i64, i64* %j, align 8
  %cmpj = icmp ult i64 %j.val, 7
  br i1 %cmpj, label %loop_dist.body, label %ret.check

loop_dist.body:                                    ; preds = %loop_dist.cond
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.val
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 0, i64 %j.val, i32 %d.val)
  %j.inc = add i64 %j.val, 1
  store i64 %j.inc, i64* %j, align 8
  br label %loop_dist.cond

ret.check:                                         ; preds = %loop_dist.cond
  ; stack protector check
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard1, %saved
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %ret.check
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %ret.check
  ret i32 0
}