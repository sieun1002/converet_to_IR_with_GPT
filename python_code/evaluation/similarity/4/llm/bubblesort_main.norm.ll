; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/bubblesort_main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @bubble_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 16
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 8
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 16
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 8
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 16
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  call void @bubble_sort(i32* nonnull %0, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %14, %loop.body ]
  %10 = icmp ult i64 %i.0, 10
  br i1 %10, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.0
  %12 = load i32, i32* %11, align 4
  %13 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %12)
  %14 = add i64 %i.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %15 = call i32 @putchar(i32 10)
  ret i32 0
}
