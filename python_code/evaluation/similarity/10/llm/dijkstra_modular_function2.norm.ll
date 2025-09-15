; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function2.ll"
target triple = "x86_64-pc-linux-gnu"

define void @add_edge([100 x i32]* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %0 = or i32 %i, %j
  %.not = icmp sgt i32 %0, -1
  br i1 %.not, label %cont, label %ret

cont:                                             ; preds = %entry
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr [100 x i32], [100 x i32]* %base, i64 %i64, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %ret, label %sym_store

sym_store:                                        ; preds = %cont
  %elem_ptr_sym = getelementptr [100 x i32], [100 x i32]* %base, i64 %j64, i64 %i64
  store i32 %val, i32* %elem_ptr_sym, align 4
  br label %ret

ret:                                              ; preds = %sym_store, %cont, %entry
  ret void
}
