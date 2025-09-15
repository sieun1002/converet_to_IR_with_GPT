; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/mergesort_main.ll'
source_filename = "main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

; Function Attrs: sspstrong
define i32 @main() #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.idx0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.idx0, align 16
  %arr.idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.idx2, align 8
  %arr.idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.idx4, align 16
  %arr.idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.idx6, align 8
  %arr.idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 16
  %arr.idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4
  call void @merge_sort(i32* noundef nonnull %arr.idx0, i64 noundef 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %val)
  %inc = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

attributes #0 = { sspstrong }
