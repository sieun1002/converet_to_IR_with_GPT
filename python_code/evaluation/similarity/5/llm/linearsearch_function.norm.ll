; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/linearsearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/linearsearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.addr.0 = phi i32 [ 0, %entry ], [ %next, %inc ]
  %cmp.len = icmp slt i32 %i.addr.0, %len
  br i1 %cmp.len, label %body, label %common.ret

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i.addr.0 to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %common.ret, label %inc

inc:                                              ; preds = %body
  %next = add nuw nsw i32 %i.addr.0, 1
  br label %loop

common.ret:                                       ; preds = %loop, %body
  %common.ret.op = phi i32 [ %i.addr.0, %body ], [ -1, %loop ]
  ret i32 %common.ret.op
}
