; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function4.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %best_val = phi i32 [ 2147483647, %entry ], [ %best_val.next, %inc ]
  %best_idx = phi i32 [ -1, %entry ], [ %best_idx.next, %inc ]
  %cont = icmp slt i32 %i, %n
  br i1 %cont, label %check, label %exit

check:                                            ; preds = %loop
  %i.ext = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.ext
  %b.val = load i32, i32* %b.ptr, align 4
  %b.nonzero.not = icmp eq i32 %b.val, 0
  br i1 %b.nonzero.not, label %load_a, label %inc

load_a:                                           ; preds = %check
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.ext
  %a.val = load i32, i32* %a.ptr, align 4
  %lt = icmp slt i32 %a.val, %best_val
  %spec.select = select i1 %lt, i32 %a.val, i32 %best_val
  %spec.select1 = select i1 %lt, i32 %i, i32 %best_idx
  br label %inc

inc:                                              ; preds = %load_a, %check
  %best_val.next = phi i32 [ %best_val, %check ], [ %spec.select, %load_a ]
  %best_idx.next = phi i32 [ %best_idx, %check ], [ %spec.select1, %load_a ]
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %best_idx
}
