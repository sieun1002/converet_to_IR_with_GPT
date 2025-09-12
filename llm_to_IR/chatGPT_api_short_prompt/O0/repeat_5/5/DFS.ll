; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run DFS preorder from vertex 0, and print the order (confidence=0.92). Evidence: "DFS preorder from %zu: " format string; call to dfs with matrix, n=7, start=0, output buffer and length.

; Preconditions: dfs expects an n*n int matrix (row-major), n=7, start within [0,n), and output buffer large enough (>= n).
; Postconditions: Prints "DFS preorder from 0: " followed by the vertices in preorder, separated by spaces, then newline.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.fmt1 = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.spc  = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7, start = 0, out_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; zero adj matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set undirected edges:
  ; (0,1),(1,0)
  %p01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p01, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p10, align 4

  ; (0,2),(2,0)
  %p02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p02, align 4
  %p20 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p20, align 4

  ; (1,3),(3,1)
  %p13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p13, align 4
  %p31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p31, align 4

  ; (1,4),(4,1)
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p14, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p41, align 4

  ; (2,5),(5,2)
  %p25 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p25, align 4
  %p52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p52, align 4

  ; (4,5),(5,4)
  %p45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p45, align 4
  %p54 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p54, align 4

  ; (5,6),(6,5)
  %p56 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p56, align 4
  %p65 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p65, align 4

  ; call dfs(adj, n, start, out, &out_len)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt1.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt1, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %start.print)

  ; for (i = 0; i < out_len; ++i) print "%zu%s" with space except last element
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %next = add i64 %i.cur, 1
  %has_next = icmp ult i64 %next, %len
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %delim.ptr = select i1 %has_next, i8* %spc.ptr, i8* %empty.ptr

  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8

  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %elem, i8* %delim.ptr)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}