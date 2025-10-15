; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4
  store i64 9, i64* %len, align 8
  %9 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %10 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %9, i64 %10)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %11 = load i64, i64* %i, align 8
  %12 = load i64, i64* %len, align 8
  %13 = icmp ult i64 %11, %12
  br i1 %13, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %14 = load i64, i64* %i, align 8
  %15 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %14
  %16 = load i32, i32* %15, align 4
  %17 = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %18 = call i32 (i8*, ...) @printf(i8* %17, i32 %16)
  %19 = add i64 %14, 1
  store i64 %19, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  ret i32 0
}