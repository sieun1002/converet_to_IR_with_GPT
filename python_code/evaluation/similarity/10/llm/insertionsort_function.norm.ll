; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %inner.end ]
  %cmp.outer = icmp ult i64 %i, %n
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %a.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %a.i.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %jm1, %inner.shift ]
  %j.gt0.not = icmp eq i64 %j, 0
  br i1 %j.gt0.not, label %inner.end, label %inner.cmp

inner.cmp:                                        ; preds = %inner.cond
  %jm1 = add i64 %j, -1
  %a.jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a.jm1 = load i32, i32* %a.jm1.ptr, align 4
  %keylt = icmp slt i32 %key, %a.jm1
  br i1 %keylt, label %inner.shift, label %inner.end

inner.shift:                                      ; preds = %inner.cmp
  %a.j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a.jm1, i32* %a.j.ptr, align 4
  br label %inner.cond

inner.end:                                        ; preds = %inner.cmp, %inner.cond
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
