; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/insertionsort_function.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture noundef %arr, i64 noundef %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %while.end, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.minus1, %while.body ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %while.end, label %check.swap

check.swap:                                       ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %jm1.val = load i32, i32* %jm1.ptr, align 4
  %need.shift = icmp slt i32 %key, %jm1.val
  br i1 %need.shift, label %while.body, label %while.end

while.body:                                       ; preds = %check.swap
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %jm1.val, i32* %j.ptr, align 4
  br label %while.cond

while.end:                                        ; preds = %check.swap, %while.cond
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}
