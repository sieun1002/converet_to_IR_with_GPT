; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %i.cur = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.cur, %n.minus1
  br i1 %cmp.outer, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.latch
  %min.cur = phi i32 [ %min.sel, %inner.latch ], [ %i.cur, %outer.header ]
  %j.cur.in = phi i32 [ %j.cur, %inner.latch ], [ %i.cur, %outer.header ]
  %j.cur = add nuw nsw i32 %j.cur.in, 1
  %cmp.inner = icmp slt i32 %j.cur, %n
  br i1 %cmp.inner, label %inner.latch, label %after.inner

inner.latch:                                      ; preds = %inner.header
  %j.ext = zext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %lt, i32 %j.cur, i32 %min.cur
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %i.ext = zext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.exit.ext = sext i32 %min.cur to i64
  %min.exit.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.exit.ext
  %min.load = load i32, i32* %min.exit.ptr, align 4
  store i32 %min.load, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.exit.ptr, align 4
  %i.next = add nuw nsw i32 %i.cur, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
