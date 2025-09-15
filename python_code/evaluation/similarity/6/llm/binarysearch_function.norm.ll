; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/binarysearch_function.ll"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %cond

cond:                                             ; preds = %loop, %entry
  %low = phi i64 [ 0, %entry ], [ %spec.select, %loop ]
  %high = phi i64 [ %n, %entry ], [ %spec.select1, %loop ]
  %cond_lt = icmp ugt i64 %high, %low
  br i1 %cond_lt, label %loop, label %post

loop:                                             ; preds = %cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le.not = icmp slt i32 %elt, %key
  %mid_plus1 = add i64 %mid, 1
  %spec.select = select i1 %le.not, i64 %mid_plus1, i64 %low
  %spec.select1 = select i1 %le.not, i64 %high, i64 %mid
  br label %cond

post:                                             ; preds = %cond
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %notfound

check:                                            ; preds = %post
  %elt2.ptr = getelementptr inbounds i32, i32* %arr, i64 %low
  %elt2 = load i32, i32* %elt2.ptr, align 4
  %eq = icmp eq i32 %elt2, %key
  br i1 %eq, label %common.ret, label %notfound

common.ret:                                       ; preds = %check, %notfound
  %common.ret.op = phi i64 [ -1, %notfound ], [ %low, %check ]
  ret i64 %common.ret.op

notfound:                                         ; preds = %check, %post
  br label %common.ret
}
