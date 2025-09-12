; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run DFS preorder from 0, and print the visit order (confidence=0.92). Evidence: call to dfs; format string "DFS preorder from %zu: "
; Preconditions: dfs expects a row-major n*n i32 adjacency matrix; out buffer can hold up to 8 vertices.
; Postconditions: Prints the DFS preorder sequence and a trailing newline.

@.str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %graph = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %idx = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8

  %graph.i8 = bitcast [49 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph.i8, i8 0, i64 196, i1 false)

  %gbase = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %gbase, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %gbase, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %gbase, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %gbase, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %gbase, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %gbase, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %gbase, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %gbase, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %gbase, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %gbase, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %gbase, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %gbase, i64 39
  store i32 1, i32* %p39, align 4
  %p47 = getelementptr inbounds i32, i32* %gbase, i64 47
  store i32 1, i32* %p47, align 4

  store i64 0, i64* %out_len, align 8

  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %gbase, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)

  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.print)

  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:
  %i = load i64, i64* %idx, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp slt i64 %i, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.next = add i64 %i, 1
  %cmp2 = icmp slt i64 %i.next, %len
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %cmp2, i8* %sep.space, i8* %sep.empty

  %val.ptr = getelementptr inbounds i64, i64* %out.ptr, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %val, i8* %sep)

  %i.inc = add i64 %i, 1
  store i64 %i.inc, i64* %idx, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}