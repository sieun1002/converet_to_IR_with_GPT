; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function1.ll"
target triple = "x86_64-pc-linux-gnu"

define void @init_graph([100 x i32]* %matrix, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j = phi i32 [ %j.next, %inner.body ], [ 0, %outer.cond ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = zext i32 %i to i64
  %j.ext = zext i32 %j to i64
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %matrix, i64 %i.ext, i64 %j.ext
  store i32 0, i32* %eltptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
