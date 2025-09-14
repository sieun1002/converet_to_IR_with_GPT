target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %1 = getelementptr inbounds i32, i32* %0, i64 0
  store i32 9, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %8, align 4
  %9 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %9, align 4
  %10 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %10, align 4
  call void @insertion_sort(i32* noundef %0, i64 noundef 10)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %11 = load i64, i64* %i, align 8
  %12 = icmp ult i64 %11, 10
  br i1 %12, label %body, label %after

body:
  %13 = getelementptr inbounds i32, i32* %0, i64 %11
  %14 = load i32, i32* %13, align 4
  %15 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %16 = call i32 (i8*, ...) @printf(i8* noundef %15, i32 noundef %14)
  %17 = add i64 %11, 1
  store i64 %17, i64* %i, align 8
  br label %loop

after:
  %18 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}