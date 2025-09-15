; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/selectionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/selectionsort_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@fmt_int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0.ptr, align 16
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2.ptr, align 8
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4.ptr, align 16
  call void @selection_sort(i32* nonnull %arr0.ptr, i32 5)
  %call.printf.header = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @format, i64 0, i64 0))
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ult i32 %i.0, 5
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %idx.ext = zext i32 %i.0 to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @fmt_int, i64 0, i64 0), i32 %elem.val)
  %inc = add nuw nsw i32 %i.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  ret i32 0
}
