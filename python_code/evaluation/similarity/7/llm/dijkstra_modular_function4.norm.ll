; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function4.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %best = phi i32 [ 2147483647, %entry ], [ %best.next, %cont ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check, label %exit

check:                                            ; preds = %loop
  %i.sext = zext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.sext
  %b.val = load i32, i32* %b.ptr, align 4
  %iszero = icmp eq i32 %b.val, 0
  br i1 %iszero, label %maybe_update, label %cont_no_update

maybe_update:                                     ; preds = %check
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.sext
  %a.val = load i32, i32* %a.ptr, align 4
  %lt2 = icmp slt i32 %a.val, %best
  br i1 %lt2, label %cont, label %cont_no_update

cont_no_update:                                   ; preds = %maybe_update, %check
  br label %cont

cont:                                             ; preds = %maybe_update, %cont_no_update
  %best.next = phi i32 [ %best, %cont_no_update ], [ %a.val, %maybe_update ]
  %minidx.next = phi i32 [ %minidx, %cont_no_update ], [ %i, %maybe_update ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minidx
}
