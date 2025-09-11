; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7-node undirected graph (adjacency matrix) and print a DFS preorder from node 0 via external dfs (confidence=0.92). Evidence: N=7 matrix initialization; format strings "DFS preorder from %zu: " and "%zu%s"
; Preconditions: Assumes extern: void dfs(i32* adj, i64 n, i64 start, i64* out, i64* out_len). adj is N*N row-major, values 0/1. out has capacity >= n.
; Postconditions: Prints traversal and newline; returns 0.

@.str_heading = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [64 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8
  %N = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %N, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  %Nval = load i64, i64* %N, align 8
  %twoN = add i64 %Nval, %Nval
  %threeN = add i64 %twoN, %Nval
  %fourN = add i64 %twoN, %twoN
  %fiveN = add i64 %fourN, %Nval
  %sixN = add i64 %threeN, %threeN

  ; adj[1] = 1
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  ; adj[2] = 1
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  ; adj[N] = 1
  %pN = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nval
  store i32 1, i32* %pN, align 4
  ; adj[2N] = 1
  %p2N = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoN
  store i32 1, i32* %p2N, align 4
  ; adj[N+3] = 1
  %Nplus3 = add i64 %Nval, 3
  %pN3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus3
  store i32 1, i32* %pN3, align 4
  ; adj[3N+1] = 1
  %threeNplus1 = add i64 %threeN, 1
  %p3N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threeNplus1
  store i32 1, i32* %p3N1, align 4
  ; adj[N+4] = 1
  %Nplus4 = add i64 %Nval, 4
  %pN4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus4
  store i32 1, i32* %pN4, align 4
  ; adj[4N+1] = 1
  %fourNplus1 = add i64 %fourN, 1
  %p4N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus1
  store i32 1, i32* %p4N1, align 4
  ; adj[2N+5] = 1
  %twoNplus5 = add i64 %twoN, 5
  %p2N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoNplus5
  store i32 1, i32* %p2N5, align 4
  ; adj[5N+2] = 1
  %fiveNplus2 = add i64 %fiveN, 2
  %p5N2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus2
  store i32 1, i32* %p5N2, align 4
  ; adj[4N+5] = 1
  %fourNplus5 = add i64 %fourN, 5
  %p4N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus5
  store i32 1, i32* %p4N5, align 4
  ; adj[5N+4] = 1
  %fiveNplus4 = add i64 %fiveN, 4
  %p5N4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus4
  store i32 1, i32* %p5N4, align 4
  ; adj[5N+6] = 1
  %fiveNplus6 = add i64 %fiveN, 6
  %p5N6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus6
  store i32 1, i32* %p5N6, align 4
  ; adj[6N+5] = 1
  %sixNplus5 = add i64 %sixN, 5
  %p6N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixNplus5
  store i32 1, i32* %p6N5, align 4

  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %start_val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj_ptr, i64 %Nval, i64 %start_val, i64* %out_ptr, i64* %out_len)

  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_heading, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start_val)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.next = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.next, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space_ptr, i8* %empty_ptr

  %elt_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i.cur
  %elt = load i64, i64* %elt_ptr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elt, i8* %sep)

  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %_ = call i32 @putchar(i32 10)
  ret i32 0
}