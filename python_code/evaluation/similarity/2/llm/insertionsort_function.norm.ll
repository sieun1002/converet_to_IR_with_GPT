; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/insertionsort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %inner.exit, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %inner.exit ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.prev, %inner.body ]
  %j.ne.zero.not = icmp eq i64 %j, 0
  br i1 %j.ne.zero.not, label %inner.exit, label %inner.cmp

inner.cmp:                                        ; preds = %inner.cond
  %j.prev = add i64 %j, -1
  %gep.prev = getelementptr inbounds i32, i32* %arr, i64 %j.prev
  %prev = load i32, i32* %gep.prev, align 4
  %key.lt.prev = icmp slt i32 %key, %prev
  br i1 %key.lt.prev, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.cmp
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %gep.j, align 4
  br label %inner.cond

inner.exit:                                       ; preds = %inner.cmp, %inner.cond
  %gep.final = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %gep.final, align 4
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
