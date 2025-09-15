; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i.ph, %n.minus1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j.ph.in = phi i32 [ %j.ph, %inner.body ], [ %i.ph, %outer.cond ]
  %min.ph = phi i32 [ %min.sel, %inner.body ], [ %i.ph, %outer.cond ]
  %j.ph = add i32 %j.ph.in, 1
  %cmp.jn = icmp slt i32 %j.ph, %n
  br i1 %cmp.jn, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.ext = sext i32 %j.ph to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %valj = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.ph to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %valmin = load i32, i32* %min.ptr, align 4
  %cmp.lt = icmp slt i32 %valj, %valmin
  %min.sel = select i1 %cmp.lt, i32 %j.ph, i32 %min.ph
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.ext = sext i32 %i.ph to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.end.ext = sext i32 %min.ph to i64
  %min.end.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.end.ext
  %min.val = load i32, i32* %min.end.ptr, align 4
  store i32 %min.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.end.ptr, align 4
  %i.next = add i32 %i.ph, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
