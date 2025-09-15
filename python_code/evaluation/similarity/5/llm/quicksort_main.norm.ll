; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/quicksort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/quicksort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 16
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
  call void @quick_sort(i32* nonnull %arr.base, i64 0, i64 9)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %loop.cmp = icmp ult i64 %i.0, 10
  br i1 %loop.cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %printf.call = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}
