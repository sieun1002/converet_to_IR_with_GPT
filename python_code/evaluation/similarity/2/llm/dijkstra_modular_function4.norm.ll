; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function4.ll"
target triple = "x86_64-unknown-linux-gnu"

define i32 @min_index(i32* nocapture readonly %arr1, i32* nocapture readonly %arr2, i32 %len) {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.sel, %latch ]
  %idx = phi i32 [ -1, %entry ], [ %idx.sel, %latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %i64 = zext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %arr2, i64 %i64
  %mask = load i32, i32* %mask.ptr, align 4
  %ismaskzero = icmp eq i32 %mask, 0
  br i1 %ismaskzero, label %checkless, label %no_update

checkless:                                        ; preds = %body
  %val.ptr = getelementptr inbounds i32, i32* %arr1, i64 %i64
  %val = load i32, i32* %val.ptr, align 4
  %isless = icmp slt i32 %val, %min
  br i1 %isless, label %latch, label %no_update

no_update:                                        ; preds = %checkless, %body
  br label %latch

latch:                                            ; preds = %checkless, %no_update
  %min.sel = phi i32 [ %min, %no_update ], [ %val, %checkless ]
  %idx.sel = phi i32 [ %idx, %no_update ], [ %i, %checkless ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %idx
}
