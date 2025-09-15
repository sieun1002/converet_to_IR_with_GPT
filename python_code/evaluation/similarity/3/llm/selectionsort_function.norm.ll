; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/selectionsort_function.ll"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %inner.exit, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inner.exit ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.inc
  %j.in = phi i32 [ %j, %inner.inc ], [ %i, %outer.header ]
  %minIndex = phi i32 [ %minIndex.next, %inner.inc ], [ %i, %outer.header ]
  %j = add nuw nsw i32 %j.in, 1
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.inc, label %inner.exit

inner.inc:                                        ; preds = %inner.header
  %j64 = zext i32 %j to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %minIndex to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %is_less = icmp slt i32 %valj, %valmin
  %minIndex.next = select i1 %is_less, i32 %j, i32 %minIndex
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %i64 = zext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %ptri, align 4
  %min64b = sext i32 %minIndex to i64
  %ptrmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %valmin2 = load i32, i32* %ptrmin2, align 4
  store i32 %valmin2, i32* %ptri, align 4
  store i32 %tmp, i32* %ptrmin2, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
