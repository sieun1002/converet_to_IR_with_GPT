; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/binarysearch_function.ll'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %lo = phi i64 [ 0, %entry ], [ %spec.select, %loop.body ]
  %hi = phi i64 [ %n, %entry ], [ %spec.select1, %loop.body ]
  %cmp = icmp ugt i64 %hi, %lo
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le.not = icmp slt i32 %val, %key
  %mid.plus1 = add i64 %mid, 1
  %spec.select = select i1 %le.not, i64 %mid.plus1, i64 %lo
  %spec.select1 = select i1 %le.not, i64 %hi, i64 %mid
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check.eq, label %notfound

check.eq:                                         ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %common.ret, label %notfound

common.ret:                                       ; preds = %check.eq, %notfound
  %common.ret.op = phi i64 [ -1, %notfound ], [ %lo, %check.eq ]
  ret i64 %common.ret.op

notfound:                                         ; preds = %check.eq, %after.loop
  br label %common.ret
}
