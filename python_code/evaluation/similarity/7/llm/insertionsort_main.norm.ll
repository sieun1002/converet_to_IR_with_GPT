; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/insertionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/insertionsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @insertion_sort(i32* noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

; Function Attrs: noreturn
declare void @__stack_chk_fail() #0

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %1, align 16
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %3, align 8
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %5, align 16
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %7, align 8
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %9, align 16
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %10, align 4
  call void @insertion_sort(i32* nonnull %1, i64 10)
  br label %loop.check

loop.check:                                       ; preds = %loop.body, %entry
  %11 = phi i64 [ 0, %entry ], [ %15, %loop.body ]
  %12 = icmp ult i64 %11, 10
  br i1 %12, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.check
  %13 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %11
  %14 = load i32, i32* %13, align 4
  %15 = add i64 %11, 1
  %16 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %14)
  br label %loop.check

after.loop:                                       ; preds = %loop.check
  %17 = call i32 @putchar(i32 10)
  %18 = load i64, i64* @__stack_chk_guard, align 8
  %19 = icmp eq i64 %0, %18
  br i1 %19, label %ret, label %stackfail

stackfail:                                        ; preds = %after.loop
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after.loop
  ret i32 0
}

attributes #0 = { noreturn }
