; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str_dfs = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 4
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)

  %fmt0.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0.ptr, i64 %start.val2)

  br label %loop.cond

loop.cond:
  %i.ph = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.ph, 1
  %len.cur2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix.ptr = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.ph
  %elem.val = load i64, i64* %elem.ptr, align 8

  %fmt1.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %elem.val, i8* %suffix.ptr)

  %i.next = add i64 %i.ph, 1
  br label %loop.cond

loop.end:
  %nl.call = call i32 @putchar(i32 10)
  ret i32 0
}