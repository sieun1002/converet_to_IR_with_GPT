; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix and perform DFS preorder from 0, then print the order (confidence=0.74). Evidence: flattened matrix stores using n=7; call to dfs with (adj, n, start, out, out_len) and printf with "%zu".
; Preconditions: dfs(i32* adj, i64 n, i64 start, i64* out, i64* out_len) fills out[0..*out_len) with size_t nodes in preorder.
; Postconditions: Prints "DFS preorder from 0: " followed by the node order separated by spaces and a newline.

@str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@str.space = private unnamed_addr constant [2 x i8] c" \00"
@str.empty = private unnamed_addr constant [1 x i8] c"\00"

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [48 x i32], align 16
  %out = alloca [8 x i64], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; zero 192 bytes (48 i32s) of adjacency matrix
  %adj_i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 192, i1 false)

  ; Build edges (set to 1)
  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; start = 0; len = 0
  store i64 0, i64* %len, align 8

  ; dfs(adj, 7, 0, out, &len)
  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 7, i64 0, i64* %out.base, i64* %len)

  ; printf("DFS preorder from %zu: ", 0)
  %pre.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @str.pre, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %pre.ptr, i64 0)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %body, label %done

body:
  %ip1 = add i64 %i.val, 1
  %more = icmp ult i64 %ip1, %len.val
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @str.empty, i64 0, i64 0
  %delim = select i1 %more, i8* %space.ptr, i8* %empty.ptr

  %val.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.val
  %val = load i64, i64* %val.ptr, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @str.fmt, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %val, i8* %delim)

  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}