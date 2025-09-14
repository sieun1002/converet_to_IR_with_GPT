; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 undirected graph adjacency matrix, run DFS preorder from node 0, and print the traversal (confidence=0.71). Evidence: n=7-derived index math (i*n+j), strings "DFS preorder from %zu: " and "%zu%s".
; Preconditions: dfs expects row-major n*n int matrix; out_nodes has capacity >= n; 0 <= start < n.
; Postconditions: Prints "DFS preorder from 0: " followed by the preorder list.

; Only the necessary external declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@space = private unnamed_addr constant [2 x i8] c" \00", align 1
@empty = private unnamed_addr constant [1 x i8] c"\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out_nodes = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8
  ; zero adjacency matrix
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  ; set undirected edges: 0-1, 0-2, 1-3, 1-4, 2-5, 4-5, 5-6
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj0, align 4
  %adj1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj1, align 4
  %adj2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj2, align 4
  %adj3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj3, align 4
  %adj4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj4, align 4
  %adj5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj5, align 4
  %adj6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj6, align 4
  %adj7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj7, align 4
  %adj8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj8, align 4
  %adj9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj9, align 4
  %adj10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj10, align 4
  %adj11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj11, align 4
  %adj12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj12, align 4
  %adj13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj13, align 4
  ; initialize start and out_len
  store i64 0, i64* %out_len, align 8
  store i64 0, i64* %start, align 8
  ; call dfs(adj, n=7, start=0, out_nodes, &out_len)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out_nodes.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out_nodes, i64 0, i64 0
  call void @dfs(i32* %adj.ptr, i64 7, i64 0, i64* %out_nodes.ptr, i64* %out_len)
  ; printf("DFS preorder from %zu: ", 0)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @format, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start.val)
  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out_nodes[i], (i+1<out_len)?" ":"")
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i64 [ 0, %entry ], [ %inc, %loop ]
  %len = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %next = add i64 %i, 1
  %islast = icmp uge i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @empty, i64 0, i64 0
  %sep = select i1 %islast, i8* %empty.ptr, i8* %space.ptr
  %node.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out_nodes, i64 0, i64 %i
  %node = load i64, i64* %node.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %node, i8* %sep)
  %inc = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1) nounwind argmemonly