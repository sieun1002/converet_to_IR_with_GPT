; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/quicksort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/quicksort_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* nocapture, i64, i64)

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.ptr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.ptr0, align 16
  %arr.ptr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.ptr2, align 8
  %arr.ptr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.ptr4, align 16
  %arr.ptr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.ptr5, align 4
  %arr.ptr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.ptr6, align 8
  %arr.ptr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.ptr7, align 4
  %arr.ptr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.ptr8, align 16
  %arr.ptr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.ptr9, align 4
  call void @quick_sort(i32* nonnull %arr.ptr0, i64 0, i64 9)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.addr.0 = phi i64 [ 0, %entry ], [ %i.inc, %loop.body ]
  %cmp.it = icmp ult i64 %i.addr.0, 10
  br i1 %cmp.it, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.addr.0
  %elt.val = load i32, i32* %elt.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elt.val)
  %i.inc = add i64 %i.addr.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}
