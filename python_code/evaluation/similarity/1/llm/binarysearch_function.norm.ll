; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/binarysearch_function.ll'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.body ]
  %cmp = icmp ugt i64 %high, %low
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.header
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmpk.not = icmp slt i32 %val, %key
  %mid.plus1 = add i64 %mid, 1
  %low.next = select i1 %cmpk.not, i64 %mid.plus1, i64 %low
  %high.next = select i1 %cmpk.not, i64 %high, i64 %mid
  br label %loop.header

after.loop:                                       ; preds = %loop.header
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check.value, label %notfound

check.value:                                      ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %common.ret, label %notfound

common.ret:                                       ; preds = %check.value, %notfound
  %common.ret.op = phi i64 [ -1, %notfound ], [ %low, %check.value ]
  ret i64 %common.ret.op

notfound:                                         ; preds = %check.value, %after.loop
  br label %common.ret
}
