; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* noundef %0, i64 noundef 10)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %1 = load i64, i64* %i, align 8
  %2 = icmp ult i64 %1, 10
  br i1 %2, label %body, label %after

body:
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %1
  %4 = load i32, i32* %3, align 4
  %5 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %6 = call i32 (i8*, ...) @printf(i8* noundef %5, i32 noundef %4)
  %7 = add i64 %1, 1
  store i64 %7, i64* %i, align 8
  br label %loop

after:
  %8 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}