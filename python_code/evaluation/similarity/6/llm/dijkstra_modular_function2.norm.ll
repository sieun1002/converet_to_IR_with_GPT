; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function2.ll"

define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i_neg = icmp slt i32 %i, 0
  %cmp_j_neg = icmp slt i32 %j, 0
  %or.cond = select i1 %cmp_i_neg, i1 true, i1 %cmp_j_neg
  br i1 %or.cond, label %ret, label %store_main

store_main:                                       ; preds = %entry
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row_off = mul nsw i64 %i64, 100
  %idx = add nsw i64 %row_off, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %ret, label %store_sym

store_sym:                                        ; preds = %store_main
  %row_off2 = mul nsw i64 %j64, 100
  %idx2 = add nsw i64 %row_off2, %i64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:                                              ; preds = %store_sym, %store_main, %entry
  ret void
}
