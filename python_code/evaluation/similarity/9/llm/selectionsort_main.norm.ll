; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/selectionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/selectionsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* nocapture, i32)

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.elem0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.elem0.ptr, align 16
  %arr.elem1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr.elem2.ptr, align 8
  %arr.elem3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.elem4.ptr, align 16
  call void @selection_sort(i32* nonnull %arr.elem0.ptr, i32 5)
  %call.printf.hdr = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i32 %i, 5
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %call.printf.num = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %elem.val)
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
