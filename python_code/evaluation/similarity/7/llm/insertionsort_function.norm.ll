; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.check

for.check:                                        ; preds = %while.end, %entry
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %cmp.for = icmp ult i64 %i.ph, %n
  br i1 %cmp.for, label %for.body, label %for.end

for.body:                                         ; preds = %for.check
  %gep.key = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key = load i32, i32* %gep.key, align 4
  br label %while.check

while.check:                                      ; preds = %while.body, %for.body
  %j.ph = phi i64 [ %i.ph, %for.body ], [ %j.minus1, %while.body ]
  %cond.jgt0.not = icmp eq i64 %j.ph, 0
  br i1 %cond.jgt0.not, label %while.end, label %cmp.load

cmp.load:                                         ; preds = %while.check
  %j.minus1 = add i64 %j.ph, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %gep.jm1, align 4
  %cmp.lt = icmp slt i32 %key, %val.jm1
  br i1 %cmp.lt, label %while.body, label %while.end

while.body:                                       ; preds = %cmp.load
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %val.jm1, i32* %gep.j, align 4
  br label %while.check

while.end:                                        ; preds = %cmp.load, %while.check
  %gep.dest = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %key, i32* %gep.dest, align 4
  %i.next = add i64 %i.ph, 1
  br label %for.check

for.end:                                          ; preds = %for.check
  ret void
}
