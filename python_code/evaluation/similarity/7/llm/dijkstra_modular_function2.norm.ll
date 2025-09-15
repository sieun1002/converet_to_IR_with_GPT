; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function2.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %flag) local_unnamed_addr #0 {
entry:
  %cmp_i = icmp slt i32 %i, 0
  %cmp_j = icmp slt i32 %j, 0
  %or.cond = select i1 %cmp_i, i1 true, i1 %cmp_j
  br i1 %or.cond, label %ret, label %do_store

do_store:                                         ; preds = %entry
  %i64 = sext i32 %i to i64
  %row_off = mul nsw i64 %i64, 100
  %row_ptr_i81 = getelementptr inbounds i32, i32* %base, i64 %row_off
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr_i81, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %ret, label %do_sym

do_sym:                                           ; preds = %do_store
  %row_off2 = mul nsw i64 %j64, 100
  %row_ptr2_i82 = getelementptr inbounds i32, i32* %base, i64 %row_off2
  %elem_ptr2 = getelementptr inbounds i32, i32* %row_ptr2_i82, i64 %i64
  store i32 %val, i32* %elem_ptr2, align 4
  br label %ret

ret:                                              ; preds = %do_sym, %do_store, %entry
  ret void
}

attributes #0 = { nounwind }
