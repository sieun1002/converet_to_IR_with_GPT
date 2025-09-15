; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/binarysearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %body ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %body ]
  %cond = icmp ugt i64 %hi, %lo
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val.mid = load i32, i32* %ptr.mid, align 4
  %le.not = icmp slt i32 %val.mid, %key
  %hi.next = select i1 %le.not, i64 %hi, i64 %mid
  %mid.plus = add i64 %mid, 1
  %lo.next = select i1 %le.not, i64 %mid.plus, i64 %lo
  br label %loop

after:                                            ; preds = %loop
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check, label %ret.neg

check:                                            ; preds = %after
  %ptr.lo = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val.lo = load i32, i32* %ptr.lo, align 4
  %eq = icmp eq i32 %val.lo, %key
  br i1 %eq, label %common.ret, label %ret.neg

common.ret:                                       ; preds = %check, %ret.neg
  %common.ret.op = phi i64 [ -1, %ret.neg ], [ %lo, %check ]
  ret i64 %common.ret.op

ret.neg:                                          ; preds = %check, %after
  br label %common.ret
}
