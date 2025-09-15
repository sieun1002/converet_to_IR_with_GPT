; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/binarysearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.sel, %loop.body ]
  %high = phi i64 [ %n, %entry ], [ %high.sel, %loop.body ]
  %cmp = icmp ugt i64 %high, %low
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %condLE.not = icmp slt i32 %elem, %key
  %high.sel = select i1 %condLE.not, i64 %high, i64 %mid
  %mid.plus1 = add i64 %mid, 1
  %low.sel = select i1 %condLE.not, i64 %mid.plus1, i64 %low
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.notfound

check:                                            ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %common.ret, label %ret.notfound

common.ret:                                       ; preds = %check, %ret.notfound
  %common.ret.op = phi i64 [ -1, %ret.notfound ], [ %low, %check ]
  ret i64 %common.ret.op

ret.notfound:                                     ; preds = %check, %after.loop
  br label %common.ret
}
