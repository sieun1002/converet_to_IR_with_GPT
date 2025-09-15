; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function4.ll"
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* %arr, i32* %flags, i32 %n) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %bestIdx = phi i32 [ -1, %entry ], [ %bestIdx.inc, %loop.inc ]
  %bestVal = phi i32 [ 2147483647, %entry ], [ %bestVal.inc, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.header
  %i64 = zext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flags, i64 %i64
  %flag.val = load i32, i32* %flag.ptr, align 4
  %flag.zero = icmp eq i32 %flag.val, 0
  br i1 %flag.zero, label %checkMin, label %loop.inc

checkMin:                                         ; preds = %loop.body
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %bestVal
  %spec.select = select i1 %lt, i32 %arr.val, i32 %bestVal
  %spec.select1 = select i1 %lt, i32 %i, i32 %bestIdx
  br label %loop.inc

loop.inc:                                         ; preds = %checkMin, %loop.body
  %bestVal.inc = phi i32 [ %bestVal, %loop.body ], [ %spec.select, %checkMin ]
  %bestIdx.inc = phi i32 [ %bestIdx, %loop.body ], [ %spec.select1, %checkMin ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret i32 %bestIdx
}
