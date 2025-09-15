; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function4.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* nocapture readonly %vals, i32* nocapture readonly %mask, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.latch, %latch ]
  %midx = phi i32 [ -1, %entry ], [ %idx.latch, %latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idx64
  %mask.val = load i32, i32* %mask.ptr, align 4
  %mask.is.zero = icmp eq i32 %mask.val, 0
  br i1 %mask.is.zero, label %check, label %latch

check:                                            ; preds = %body
  %vals.ptr = getelementptr inbounds i32, i32* %vals, i64 %idx64
  %val = load i32, i32* %vals.ptr, align 4
  %lt = icmp slt i32 %val, %min
  %selMin = select i1 %lt, i32 %val, i32 %min
  %selIdx = select i1 %lt, i32 %i, i32 %midx
  br label %latch

latch:                                            ; preds = %body, %check
  %min.latch = phi i32 [ %selMin, %check ], [ %min, %body ]
  %idx.latch = phi i32 [ %selIdx, %check ], [ %midx, %body ]
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %midx
}
