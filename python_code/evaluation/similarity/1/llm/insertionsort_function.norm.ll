; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/insertionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/insertionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                      ; preds = %insert, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %insert ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %loop.prep, label %exit

loop.prep:                                        ; preds = %loop.header
  %idx.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.i, align 4
  br label %inner.check

inner.check:                                      ; preds = %inner.shift, %loop.prep
  %j = phi i64 [ %i, %loop.prep ], [ %j.minus1, %inner.shift ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %insert, label %compare

compare:                                          ; preds = %inner.check
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %lt = icmp slt i32 %key, %val.jm1
  br i1 %lt, label %inner.shift, label %insert

inner.shift:                                      ; preds = %compare
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  br label %inner.check

insert:                                           ; preds = %compare, %inner.check
  %dest = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %dest, align 4
  %i.next = add i64 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret void
}
