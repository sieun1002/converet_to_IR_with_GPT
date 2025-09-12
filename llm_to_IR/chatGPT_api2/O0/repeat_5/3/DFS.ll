; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix for an undirected graph, run DFS preorder from node 0, and print the order (confidence=0.90). Evidence: call to dfs with (adjacency, n=7, start=0, out, out_len); prints "DFS preorder from %zu: " and iterates over recorded order.
; Preconditions: dfs expects a row-major n*n i32 adjacency matrix; out buffer capacity >= n; out_len initially 0.
; Postconditions: Prints DFS preorder and a newline; returns 0.

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
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

  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out0 = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj0, i64 7, i64 0, i64* %out0, i64* %out_len)

  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %callhdr = call i32 @printf(i8* %fmt0, i64 0)

  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %i1 = add i64 %i, 1
  %len2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %i1, %len2
  %spcptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.spc, i64 0, i64 0
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %has_space, i8* %spcptr, i8* %emptyptr

  %valptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %valptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %callitem = call i32 @printf(i8* %fmt1, i64 %val, i8* %suffix)

  %inc = add i64 %i, 1
  br label %loop.cond

after.loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}