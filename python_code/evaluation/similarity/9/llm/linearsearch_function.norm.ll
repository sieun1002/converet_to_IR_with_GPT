; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/linearsearch_function.ll'
source_filename = "linear_search.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %len, i32 noundef %target) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %common.ret

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %elt, %target
  br i1 %eq, label %common.ret, label %inc

inc:                                              ; preds = %body
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

common.ret:                                       ; preds = %loop, %body
  %common.ret.op = phi i32 [ %i, %body ], [ -1, %loop ]
  ret i32 %common.ret.op
}
