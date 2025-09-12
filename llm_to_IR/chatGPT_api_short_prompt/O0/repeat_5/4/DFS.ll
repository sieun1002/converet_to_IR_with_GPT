; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run DFS from node 0, and print preorder (confidence=0.79). Evidence: printf strings, dfs call with (adj, n, start, out, out_len), loop printing "%zu%s".
; Preconditions: dfs expects adjacency as a flattened n*n i32 matrix, n=7, start=0, and outputs nodes into out/out_len.
; Postconditions: Prints "DFS preorder from 0: " followed by nodes separated by spaces and a trailing newline.

; Only the necessary external declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str.space = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty = private unnamed_addr constant [1 x i8] c"\00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8

  ; n = 7; start = 0; out_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; adj[1] = 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.base, align 4
  ; adj[2] = 1
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4

  ; dynamic indices based on n
  %n.val = load i64, i64* %n, align 8

  ; idx = n
  %idx1 = add i64 %n.val, 0
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx1
  store i32 1, i32* %p1, align 4

  ; idx = 2n
  %mul2 = shl i64 %n.val, 1
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %p2, align 4

  ; idx = n + 3
  %idx3 = add i64 %n.val, 3
  %p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx3
  store i32 1, i32* %p3, align 4

  ; idx = 3n + 1
  %mul3 = mul i64 %n.val, 3
  %idx4 = add i64 %mul3, 1
  %p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx4
  store i32 1, i32* %p4, align 4

  ; idx = n + 4
  %idx5 = add i64 %n.val, 4
  %p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx5
  store i32 1, i32* %p5, align 4

  ; idx = 4n + 1
  %mul4 = shl i64 %n.val, 2
  %idx6 = add i64 %mul4, 1
  %p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx6
  store i32 1, i32* %p6, align 4

  ; idx = 2n + 5
  %idx7 = add i64 %mul2, 5
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx7
  store i32 1, i32* %p7, align 4

  ; idx = 5n + 2
  %mul5 = add i64 %mul4, %n.val          ; 4n + n = 5n
  %idx8 = add i64 %mul5, 2
  %p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx8
  store i32 1, i32* %p8, align 4

  ; idx = 4n + 5
  %idx9 = add i64 %mul4, 5
  %p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx9
  store i32 1, i32* %p9, align 4

  ; idx = 5n + 4
  %idx10 = add i64 %mul5, 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx10
  store i32 1, i32* %p10, align 4

  ; idx = 5n + 6
  %idx11 = add i64 %mul5, 6
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx11
  store i32 1, i32* %p11, align 4

  ; idx = 6n + 5
  %mul6 = shl i64 %mul3, 1               ; 3n * 2 = 6n
  %idx12 = add i64 %mul6, 5
  %p12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx12
  store i32 1, i32* %p12, align 4

  ; call dfs(adj, n, start, out, &out_len)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.pre = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %call.pre = call i32 (i8*, ...) @printf(i8* %fmt.pre, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; determine separator: " " if i+1 < len else ""
  %next = add i64 %i.cur, 1
  %has_next = icmp ult i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %has_next, i8* %space.ptr, i8* %empty.ptr

  ; value = out[i]
  %out.elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %out.elem.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.item = call i32 (i8*, ...) @printf(i8* %fmt.item, i64 %val, i8* %sep)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; newline
  %call.nl = call i32 @putchar(i32 10)
  ret i32 0
}