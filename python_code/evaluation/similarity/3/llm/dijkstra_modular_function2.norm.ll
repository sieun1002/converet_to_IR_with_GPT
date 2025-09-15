; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function2.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function2.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* nocapture %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %0 = or i32 %row, %col
  %1 = icmp sgt i32 %0, -1
  br i1 %1, label %do_store, label %ret

do_store:                                         ; preds = %entry
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %mul = mul nsw i64 %row64, 100
  %idx = add nsw i64 %mul, %col64
  %ptr1 = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr1, align 4
  %symnz.not = icmp eq i32 %sym, 0
  br i1 %symnz.not, label %ret, label %sym_store

sym_store:                                        ; preds = %do_store
  %mul2 = mul nsw i64 %col64, 100
  %idx2 = add nsw i64 %mul2, %row64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:                                              ; preds = %sym_store, %do_store, %entry
  ret void
}
