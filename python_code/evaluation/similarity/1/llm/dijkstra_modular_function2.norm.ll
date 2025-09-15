; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function2.ll'
source_filename = "add_edge.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* nocapture %base, i32 %i, i32 %j, i32 %val, i32 %flag) local_unnamed_addr {
entry:
  %cmp_i_neg = icmp sge i32 %i, 0
  %cmp_j_nonneg = icmp sgt i32 %j, -1
  %or.cond = select i1 %cmp_i_neg, i1 %cmp_j_nonneg, i1 false
  br i1 %or.cond, label %do_store, label %end

do_store:                                         ; preds = %entry
  %i_sext = sext i32 %i to i64
  %j_sext = sext i32 %j to i64
  %i_mul_100 = mul nsw i64 %i_sext, 100
  %idx_lin = add nsw i64 %i_mul_100, %j_sext
  %ptr_ij = getelementptr inbounds i32, i32* %base, i64 %idx_lin
  store i32 %val, i32* %ptr_ij, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %end, label %do_store_sym

do_store_sym:                                     ; preds = %do_store
  %j_mul_100 = mul nsw i64 %j_sext, 100
  %idx_lin_sym = add nsw i64 %j_mul_100, %i_sext
  %ptr_ji = getelementptr inbounds i32, i32* %base, i64 %idx_lin_sym
  store i32 %val, i32* %ptr_ji, align 4
  br label %end

end:                                              ; preds = %do_store_sym, %do_store, %entry
  ret void
}
