; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting:\0A\00", align 1
@.str.after  = private unnamed_addr constant [16 x i8] c"After sorting:\0A\00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
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
  %9 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.before, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* %9)
  br label %loop1.header

loop1.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:
  %11 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %12 = load i32, i32* %11, align 4
  %13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %14 = call i32 (i8*, ...) @printf(i8* %13, i32 %12)
  %i.next = add i64 %i, 1
  br label %loop1.header

loop1.end:
  %15 = call i32 @putchar(i32 10)
  %16 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %16, i64 9)
  %17 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.after, i64 0, i64 0
  %18 = call i32 (i8*, ...) @printf(i8* %17)
  br label %loop2.header

loop2.header:
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %19 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %20 = load i32, i32* %19, align 4
  %21 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %22 = call i32 (i8*, ...) @printf(i8* %21, i32 %20)
  %j.next = add i64 %j, 1
  br label %loop2.header

loop2.end:
  %23 = call i32 @putchar(i32 10)
  ret i32 0
}