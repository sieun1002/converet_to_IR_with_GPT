; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %inner.exit, %entry
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %inner.exit ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.phi, %n.minus1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j.phi.in = phi i32 [ %j.phi, %inner.body ], [ %i.phi, %outer.cond ]
  %min.phi = phi i32 [ %j.phi.min.phi, %inner.body ], [ %i.phi, %outer.cond ]
  %j.phi = add nuw nsw i32 %j.phi.in, 1
  %cmp.inner = icmp slt i32 %j.phi, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.cond
  %j.idx.ext = zext i32 %j.phi to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx.ext = sext i32 %min.phi to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %cmp.sel = icmp slt i32 %j.val, %min.val
  %j.phi.min.phi = select i1 %cmp.sel, i32 %j.phi, i32 %min.phi
  br label %inner.cond

inner.exit:                                       ; preds = %inner.cond
  %i.idx.ext = zext i32 %i.phi to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %minf.idx.ext = sext i32 %min.phi to i64
  %minf.ptr = getelementptr inbounds i32, i32* %arr, i64 %minf.idx.ext
  %minf.val = load i32, i32* %minf.ptr, align 4
  store i32 %minf.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %minf.ptr, align 4
  %i.next = add nuw nsw i32 %i.phi, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
