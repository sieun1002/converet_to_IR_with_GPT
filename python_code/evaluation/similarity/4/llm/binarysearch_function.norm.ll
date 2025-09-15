; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/binarysearch_function.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.body ]
  %cmp.loop = icmp ugt i64 %high, %low
  br i1 %cmp.loop, label %loop.body, label %postloop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %cmp.sle.not = icmp slt i32 %elt, %key
  %mid.plus1 = add i64 %mid, 1
  %high.next = select i1 %cmp.sle.not, i64 %high, i64 %mid
  %low.next = select i1 %cmp.sle.not, i64 %mid.plus1, i64 %low
  br label %loop.cond

postloop:                                         ; preds = %loop.cond
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %checkval, label %ret.neg1

checkval:                                         ; preds = %postloop
  %elt.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %elt2 = load i32, i32* %elt.ptr2, align 4
  %eq = icmp eq i32 %elt2, %key
  br i1 %eq, label %common.ret, label %ret.neg1

common.ret:                                       ; preds = %checkval, %ret.neg1
  %common.ret.op = phi i64 [ -1, %ret.neg1 ], [ %low, %checkval ]
  ret i64 %common.ret.op

ret.neg1:                                         ; preds = %checkval, %postloop
  br label %common.ret
}
