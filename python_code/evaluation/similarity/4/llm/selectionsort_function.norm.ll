; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/selectionsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/selectionsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %inner.end, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inner.end ]
  %n.sub = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n.sub
  br i1 %cond.outer, label %inner.loop, label %exit

inner.loop:                                       ; preds = %outer.loop, %inner.compare
  %min.cur = phi i32 [ %spec.select, %inner.compare ], [ %i, %outer.loop ]
  %j.cur.in = phi i32 [ %j.cur, %inner.compare ], [ %i, %outer.loop ]
  %j.cur = add nuw nsw i32 %j.cur.in, 1
  %cmp.j = icmp slt i32 %j.cur, %n
  br i1 %cmp.j, label %inner.compare, label %inner.end

inner.compare:                                    ; preds = %inner.loop
  %j.ext = zext i32 %j.cur to i64
  %min.ext = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  %spec.select = select i1 %lt, i32 %j.cur, i32 %min.cur
  br label %inner.loop

inner.end:                                        ; preds = %inner.loop
  %i.ext = zext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.cur to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %val.min2 = load i32, i32* %min.final.ptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.loop

exit:                                             ; preds = %outer.loop
  ret void
}
