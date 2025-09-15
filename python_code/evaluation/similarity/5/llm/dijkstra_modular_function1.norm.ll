; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function1.ll"

define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %outer.cond = icmp slt i32 %i, %n
  br i1 %outer.cond, label %inner.loop, label %exit

inner.loop:                                       ; preds = %outer.loop, %store
  %j = phi i32 [ %j.next, %store ], [ 0, %outer.loop ]
  %inner.cond = icmp slt i32 %j, %n
  br i1 %inner.cond, label %store, label %outer.inc

store:                                            ; preds = %inner.loop
  %i.ext = zext i32 %i to i64
  %row.mul = mul nuw nsw i64 %i.ext, 100
  %j.ext = zext i32 %j to i64
  %idx = add nuw nsw i64 %row.mul, %j.ext
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.loop

outer.inc:                                        ; preds = %inner.loop
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.loop

exit:                                             ; preds = %outer.loop
  ret void
}
