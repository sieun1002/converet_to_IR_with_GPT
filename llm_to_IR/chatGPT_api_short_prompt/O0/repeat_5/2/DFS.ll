; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: build a 7x7 undirected graph adjacency matrix, run dfs to get preorder from 0, and print it (confidence=0.86). Evidence: matrix sized 49 ints with symmetric edge writes; call dfs(arr,n,start,buf,len) then printf loop with "%zu"
; Preconditions: external dfs(i32*, i64, i64, i64*, i64*) fills out_buf with preorder and sets out_len
; Postconditions: prints "DFS preorder from 0: " followed by preorder elements separated by spaces, then newline

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.sp = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out_buf = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set undirected edges in adjacency matrix (n=7), arr[i*n + j] = 1
  ; (0,1), (1,0)
  %gep1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %gep7, align 4

  ; (0,2), (2,0)
  %gep2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %gep2, align 4
  %gep14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %gep14, align 4

  ; (1,3), (3,1)
  %gep10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %gep10, align 4
  %gep22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %gep22, align 4

  ; (1,4), (4,1)
  %gep11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %gep11, align 4
  %gep29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %gep29, align 4

  ; (2,5), (5,2)
  %gep19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %gep19, align 4
  %gep37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %gep37, align 4

  ; (4,5), (5,4)
  %gep33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %gep33, align 4
  %gep39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %gep39, align 4

  ; (5,6), (6,5)
  %gep41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %gep41, align 4
  %gep47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %gep47, align 4

  ; call dfs(adj, n, start, out_buf, &out_len)
  %adj.el0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %outbuf.el0 = getelementptr inbounds [8 x i64], [8 x i64]* %out_buf, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.el0, i64 %n.val, i64 %start.val, i64* %outbuf.el0, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.val)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out_buf[i], (i+1<out_len)?" ":"")
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %next = add i64 %i.cur, 1
  %sep.sp = icmp ult i64 %next, %len.cur
  %sp.ptr = select i1 %sep.sp, i8* getelementptr inbounds([2 x i8], [2 x i8]* @.sp, i64 0, i64 0), i8* getelementptr inbounds([1 x i8], [1 x i8]* @.empty, i64 0, i64 0)
  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out_buf, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %elem, i8* %sp.ptr)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)