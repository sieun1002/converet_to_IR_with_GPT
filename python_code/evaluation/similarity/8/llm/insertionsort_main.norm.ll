; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/insertionsort_main.ll'
source_filename = "insertion_sort_main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.decay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.decay, align 16
  %i.ptr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %i.ptr1, align 4
  %i.ptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %i.ptr2, align 8
  %i.ptr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %i.ptr3, align 4
  %i.ptr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %i.ptr4, align 16
  %i.ptr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %i.ptr5, align 4
  %i.ptr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %i.ptr6, align 8
  %i.ptr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %i.ptr7, align 4
  %i.ptr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %i.ptr8, align 16
  %i.ptr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %i.ptr9, align 4
  call void @insertion_sort(i32* nonnull %arr.decay, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i.phi, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.phi
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i.phi, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}
