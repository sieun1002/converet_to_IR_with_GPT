; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.check

for.check:                                        ; preds = %while.exit, %entry
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %while.exit ]
  %cmp.for = icmp ult i64 %i.ph, %n
  br i1 %cmp.for, label %for.body, label %for.end

for.body:                                         ; preds = %for.check
  %gep.key = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key.load = load i32, i32* %gep.key, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.shift, %for.body
  %j.ph = phi i64 [ %i.ph, %for.body ], [ %j.minus1, %while.shift ]
  %j.gt0.not = icmp eq i64 %j.ph, 0
  br i1 %j.gt0.not, label %while.exit, label %while.cmp

while.cmp:                                        ; preds = %while.cond
  %j.minus1 = add i64 %j.ph, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.sgt = icmp sgt i32 %val.jm1, %key.load
  br i1 %cmp.sgt, label %while.shift, label %while.exit

while.shift:                                      ; preds = %while.cmp
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %val.jm1, i32* %ptr.j, align 4
  br label %while.cond

while.exit:                                       ; preds = %while.cmp, %while.cond
  %j.final = phi i64 [ 0, %while.cond ], [ %j.ph, %while.cmp ]
  %ptr.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key.load, i32* %ptr.final, align 4
  %i.next = add i64 %i.ph, 1
  br label %for.check

for.end:                                          ; preds = %for.check
  ret void
}
