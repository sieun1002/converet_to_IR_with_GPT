; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [48 x i32], align 16
  %order = alloca [8 x i64], align 16
  %outLen = alloca i64, align 8
  %start = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7
  store i64 7, i64* %n, align 8

  ; memset adj to 0 (48 * 4 = 192 bytes)
  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  ; adj[1] = 1
  %adj.idx1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4

  ; adj[2] = 1
  %adj.idx2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4

  ; load n
  %n.val = load i64, i64* %n, align 8

  ; adj[n] = 1
  %adj.n = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %n.val
  store i32 1, i32* %adj.n, align 4

  ; adj[2*n] = 1
  %mul2 = shl i64 %n.val, 1
  %adj.2n = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %adj.2n, align 4

  ; adj[n + 3] = 1
  %n.plus3 = add i64 %n.val, 3
  %adj.n3 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %n.plus3
  store i32 1, i32* %adj.n3, align 4

  ; adj[3*n + 1] = 1
  %mul3 = add i64 %mul2, %n.val          ; 2n + n = 3n
  %idx.3n1 = add i64 %mul3, 1
  %adj.3n1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.3n1
  store i32 1, i32* %adj.3n1, align 4

  ; adj[n + 4] = 1
  %n.plus4 = add i64 %n.val, 4
  %adj.n4 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %n.plus4
  store i32 1, i32* %adj.n4, align 4

  ; adj[4*n + 1] = 1
  %mul4 = shl i64 %n.val, 2              ; 4n
  %idx.4n1 = add i64 %mul4, 1
  %adj.4n1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.4n1
  store i32 1, i32* %adj.4n1, align 4

  ; adj[2*n + 5] = 1
  %idx.2n5 = add i64 %mul2, 5
  %adj.2n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.2n5
  store i32 1, i32* %adj.2n5, align 4

  ; adj[5*n + 2] = 1  (4n + n + 2)
  %mul5 = add i64 %mul4, %n.val          ; 5n
  %idx.5n2 = add i64 %mul5, 2
  %adj.5n2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.5n2
  store i32 1, i32* %adj.5n2, align 4

  ; adj[4*n + 5] = 1
  %idx.4n5 = add i64 %mul4, 5
  %adj.4n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.4n5
  store i32 1, i32* %adj.4n5, align 4

  ; adj[5*n + 4] = 1
  %idx.5n4 = add i64 %mul5, 4
  %adj.5n4 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.5n4
  store i32 1, i32* %adj.5n4, align 4

  ; adj[5*n + 6] = 1
  %idx.5n6 = add i64 %mul5, 6
  %adj.5n6 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.5n6
  store i32 1, i32* %adj.5n6, align 4

  ; adj[6*n + 5] = 1  ((3n)*2 + 5)
  %mul6 = shl i64 %mul3, 1               ; 6n
  %idx.6n5 = add i64 %mul6, 5
  %adj.6n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %idx.6n5
  store i32 1, i32* %adj.6n5, align 4

  ; start = 0
  store i64 0, i64* %start, align 8

  ; outLen = 0
  store i64 0, i64* %outLen, align 8

  ; call dfs(adj, n, start, order, &outLen)
  %order.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  call void @dfs(i32* getelementptr inbounds ([48 x i32], [48 x i32]* %adj, i64 0, i64 0),
                 i64 %n.val,
                 i64 0,
                 i64* %order.ptr,
                 i64* %outLen)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.header = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt.header, i64 %start.val)

  ; for (i = 0; i < outLen; ++i) printf("%zu%s", order[i], (i+1 < outLen) ? " " : "")
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %outLen, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose separator
  %i.plus1 = add i64 %i.cur, 1
  %hasSpace = icmp ult i64 %i.plus1, %len.cur
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %hasSpace, i8* %sep.space, i8* %sep.empty

  ; load value
  %item.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %i.cur
  %item.val = load i64, i64* %item.ptr, align 8

  ; printf("%zu%s", item, sep)
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.item = call i32 (i8*, ...) @printf(i8* %fmt.item, i64 %item.val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; newline
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}