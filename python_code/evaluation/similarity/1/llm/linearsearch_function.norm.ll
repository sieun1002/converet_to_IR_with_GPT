; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/linearsearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/linearsearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
define i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp.bound = icmp slt i32 %i, %len
  br i1 %cmp.bound, label %loop.body, label %common.ret

loop.body:                                        ; preds = %loop.header
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %cmp.eq = icmp eq i32 %elem.val, %target
  br i1 %cmp.eq, label %common.ret, label %loop.latch

common.ret:                                       ; preds = %loop.header, %loop.body
  %common.ret.op = phi i32 [ %i, %loop.body ], [ -1, %loop.header ]
  ret i32 %common.ret.op

loop.latch:                                       ; preds = %loop.body
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.header
}

attributes #0 = { nounwind }
