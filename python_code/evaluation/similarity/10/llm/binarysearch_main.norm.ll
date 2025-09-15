; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/binarysearch_main.ll'
source_filename = "bs_main"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_not = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)

declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 16
  %key0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %key0, align 16
  %key1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %key1, align 4
  %key2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %key2, align 8
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cond = icmp ult i64 %i.0, 3
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %key.gep = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.0
  %key.val = load i32, i32* %key.gep, align 4
  %call = call i64 @binary_search(i32* noundef nonnull %arr0, i64 noundef 9, i32 noundef %key.val)
  %isneg = icmp slt i64 %call, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %body
  %pr1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_found, i64 0, i64 0), i32 noundef %key.val, i64 noundef %call)
  br label %inc

notfound:                                         ; preds = %body
  %pr2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_not, i64 0, i64 0), i32 noundef %key.val)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.next = add i64 %i.0, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}
