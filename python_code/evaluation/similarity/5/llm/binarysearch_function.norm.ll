; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/binarysearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body ]
  %cmp = icmp ugt i64 %high, %low
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le.not = icmp slt i32 %val, %key
  %mid.plus = add i64 %mid, 1
  %low.next = select i1 %le.not, i64 %mid.plus, i64 %low
  %high.next = select i1 %le.not, i64 %high, i64 %mid
  br label %loop

after:                                            ; preds = %loop
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check_eq, label %ret_neg

check_eq:                                         ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %common.ret, label %ret_neg

common.ret:                                       ; preds = %check_eq, %ret_neg
  %common.ret.op = phi i64 [ -1, %ret_neg ], [ %low, %check_eq ]
  ret i64 %common.ret.op

ret_neg:                                          ; preds = %check_eq, %after
  br label %common.ret
}
