; ModuleID = 'add_edge.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @add_edge(i32* %base, i32 %s, i32 %t, i32 %w, i32 %flag) {
entry:
  %s_neg = icmp slt i32 %s, 0
  br i1 %s_neg, label %exit, label %check_t

check_t:
  %t_nonneg = icmp sge i32 %t, 0
  br i1 %t_nonneg, label %do_store, label %exit

do_store:
  %s64 = sext i32 %s to i64
  %t64 = sext i32 %t to i64
  %rowmul = mul i64 %s64, 100
  %idx = add i64 %rowmul, %t64
  %cell = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %w, i32* %cell, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %exit, label %do_store_sym

do_store_sym:
  %t64b = sext i32 %t to i64
  %s64b = sext i32 %s to i64
  %rowmul_b = mul i64 %t64b, 100
  %idx_b = add i64 %rowmul_b, %s64b
  %cell_b = getelementptr inbounds i32, i32* %base, i64 %idx_b
  store i32 %w, i32* %cell_b, align 4
  br label %exit

exit:
  ret void
}