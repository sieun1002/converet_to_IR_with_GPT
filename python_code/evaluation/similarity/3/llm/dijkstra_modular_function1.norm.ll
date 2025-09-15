; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function1.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @init_graph(i32* noundef %p, i32 noundef %n) {
entry:
  %cmp.n.pos = icmp sgt i32 %n, 0
  br i1 %cmp.n.pos, label %outer.loop, label %done

outer.loop:                                       ; preds = %outer.cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.cont ]
  br label %inner.loop

inner.loop:                                       ; preds = %inner.body, %outer.loop
  %j = phi i32 [ 0, %outer.loop ], [ %j.next, %inner.body ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %outer.cont

inner.body:                                       ; preds = %inner.loop
  %i64 = zext i32 %i to i64
  %mul = mul nuw nsw i64 %i64, 100
  %j64 = zext i32 %j to i64
  %index = add nuw nsw i64 %mul, %j64
  %elem.ptr = getelementptr inbounds i32, i32* %p, i64 %index
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.loop

outer.cont:                                       ; preds = %inner.loop
  %i.next = add nuw nsw i32 %i, 1
  %i.cmp = icmp slt i32 %i.next, %n
  br i1 %i.cmp, label %outer.loop, label %done

done:                                             ; preds = %outer.cont, %entry
  ret void
}
