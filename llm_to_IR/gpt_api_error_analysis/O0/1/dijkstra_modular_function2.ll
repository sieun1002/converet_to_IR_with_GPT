; ModuleID = 'add_edge_module'
source_filename = "add_edge.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* nocapture %base, i32 %i, i32 %j, i32 %val, i32 %flag) local_unnamed_addr {
entry:
  %cmp_i_neg = icmp slt i32 %i, 0
  br i1 %cmp_i_neg, label %end, label %check_j

check_j:
  %cmp_j_nonneg = icmp sge i32 %j, 0
  br i1 %cmp_j_nonneg, label %do_store, label %end

do_store:
  %i_sext = sext i32 %i to i64
  %j_sext = sext i32 %j to i64
  %i_mul_100 = mul nsw i64 %i_sext, 100
  %idx_lin = add nsw i64 %i_mul_100, %j_sext
  %ptr_ij = getelementptr inbounds i32, i32* %base, i64 %idx_lin
  store i32 %val, i32* %ptr_ij, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %end, label %do_store_sym

do_store_sym:
  %j_mul_100 = mul nsw i64 %j_sext, 100
  %idx_lin_sym = add nsw i64 %j_mul_100, %i_sext
  %ptr_ji = getelementptr inbounds i32, i32* %base, i64 %idx_lin_sym
  store i32 %val, i32* %ptr_ji, align 4
  br label %end

end:
  ret void
}