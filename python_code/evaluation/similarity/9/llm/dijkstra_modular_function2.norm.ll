; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function2.ll"
target triple = "x86_64-pc-linux-gnu"

define void @add_edge(i32* %base, i32 %row, i32 %col, i32 %val, i32 %undirected) {
entry:
  %cmp_row_neg = icmp slt i32 %row, 0
  %cmp_col_neg = icmp slt i32 %col, 0
  %or.cond = select i1 %cmp_row_neg, i1 true, i1 %cmp_col_neg
  br i1 %or.cond, label %exit, label %do_store

do_store:                                         ; preds = %entry
  %row_sext = sext i32 %row to i64
  %col_sext = sext i32 %col to i64
  %row_mul_100 = mul nsw i64 %row_sext, 100
  %idx = add nsw i64 %row_mul_100, %col_sext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %is_zero = icmp eq i32 %undirected, 0
  br i1 %is_zero, label %exit, label %do_store_sym

do_store_sym:                                     ; preds = %do_store
  %col_mul_100 = mul nsw i64 %col_sext, 100
  %idx2 = add nsw i64 %col_mul_100, %row_sext
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %exit

exit:                                             ; preds = %do_store_sym, %do_store, %entry
  ret void
}
