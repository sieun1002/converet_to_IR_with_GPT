; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/linearsearch_function.ll'
source_filename = "linear_search.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %common.ret

loop.body:                                        ; preds = %loop.header
  %idxprom = zext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %common.ret, label %loop.latch

loop.latch:                                       ; preds = %loop.body
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.header

common.ret:                                       ; preds = %loop.header, %loop.body
  %common.ret.op = phi i32 [ %i, %loop.body ], [ -1, %loop.header ]
  ret i32 %common.ret.op
}
