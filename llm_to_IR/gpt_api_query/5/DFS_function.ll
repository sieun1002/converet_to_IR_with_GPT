; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.sp = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  %a1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %a7, align 4

  %a2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %a2, align 4
  %a14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %a14, align 4

  %a10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %a10, align 4
  %a22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %a22, align 4

  %a11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %a11, align 4
  %a29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %a29, align 4

  %a19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %a19, align 4
  %a37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %a37, align 4

  %a33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %a33, align 4
  %a39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %a39, align 4

  %a41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %a41, align 4
  %a47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %a47, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %sval = load i64, i64* %start, align 8
  %out_ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj_ptr, i64 %nval, i64 %sval, i64* %out_ptr, i64* %out_len)

  %fmt = getelementptr inbounds [24 x i8], [24 x i8]* @.str, i64 0, i64 0
  %sval2 = load i64, i64* %start, align 8
  call i32 (i8*, ...) @printf(i8* %fmt, i64 %sval2)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %iv, %len
  br i1 %cmp, label %body, label %after

body:
  %iv1 = add i64 %iv, 1
  %cmp2 = icmp ult i64 %iv1, %len
  %spaceptr = getelementptr inbounds [2 x i8], [2 x i8]* @.sp, i64 0, i64 0
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %delim = select i1 %cmp2, i8* %spaceptr, i8* %emptyptr

  %outelem = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %iv
  %val = load i64, i64* %outelem, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %delim)

  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after:
  call i32 @putchar(i32 10)
  ret i32 0
}