; ModuleID = 'main_from_disasm'
source_filename = "main_from_disasm"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.space = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty = private unnamed_addr constant [1 x i8] c"\00"
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00"

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %count = alloca i64, align 8
  %i = alloca i64, align 8

  ; memset adjacency matrix (49 * 4 = 196 bytes) to zero
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; build undirected graph for N = 7 (adjacency matrix N x N)
  ; edges: 0-1, 0-2, 1-3, 1-4, 2-5, 4-5, 5-6

  ; arr[1] = 1  (0->1)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %idx1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1, align 4

  ; arr[2] = 1  (0->2)
  %idx2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2, align 4

  ; arr[7] = 1  (1->0)
  %idx7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %idx7, align 4

  ; arr[14] = 1 (2->0)
  %idx14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %idx14, align 4

  ; arr[10] = 1 (1->3)
  %idx10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx10, align 4

  ; arr[22] = 1 (3->1)
  %idx22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx22, align 4

  ; arr[11] = 1 (1->4)
  %idx11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx11, align 4

  ; arr[29] = 1 (4->1)
  %idx29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx29, align 4

  ; arr[19] = 1 (2->5)
  %idx19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx19, align 4

  ; arr[37] = 1 (5->2)
  %idx37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx37, align 4

  ; arr[33] = 1 (4->5)
  %idx33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx33, align 4

  ; arr[39] = 1 (5->4)
  %idx39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx39, align 4

  ; arr[41] = 1 (5->6)
  %idx41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx41, align 4

  ; arr[47] = 1 (6->5)
  %idx47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx47, align 4

  ; count = 0
  store i64 0, i64* %count, align 8

  ; call dfs(adj, N=7, start=0, out, &count)
  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 7, i64 0, i64* %out.base, i64* %count)

  ; printf("DFS preorder from %zu: ", 0)
  %fmt = getelementptr inbounds [24 x i8], [24 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt, i64 0)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %cnt = load i64, i64* %count, align 8
  %cond = icmp ult i64 %i.cur, %cnt
  br i1 %cond, label %body, label %after

body:
  %next = add i64 %i.cur, 1
  %more = icmp ult i64 %next, %cnt
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %more, i8* %space.ptr, i8* %empty.ptr

  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %delim)

  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}