; ModuleID = 'add_edge_module'
source_filename = "add_edge.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %w, i32 %sym) {
entry:
  %cmp_i = icmp slt i32 %i, 0
  br i1 %cmp_i, label %return, label %check_j

check_j:
  %cmp_j = icmp slt i32 %j, 0
  br i1 %cmp_j, label %return, label %store1

store1:
  %i64 = sext i32 %i to i64
  %mul_i = mul nsw i64 %i64, 100
  %j64 = sext i32 %j to i64
  %idx = add nsw i64 %mul_i, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %w, i32* %ptr, align 4
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %return, label %store2

store2:
  %mul_j = mul nsw i64 %j64, 100
  %idx2 = add nsw i64 %mul_j, %i64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %w, i32* %ptr2, align 4
  br label %return

return:
  ret void
}