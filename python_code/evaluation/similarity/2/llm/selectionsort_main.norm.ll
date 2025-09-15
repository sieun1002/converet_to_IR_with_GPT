; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/selectionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/selectionsort_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)

declare i32 @printf(i8*, ...)

; Function Attrs: sspstrong
define i32 @main() local_unnamed_addr #0 {
entry:
  %array = alloca [5 x i32], align 16
  %array.elem0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %array.elem0.ptr, align 16
  %array.elem1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %array.elem1.ptr, align 4
  %array.elem2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %array.elem2.ptr, align 8
  %array.elem3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %array.elem3.ptr, align 4
  %array.elem4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %array.elem4.ptr, align 16
  call void @selection_sort(i32* noundef nonnull %array.elem0.ptr, i32 noundef 5)
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i32 %i.0, 5
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i.0 to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %elem)
  %inc = add nuw nsw i32 %i.0, 1
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}

attributes #0 = { sspstrong }
