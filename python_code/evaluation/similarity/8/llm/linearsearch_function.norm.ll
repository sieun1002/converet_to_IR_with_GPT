; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/linearsearch_function.ll'
source_filename = "linear_search"
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check, label %common.ret

check:                                            ; preds = %loop
  %idxext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %common.ret, label %inc

inc:                                              ; preds = %check
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

common.ret:                                       ; preds = %loop, %check
  %common.ret.op = phi i32 [ %i, %check ], [ -1, %loop ]
  ret i32 %common.ret.op
}
