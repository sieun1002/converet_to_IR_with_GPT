; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/quicksort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/quicksort_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %.fca.0.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %.fca.0.gep, align 16
  %.fca.1.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %.fca.1.gep, align 4
  %.fca.2.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %.fca.2.gep, align 8
  %.fca.3.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %.fca.3.gep, align 4
  %.fca.4.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %.fca.4.gep, align 16
  %.fca.5.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %.fca.5.gep, align 4
  %.fca.6.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %.fca.6.gep, align 8
  %.fca.7.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %.fca.7.gep, align 4
  %.fca.8.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %.fca.8.gep, align 16
  %.fca.9.gep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %.fca.9.gep, align 4
  call void @quick_sort(i32* noundef nonnull %.fca.0.gep, i64 noundef 0, i64 noundef 9)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp2 = icmp ult i64 %i, 10
  br i1 %cmp2, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
  %inc = add nuw nsw i64 %i, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %newline = call i32 @putchar(i32 noundef 10)
  ret i32 0
}
