; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/binarysearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/binarysearch_function.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %l = phi i64 [ 0, %entry ], [ %spec.select, %body ]
  %r = phi i64 [ %n, %entry ], [ %spec.select1, %body ]
  %cond = icmp ugt i64 %r, %l
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %sub = sub i64 %r, %l
  %shr = lshr i64 %sub, 1
  %mid = add i64 %l, %shr
  %gep = getelementptr inbounds i32, i32* %arr, i64 %mid
  %load = load i32, i32* %gep, align 4
  %cmp.not = icmp slt i32 %load, %key
  %l.next = add i64 %mid, 1
  %spec.select = select i1 %cmp.not, i64 %l.next, i64 %l
  %spec.select1 = select i1 %cmp.not, i64 %r, i64 %mid
  br label %loop

exit:                                             ; preds = %loop
  %chk = icmp ult i64 %l, %n
  br i1 %chk, label %check, label %ret_neg

check:                                            ; preds = %exit
  %gep2 = getelementptr inbounds i32, i32* %arr, i64 %l
  %load2 = load i32, i32* %gep2, align 4
  %eq = icmp eq i32 %load2, %key
  br i1 %eq, label %common.ret, label %ret_neg

common.ret:                                       ; preds = %check, %ret_neg
  %common.ret.op = phi i64 [ -1, %ret_neg ], [ %l, %check ]
  ret i64 %common.ret.op

ret_neg:                                          ; preds = %check, %exit
  br label %common.ret
}
