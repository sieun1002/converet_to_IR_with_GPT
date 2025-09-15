; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/selectionsort_function.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.latch
  %j.in = phi i32 [ %j, %inner.latch ], [ %i, %outer.cond ]
  %min.cur = phi i32 [ %min.next, %inner.latch ], [ %i, %outer.cond ]
  %j = add nuw nsw i32 %j.in, 1
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.latch, label %after.inner

inner.latch:                                      ; preds = %inner.cond
  %j.sext = zext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.sext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.sext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.sext
  %min.val = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %j.val, %min.val
  %min.next = select i1 %isless, i32 %j, i32 %min.cur
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.sext = zext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.sext
  %tmp.i = load i32, i32* %i.ptr, align 4
  %min.final.sext = sext i32 %min.cur to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.final.sext
  %tmp.min = load i32, i32* %min.ptr2, align 4
  store i32 %tmp.min, i32* %i.ptr, align 4
  store i32 %tmp.i, i32* %min.ptr2, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
