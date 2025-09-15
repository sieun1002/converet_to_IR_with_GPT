; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function1.ll'
source_filename = "init_graph.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.cond, label %return

inner.cond:                                       ; preds = %outer.cond, %body
  %j = phi i32 [ %j.next, %body ], [ 0, %outer.cond ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %body, label %outer.inc

body:                                             ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %mul = mul nsw i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %idx = add nsw i64 %mul, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %ptr, align 4
  %j.next = add i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add i32 %i, 1
  br label %outer.cond

return:                                           ; preds = %outer.cond
  ret void
}
