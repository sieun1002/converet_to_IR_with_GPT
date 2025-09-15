; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function1.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
define dso_local void @init_graph(i32* nocapture %graph, i32 %n) local_unnamed_addr #0 {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i.ph, %n
  br i1 %cmp.outer, label %inner.cond, label %end

inner.cond:                                       ; preds = %inner.body, %outer.cond
  %j.ph = phi i32 [ 0, %outer.cond ], [ %j.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j.ph, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = zext i32 %i.ph to i64
  %j.ext = zext i32 %j.ph to i64
  %i.mul = mul nuw nsw i64 %i.ext, 100
  %rowoff = add nuw nsw i64 %i.mul, %j.ext
  %elt.ptr = getelementptr inbounds i32, i32* %graph, i64 %rowoff
  store i32 0, i32* %elt.ptr, align 4
  %j.next = add nuw nsw i32 %j.ph, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nuw nsw i32 %i.ph, 1
  br label %outer.cond

end:                                              ; preds = %outer.cond
  ret void
}

attributes #0 = { nounwind }
