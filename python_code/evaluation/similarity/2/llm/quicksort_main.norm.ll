; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/quicksort_main.ll'
source_filename = "qs_main.c"
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 16
  %idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %idx2, align 8
  %idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %idx4, align 16
  %idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %idx6, align 8
  %idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 16
  %idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %idx9, align 4
  call void @quick_sort(i32* noundef nonnull %arr.base, i64 noundef 0, i64 noundef 9)
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop
  %eltptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %eltptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt, i64 0, i64 0), i32 noundef %val)
  %inc = add i64 %i, 1
  br label %loop

after.loop:                                       ; preds = %loop
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}
