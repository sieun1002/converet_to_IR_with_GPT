; ModuleID = 'selection_main'
source_filename = "selection_main.c"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
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
  store i32 5, i32* %len, align 4
  %5 = load i32, i32* %len, align 4
  call void @selection_sort(i32* %0, i32 %5)
  %6 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %7 = call i32 (i8*, ...) @printf(i8* %6)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %after ]
  %8 = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i, %8
  br i1 %cmp, label %body, label %done

body:
  %idxext = sext i32 %i to i64
  %9 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %9, align 4
  %10 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %11 = call i32 (i8*, ...) @printf(i8* %10, i32 %elem)
  br label %after

after:
  %inc = add nsw i32 %i, 1
  br label %loop

done:
  ret i32 0
}