; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/insertionsort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %while.end, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %jm1, %while.body ]
  %j.nonzero.not = icmp eq i64 %j, 0
  br i1 %j.nonzero.not, label %while.end, label %while.cmp

while.cmp:                                        ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a_jm1 = load i32, i32* %gep.jm1, align 4
  %key_lt = icmp slt i32 %key, %a_jm1
  br i1 %key_lt, label %while.body, label %while.end

while.body:                                       ; preds = %while.cmp
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a_jm1, i32* %gep.j, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cmp, %while.cond
  %gep.final = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %gep.final, align 4
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}
