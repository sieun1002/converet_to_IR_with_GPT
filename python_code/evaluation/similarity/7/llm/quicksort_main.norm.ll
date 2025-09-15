; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/quicksort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/quicksort_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @quick_sort(i32* noundef, i32 noundef, i32 noundef)

declare dso_local i32 @printf(i8* noundef, ...)

declare dso_local i32 @putchar(i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrdecay, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  call void @quick_sort(i32* noundef nonnull %arrdecay, i32 noundef 0, i32 noundef 9)
  br label %loop.header

loop.header:                                      ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %after

loop.body:                                        ; preds = %loop.header
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %val)
  %i.next = add i64 %i, 1
  br label %loop.header

after:                                            ; preds = %loop.header
  %call_putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}
