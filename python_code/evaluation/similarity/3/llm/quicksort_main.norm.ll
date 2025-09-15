; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/quicksort_main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  call void @quick_sort(i32* noundef nonnull %arr0, i64 noundef 0, i64 noundef 9)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
  %i.next = add i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %call_putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}
