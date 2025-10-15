; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str.format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @dfs(i32*, i64, i64, i64*, i64*)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %N = alloca i64, align 8
  %start = alloca i64, align 8
  %outCount = alloca i64, align 8
  %outArr = alloca [49 x i64], align 16
  %i = alloca i64, align 8

  store i64 7, i64* %N, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  %adj.base48 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 48
  store i32 0, i32* %adj.base48, align 4

  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4

  %Nval = load i64, i64* %N, align 8

  %adj.idxN = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nval
  store i32 1, i32* %adj.idxN, align 4

  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4

  %mul2 = mul i64 %Nval, 2
  %adj.idx2N = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %adj.idx2N, align 4

  %Nplus3 = add i64 %Nval, 3
  %adj.idxNp3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus3
  store i32 1, i32* %adj.idxNp3, align 4

  %mul3 = mul i64 %Nval, 3
  %threeNplus1 = add i64 %mul3, 1
  %adj.idx3N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threeNplus1
  store i32 1, i32* %adj.idx3N1, align 4

  %Nplus4 = add i64 %Nval, 4
  %adj.idxNp4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus4
  store i32 1, i32* %adj.idxNp4, align 4

  %mul4 = mul i64 %Nval, 4
  %fourNplus1 = add i64 %mul4, 1
  %adj.idx4N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus1
  store i32 1, i32* %adj.idx4N1, align 4

  %twoNplus5 = add i64 %mul2, 5
  %adj.idx2N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoNplus5
  store i32 1, i32* %adj.idx2N5, align 4

  %mul5 = mul i64 %Nval, 5
  %fiveNplus2 = add i64 %mul5, 2
  %adj.idx5N2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus2
  store i32 1, i32* %adj.idx5N2, align 4

  %fourNplus5 = add i64 %mul4, 5
  %adj.idx4N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus5
  store i32 1, i32* %adj.idx4N5, align 4

  %fiveNplus4 = add i64 %mul5, 4
  %adj.idx5N4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus4
  store i32 1, i32* %adj.idx5N4, align 4

  %fiveNplus6 = add i64 %mul5, 6
  %adj.idx5N6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus6
  store i32 1, i32* %adj.idx5N6, align 4

  %mul6 = mul i64 %Nval, 6
  %sixNplus5 = add i64 %mul6, 5
  %adj.idx6N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixNplus5
  store i32 1, i32* %adj.idx6N5, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %outCount, align 8

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %outArr.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %outArr, i64 0, i64 0
  %startval2 = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %Nval, i64 %startval2, i64* %outArr.ptr, i64* %outCount)

  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.format, i64 0, i64 0
  %startval = load i64, i64* %start, align 8
  %callpf = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %startval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.cur = load i64, i64* %i, align 8
  %count = load i64, i64* %outCount, align 8
  %cmp = icmp ult i64 %i.cur, %count
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %i.plus1 = add i64 %i.cur, 1
  %cmp2 = icmp ult i64 %i.plus1, %count
  %spaceptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sel = select i1 %cmp2, i8* %spaceptr, i8* %emptyptr

  %elemPtr = getelementptr inbounds [49 x i64], [49 x i64]* %outArr, i64 0, i64 %i.cur
  %elem = load i64, i64* %elemPtr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt2, i64 0, i64 0
  %callpf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elem, i8* %sel)

  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}