; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function4.ll"

define i32 @min_index(i32* %arr, i32* %flag, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %minval = phi i32 [ 2147483647, %entry ], [ %minval.next, %latch ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check_flag, label %exit

check_flag:                                       ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flag, i64 %idx.ext
  %flag.val = load i32, i32* %flag.ptr, align 4
  %iszero = icmp eq i32 %flag.val, 0
  br i1 %iszero, label %maybe_update, label %latch

maybe_update:                                     ; preds = %check_flag
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %minval
  %spec.select = select i1 %lt, i32 %arr.val, i32 %minval
  %spec.select1 = select i1 %lt, i32 %i, i32 %minidx
  br label %latch

latch:                                            ; preds = %maybe_update, %check_flag
  %minval.next = phi i32 [ %minval, %check_flag ], [ %spec.select, %maybe_update ]
  %minidx.next = phi i32 [ %minidx, %check_flag ], [ %spec.select1, %maybe_update ]
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minidx
}
