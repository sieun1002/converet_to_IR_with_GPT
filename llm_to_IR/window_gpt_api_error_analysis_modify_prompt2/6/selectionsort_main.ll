; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local void @selection_sort(i32*, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 4
  store i32 5, i32* %n, align 4
  %5 = load i32, i32* %n, align 4
  %6 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %6, i32 %5)
  %7 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %8 = call i32 @printf(i8* %7)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %9 = load i32, i32* %i, align 4
  %10 = load i32, i32* %n, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %body, label %after

body:
  %12 = load i32, i32* %i, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %13
  %15 = load i32, i32* %14, align 4
  %16 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %17 = call i32 (i8*, ...) @printf(i8* %16, i32 %15)
  %18 = load i32, i32* %i, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* %i, align 4
  br label %loop

after:
  ret i32 0
}