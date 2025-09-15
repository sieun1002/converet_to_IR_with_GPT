; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/linearsearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/linearsearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %common.ret

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %common.ret, label %cont

cont:                                             ; preds = %body
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

common.ret:                                       ; preds = %loop, %body
  %common.ret.op = phi i32 [ %i, %body ], [ -1, %loop ]
  ret i32 %common.ret.op
}
