; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function2.ll"

define void @add_edge(i8* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i = icmp sge i32 %i, 0
  %cmp_j = icmp sgt i32 %j, -1
  %or.cond = select i1 %cmp_i, i1 %cmp_j, i1 false
  br i1 %or.cond, label %store, label %end

store:                                            ; preds = %entry
  %i64_i = sext i32 %i to i64
  %row_bytes = mul nsw i64 %i64_i, 400
  %row_ptr_i8 = getelementptr i8, i8* %base, i64 %row_bytes
  %row_ptr_i32 = bitcast i8* %row_ptr_i8 to i32*
  %i64_j = sext i32 %j to i64
  %elem_ptr = getelementptr i32, i32* %row_ptr_i32, i64 %i64_j
  store i32 %val, i32* %elem_ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %end, label %sym_store

sym_store:                                        ; preds = %store
  %row_bytes2 = mul nsw i64 %i64_j, 400
  %row2_i8 = getelementptr i8, i8* %base, i64 %row_bytes2
  %row2_i32 = bitcast i8* %row2_i8 to i32*
  %elem2 = getelementptr i32, i32* %row2_i32, i64 %i64_i
  store i32 %val, i32* %elem2, align 4
  br label %end

end:                                              ; preds = %sym_store, %store, %entry
  ret void
}
