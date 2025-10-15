target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n.addr = alloca i64, align 8
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
  store i64 10, i64* %n.addr, align 8
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %11 = load i64, i64* %n.addr, align 8
  call void @bubble_sort(i32* %10, i64 %11)
  br label %cond

cond:
  %i.ph = phi i64 [ 0, %entry ], [ %inc, %body ]
  %12 = load i64, i64* %n.addr, align 8
  %13 = icmp ult i64 %i.ph, %12
  br i1 %13, label %body, label %exit

body:
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.ph
  %15 = load i32, i32* %14, align 4
  %16 = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %17 = call i32 (i8*, ...) @printf(i8* %16, i32 %15)
  %inc = add i64 %i.ph, 1
  br label %cond

exit:
  %18 = call i32 @putchar(i32 10)
  ret i32 0
}