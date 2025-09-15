; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.0, %n.minus1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j.0.in = phi i32 [ %j.0, %inner.body ], [ %i.0, %outer.cond ]
  %min.0 = phi i32 [ %j.0.min.0, %inner.body ], [ %i.0, %outer.cond ]
  %j.0 = add nuw nsw i32 %j.0.in, 1
  %cmp.j.n = icmp slt i32 %j.0, %n
  br i1 %cmp.j.n, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.ext = zext i32 %j.0 to i64
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %val.j = load i32, i32* %gep.j, align 4
  %min.ext = sext i32 %min.0 to i64
  %gep.min = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.min = load i32, i32* %gep.min, align 4
  %cmp.lt = icmp slt i32 %val.j, %val.min
  %j.0.min.0 = select i1 %cmp.lt, i32 %j.0, i32 %min.0
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.ext = zext i32 %i.0 to i64
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %val.i = load i32, i32* %gep.i, align 4
  %min.ext2 = sext i32 %min.0 to i64
  %gep.min2 = getelementptr inbounds i32, i32* %arr, i64 %min.ext2
  %val.min2 = load i32, i32* %gep.min2, align 4
  store i32 %val.min2, i32* %gep.i, align 4
  store i32 %val.i, i32* %gep.min2, align 4
  %i.next = add nuw nsw i32 %i.0, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
