; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function4.ll'
source_filename = "min_index.c"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
define i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %mask, i32 %n) local_unnamed_addr #0 {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.sel, %inc ]
  %best = phi i32 [ -1, %entry ], [ %best.sel, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %idx = zext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idx
  %mask.val = load i32, i32* %mask.ptr, align 4
  %mask.iszero = icmp eq i32 %mask.val, 0
  br i1 %mask.iszero, label %maybe_update, label %inc

maybe_update:                                     ; preds = %body
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %arr.val = load i32, i32* %arr.ptr, align 4
  %isless = icmp slt i32 %arr.val, %min
  %spec.select = select i1 %isless, i32 %arr.val, i32 %min
  %spec.select1 = select i1 %isless, i32 %i, i32 %best
  br label %inc

inc:                                              ; preds = %maybe_update, %body
  %min.sel = phi i32 [ %min, %body ], [ %spec.select, %maybe_update ]
  %best.sel = phi i32 [ %best, %body ], [ %spec.select1, %maybe_update ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

end:                                              ; preds = %loop
  ret i32 %best
}

attributes #0 = { nounwind }
