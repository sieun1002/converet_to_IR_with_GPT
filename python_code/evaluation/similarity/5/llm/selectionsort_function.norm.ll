; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.sub1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.sub1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.latch
  %j.in = phi i32 [ %j, %inner.latch ], [ %i, %outer.cond ]
  %minIdx = phi i32 [ %minIdx.next, %inner.latch ], [ %i, %outer.cond ]
  %j = add i32 %j.in, 1
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.latch, label %after.inner

inner.latch:                                      ; preds = %inner.cond
  %j.sext = sext i32 %j to i64
  %j.ptr = getelementptr i32, i32* %arr, i64 %j.sext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.sext = sext i32 %minIdx to i64
  %min.ptr = getelementptr i32, i32* %arr, i64 %min.sext
  %min.val = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %j.val, %min.val
  %minIdx.next = select i1 %isless, i32 %j, i32 %minIdx
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.sext = sext i32 %i to i64
  %i.ptr = getelementptr i32, i32* %arr, i64 %i.sext
  %i.val = load i32, i32* %i.ptr, align 4
  %minA.sext = sext i32 %minIdx to i64
  %minA.ptr = getelementptr i32, i32* %arr, i64 %minA.sext
  %minA.val = load i32, i32* %minA.ptr, align 4
  store i32 %minA.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %minA.ptr, align 4
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
