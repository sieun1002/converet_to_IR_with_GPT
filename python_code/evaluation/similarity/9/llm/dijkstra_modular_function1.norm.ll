; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function1.ll"
target triple = "x86_64-pc-linux-gnu"

define void @init_graph(i32* nocapture %base, i32 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:                                     ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.body
  %j = phi i32 [ %j.next, %inner.body ], [ 0, %outer.header ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner.header
  %i.ext = zext i32 %i to i64
  %row.off = mul nuw nsw i64 %i.ext, 100
  %j.ext = zext i32 %j to i64
  %elem.idx = add nuw nsw i64 %row.off, %j.ext
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %elem.idx
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.header

outer.latch:                                      ; preds = %inner.header
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
