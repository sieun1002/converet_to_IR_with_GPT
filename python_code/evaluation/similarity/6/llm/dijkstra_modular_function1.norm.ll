; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function1.ll"

define void @init_graph([100 x i32]* %graph, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer.not = icmp slt i32 %i, %n
  br i1 %cmp.outer.not, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %store
  %j = phi i32 [ %j.next, %store ], [ 0, %outer.cond ]
  %cmp.inner.not = icmp slt i32 %j, %n
  br i1 %cmp.inner.not, label %store, label %outer.inc

store:                                            ; preds = %inner.cond
  %0 = zext i32 %i to i64
  %1 = zext i32 %j to i64
  %eltptr = getelementptr [100 x i32], [100 x i32]* %graph, i64 %0, i64 %1
  store i32 0, i32* %eltptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
