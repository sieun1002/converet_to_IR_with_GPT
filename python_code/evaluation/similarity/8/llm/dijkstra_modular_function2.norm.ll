; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function2.ll"

define void @add_edge(i32* %matrix, i32 %row, i32 %col, i32 %weight, i32 %symmetric) {
entry:
  %row_neg = icmp slt i32 %row, 0
  %col_neg = icmp slt i32 %col, 0
  %or.cond = select i1 %row_neg, i1 true, i1 %col_neg
  br i1 %or.cond, label %exit, label %store

store:                                            ; preds = %entry
  %row_sext = sext i32 %row to i64
  %row_mul = mul nsw i64 %row_sext, 100
  %col_sext = sext i32 %col to i64
  %index = add nsw i64 %row_mul, %col_sext
  %ptr = getelementptr i32, i32* %matrix, i64 %index
  store i32 %weight, i32* %ptr, align 4
  %is_sym_zero = icmp eq i32 %symmetric, 0
  br i1 %is_sym_zero, label %exit, label %store_sym

store_sym:                                        ; preds = %store
  %col_mul2 = mul nsw i64 %col_sext, 100
  %index2 = add nsw i64 %col_mul2, %row_sext
  %ptr2 = getelementptr i32, i32* %matrix, i64 %index2
  store i32 %weight, i32* %ptr2, align 4
  br label %exit

exit:                                             ; preds = %store_sym, %store, %entry
  ret void
}
