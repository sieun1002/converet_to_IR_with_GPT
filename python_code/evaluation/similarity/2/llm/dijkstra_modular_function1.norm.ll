; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function1.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function1.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @init_graph(i8* %base, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i.not = icmp slt i32 %i, %n
  br i1 %cmp.i.not, label %inner.header, label %exit

inner.header:                                     ; preds = %inner.body, %outer.header
  %j = phi i32 [ 0, %outer.header ], [ %j.next, %inner.body ]
  %cmp.j.not = icmp slt i32 %j, %n
  br i1 %cmp.j.not, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner.header
  %i.ext = zext i32 %i to i64
  %row.off = mul nuw nsw i64 %i.ext, 400
  %row.ptr.i8 = getelementptr inbounds i8, i8* %base, i64 %row.off
  %row.ptr.i32 = bitcast i8* %row.ptr.i8 to i32*
  %j.ext = zext i32 %j to i64
  %elem.ptr = getelementptr inbounds i32, i32* %row.ptr.i32, i64 %j.ext
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.header

outer.latch:                                      ; preds = %inner.header
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
