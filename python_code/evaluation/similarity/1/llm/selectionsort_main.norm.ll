; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/selectionsort_main.ll'
source_filename = "selection_main.c"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 16
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 8
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 16
  call void @selection_sort(i32* nonnull %0, i32 5)
  %5 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i32 %i, 5
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idxext = zext i32 %i to i64
  %6 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %6, align 4
  %7 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %elem)
  %inc = add nuw nsw i32 %i, 1
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}
