; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/linearsearch_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/linearsearch_main.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@msg.not.found = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @puts(i8* noundef)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0.ptr, align 16
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2.ptr, align 8
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4.ptr, align 16
  %call = call i32 @linear_search(i32* noundef nonnull %arr0.ptr, i32 noundef 5, i32 noundef 4)
  %cmp.notfound = icmp eq i32 %call, -1
  br i1 %cmp.notfound, label %notfound, label %found

found:                                            ; preds = %entry
  %printf.call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([27 x i8], [27 x i8]* @format, i64 0, i64 0), i32 noundef %call)
  br label %ret

notfound:                                         ; preds = %entry
  %puts.call = call i32 @puts(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @msg.not.found, i64 0, i64 0))
  br label %ret

ret:                                              ; preds = %notfound, %found
  ret i32 0
}
