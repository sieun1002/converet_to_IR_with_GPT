; ModuleID = 'main_module'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bubble_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4

  store i64 10, i64* %n, align 8

  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %11 = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %10, i64 %11)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %12 = load i64, i64* %i, align 8
  %13 = load i64, i64* %n, align 8
  %14 = icmp ult i64 %12, %13
  br i1 %14, label %loop.body, label %loop.end

loop.body:
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %12
  %16 = load i32, i32* %15, align 4
  %17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %18 = call i32 (i8*, ...) @printf(i8* %17, i32 %16)
  %19 = add i64 %12, 1
  store i64 %19, i64* %i, align 8
  br label %loop.cond

loop.end:
  %20 = call i32 @putchar(i32 10)
  ret i32 0
}