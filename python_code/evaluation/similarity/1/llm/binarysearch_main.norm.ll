; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/binarysearch_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/binarysearch_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.not = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i64 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr.gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.gep0, align 16
  %arr.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.gep2, align 8
  %arr.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.gep4, align 16
  %arr.gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr.gep6, align 8
  %arr.gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.gep8, align 16
  %keys.gep0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys.gep0, align 16
  %keys.gep1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys.gep1, align 4
  %keys.gep2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.gep2, align 8
  br label %loop

loop:                                             ; preds = %after_print, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %idx = call i64 @binary_search(i32* nonnull %arr.gep0, i64 9, i32 %key)
  %found.cmp = icmp slt i64 %idx, 0
  br i1 %found.cmp, label %notfound, label %found

found:                                            ; preds = %loop.body
  %call.found = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.found, i64 0, i64 0), i32 %key, i64 %idx)
  br label %after_print

notfound:                                         ; preds = %loop.body
  %call.not = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.not, i64 0, i64 0), i32 %key)
  br label %after_print

after_print:                                      ; preds = %notfound, %found
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
