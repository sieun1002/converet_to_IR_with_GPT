; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/binarysearch_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/binarysearch_main.ll"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i64 @binary_search(i32*, i64, i32)

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
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 16
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.addr.0 = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp ult i64 %i.addr.0, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.addr.0
  %key = load i32, i32* %key.ptr, align 4
  %bs.ret = call i64 @binary_search(i32* nonnull %arr0, i64 9, i32 %key)
  %neg = icmp slt i64 %bs.ret, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %printf.ok = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 %key, i64 %bs.ret)
  br label %inc

notfound:                                         ; preds = %loop.body
  %printf.nf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.next = add i64 %i.addr.0, 1
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret i32 0
}
