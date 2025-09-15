; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/selectionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/selectionsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.0.ptr, align 16
  %arr.1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr.1.ptr, align 4
  %arr.2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr.2.ptr, align 8
  %arr.3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr.3.ptr, align 4
  %arr.4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.4.ptr, align 16
  call void @selection_sort(i32* nonnull %arr.0.ptr, i32 5)
  %call0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %next, %body ]
  %cmp = icmp ult i32 %i.0, 5
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i.0 to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elem)
  %next = add nuw nsw i32 %i.0, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
