; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/binarysearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body ]
  %cmp.lohi = icmp ugt i64 %high, %low
  br i1 %cmp.lohi, label %body, label %after

body:                                             ; preds = %cond
  %range = sub i64 %high, %low
  %half = lshr i64 %range, 1
  %mid = add i64 %low, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val.mid = load i32, i32* %ptr.mid, align 4
  %cmp.key.le.not = icmp slt i32 %val.mid, %key
  %mid.plus1 = add i64 %mid, 1
  %low.next = select i1 %cmp.key.le.not, i64 %mid.plus1, i64 %low
  %high.next = select i1 %cmp.key.le.not, i64 %high, i64 %mid
  br label %cond

after:                                            ; preds = %cond
  %check.in.bounds = icmp ult i64 %low, %n
  br i1 %check.in.bounds, label %maybe_equal, label %not_found

maybe_equal:                                      ; preds = %after
  %ptr.low = getelementptr inbounds i32, i32* %arr, i64 %low
  %val.low = load i32, i32* %ptr.low, align 4
  %eq = icmp eq i32 %val.low, %key
  br i1 %eq, label %common.ret, label %not_found

common.ret:                                       ; preds = %maybe_equal, %not_found
  %common.ret.op = phi i64 [ -1, %not_found ], [ %low, %maybe_equal ]
  ret i64 %common.ret.op

not_found:                                        ; preds = %maybe_equal, %after
  br label %common.ret
}
