; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %insert, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %insert ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val = load i32, i32* %gep.i, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %jminus1, %inner.body ]
  %jgt0.not = icmp eq i64 %j, 0
  br i1 %jgt0.not, label %insert, label %inner.cmp

inner.cmp:                                        ; preds = %inner.cond
  %jminus1 = add i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %a.jm1 = load i32, i32* %gep.jm1, align 4
  %lt = icmp slt i32 %val, %a.jm1
  br i1 %lt, label %inner.body, label %insert

inner.body:                                       ; preds = %inner.cmp
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a.jm1, i32* %gep.j, align 4
  br label %inner.cond

insert:                                           ; preds = %inner.cmp, %inner.cond
  %gep.j.ins = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val, i32* %gep.j.ins, align 4
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
