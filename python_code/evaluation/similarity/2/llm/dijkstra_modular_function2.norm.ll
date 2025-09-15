; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_function2.ll"
target triple = "x86_64-pc-linux-gnu"

define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i = icmp sge i32 %i, 0
  %cmp_j = icmp sgt i32 %j, -1
  %or.cond = select i1 %cmp_i, i1 %cmp_j, i1 false
  br i1 %or.cond, label %store_main, label %exit

store_main:                                       ; preds = %entry
  %i64 = sext i32 %i to i64
  %row_bytes = mul nsw i64 %i64, 100
  %row_ptr_i81 = getelementptr inbounds i32, i32* %base, i64 %row_bytes
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr_i81, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %exit, label %store_sym

store_sym:                                        ; preds = %store_main
  %row_bytes_2 = mul nsw i64 %j64, 100
  %row_ptr_i8_22 = getelementptr inbounds i32, i32* %base, i64 %row_bytes_2
  %elem_ptr_2 = getelementptr inbounds i32, i32* %row_ptr_i8_22, i64 %i64
  store i32 %val, i32* %elem_ptr_2, align 4
  br label %exit

exit:                                             ; preds = %store_sym, %store_main, %entry
  ret void
}
