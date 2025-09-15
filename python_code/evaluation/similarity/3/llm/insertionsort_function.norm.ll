; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %after.inner ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.header
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %inner.header

inner.header:                                     ; preds = %shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %jm1, %shift ]
  %j.is0 = icmp eq i64 %j, 0
  br i1 %j.is0, label %after.inner, label %check

check:                                            ; preds = %inner.header
  %jm1 = add i64 %j, -1
  %addr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %addr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %shift, label %after.inner

shift:                                            ; preds = %check
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %addr.j, align 4
  br label %inner.header

after.inner:                                      ; preds = %check, %inner.header
  %addr.jf = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %addr.jf, align 4
  %i.next = add i64 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
