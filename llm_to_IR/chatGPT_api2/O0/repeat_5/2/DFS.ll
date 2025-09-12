; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix and run DFS preorder from node 0, then print the order (confidence=0.90). Evidence: row-major index math with stride 7; call to dfs and printing "DFS preorder from %zu: ".
; Preconditions: dfs(adj, n, start, out, count) expects a row-major n×n matrix of i32 (0/1), size n=7, out capacity >= n.
; Postconditions: Prints the DFS preorder as size_t values separated by spaces, newline-terminated.

@.str_title = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [8 x i64], align 16
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  ; n = 7, start = 0
  store i64 0, i64* %count, align 8
  ; memset adj to zero (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  ; Set adjacency entries to 1:
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
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
  ; call dfs(adj, 7, 0, order, &count)
  %order.base = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 7, i64 0, i64* %order.base, i64* %count)
  ; printf("DFS preorder from %zu: ", 0)
  %fmt_title = getelementptr inbounds [24 x i8], [24 x i8]* @.str_title, i64 0, i64 0
  %call_title = call i32 (i8*, ...) @printf(i8* %fmt_title, i64 0)
  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.header

loop.header:                                          ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %cnt = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i.cur, %cnt
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                            ; preds = %loop.header
  %i.next1 = add i64 %i.cur, 1
  %spc.cond = icmp ult i64 %i.next1, %cnt
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %spc.cond, i8* %space.ptr, i8* %empty.ptr
  ; load order[i]
  %ord.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.ptr, align 8
  ; printf("%zu%s", ord.val, delim)
  %fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call_each = call i32 (i8*, ...) @printf(i8* %fmt, i64 %ord.val, i8* %delim)
  ; i++
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop.header

loop.end:                                             ; preds = %loop.header
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}