; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/selectionsort_function.ll"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %cmp.n1 = icmp sgt i32 %n, 1
  br i1 %cmp.n1, label %for.i, label %exit

for.i:                                            ; preds = %for.j.exit, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %for.j.exit ]
  br label %for.j.cond

for.j.cond:                                       ; preds = %for.j.body, %for.i
  %min.ph = phi i32 [ %i, %for.i ], [ %j.min.ph, %for.j.body ]
  %j.in = phi i32 [ %i, %for.i ], [ %j, %for.j.body ]
  %j = add nuw nsw i32 %j.in, 1
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %for.j.body, label %for.j.exit

for.j.body:                                       ; preds = %for.j.cond
  %j.ext = zext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %aj = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.ph to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %amin = load i32, i32* %min.ptr, align 4
  %cmp.min = icmp slt i32 %aj, %amin
  %j.min.ph = select i1 %cmp.min, i32 %j, i32 %min.ph
  br label %for.j.cond

for.j.exit:                                       ; preds = %for.j.cond
  %i.ext = zext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %ai = load i32, i32* %i.ptr, align 4
  %min2.ext = sext i32 %min.ph to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.ext
  %amin2 = load i32, i32* %min2.ptr, align 4
  store i32 %amin2, i32* %i.ptr, align 4
  store i32 %ai, i32* %min2.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.next, %n.minus1
  br i1 %cmp.outer, label %for.i, label %exit

exit:                                             ; preds = %for.j.exit, %entry
  ret void
}
