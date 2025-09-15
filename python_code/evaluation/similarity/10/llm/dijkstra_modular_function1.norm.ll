; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function1.ll"
target triple = "x86_64-pc-linux-gnu"

define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp_i = icmp slt i32 %i, %n
  br i1 %cmp_i, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j = phi i32 [ %j.next, %inner.body ], [ 0, %outer.cond ]
  %cmp_j = icmp slt i32 %j, %n
  br i1 %cmp_j, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = zext i32 %i to i64
  %mul = mul nuw nsw i64 %i.ext, 100
  %j.ext = zext i32 %j to i64
  %idx = add nuw nsw i64 %mul, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
