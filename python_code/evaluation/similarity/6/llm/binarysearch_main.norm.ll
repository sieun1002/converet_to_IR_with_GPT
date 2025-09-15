; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/binarysearch_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/binarysearch_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)

declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %.fca.0.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %.fca.0.gep1, align 16
  %.fca.1.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %.fca.1.gep2, align 4
  %.fca.2.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %.fca.2.gep3, align 8
  %.fca.3.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %.fca.3.gep, align 4
  %.fca.4.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %.fca.4.gep, align 16
  %.fca.5.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %.fca.5.gep, align 4
  %.fca.6.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %.fca.6.gep, align 8
  %.fca.7.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %.fca.7.gep, align 4
  %.fca.8.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %.fca.8.gep, align 16
  %.fca.0.gep = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %.fca.0.gep, align 16
  %.fca.1.gep = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %.fca.1.gep, align 4
  %.fca.2.gep = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %.fca.2.gep, align 8
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %idx = call i64 @binary_search(i32* noundef nonnull %.fca.0.gep1, i64 noundef 9, i32 noundef %key)
  %isneg = icmp slt i64 %idx, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_found, i64 0, i64 0), i32 noundef %key, i64 noundef %idx)
  br label %latch

notfound:                                         ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0), i32 noundef %key)
  br label %latch

latch:                                            ; preds = %notfound, %found
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
