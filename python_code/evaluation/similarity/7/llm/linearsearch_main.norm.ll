; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/linearsearch_main.ll'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.ptr, align 16
  %idx1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %idx2, align 8
  %idx3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %idx3, align 4
  %idx4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %idx4, align 16
  %call = call i32 @linear_search(i32* noundef nonnull %arr.ptr, i32 noundef 5, i32 noundef 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %callprintf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([27 x i8], [27 x i8]* @.str_found, i64 0, i64 0), i32 noundef %call)
  br label %exit

notfound:                                         ; preds = %entry
  %callputs = call i32 @puts(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @.str_not, i64 0, i64 0))
  br label %exit

exit:                                             ; preds = %notfound, %found
  ret i32 0
}
