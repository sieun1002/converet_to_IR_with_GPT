; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/linearsearch_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/linearsearch_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %key) {
entry:
  br label %loop

loop:                                             ; preds = %continue, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %continue ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %in, label %common.ret

in:                                               ; preds = %loop
  %idxprom = zext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %common.ret, label %continue

common.ret:                                       ; preds = %loop, %in
  %common.ret.op = phi i32 [ %i, %in ], [ -1, %loop ]
  ret i32 %common.ret.op

continue:                                         ; preds = %in
  %i.next = add nuw nsw i32 %i, 1
  br label %loop
}
