; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/binarysearch_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/binarysearch_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8* noundef, ...)

declare dso_local i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr.ptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.ptr0, align 16
  %arr.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.ptr2, align 8
  %arr.ptr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.ptr4, align 16
  %arr.ptr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr.ptr5, align 4
  %arr.ptr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr.ptr6, align 8
  %arr.ptr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr.ptr7, align 4
  %arr.ptr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.ptr8, align 16
  %keys.ptr0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys.ptr0, align 16
  %keys.ptr1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys.ptr1, align 4
  %keys.ptr2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.ptr2, align 8
  br label %loop

loop:                                             ; preds = %loop.latch, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp.cont = icmp ult i64 %i, 3
  br i1 %cmp.cont, label %body, label %exit

body:                                             ; preds = %loop
  %key.gep = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key.val = load i32, i32* %key.gep, align 4
  %idx = call i64 @binary_search(i32* noundef nonnull %arr.ptr0, i64 noundef 9, i32 noundef %key.val)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %call.printf.found = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.found, i64 0, i64 0), i32 noundef %key.val, i64 noundef %idx)
  br label %loop.latch

notfound:                                         ; preds = %body
  %call.printf.nf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0), i32 noundef %key.val)
  br label %loop.latch

loop.latch:                                       ; preds = %notfound, %found
  %i.next = add i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
