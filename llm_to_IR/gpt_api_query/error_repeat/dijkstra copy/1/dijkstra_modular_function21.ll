; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %flag) local_unnamed_addr {
entry:
  %cmp_i = icmp slt i32 %i, 0
  br i1 %cmp_i, label %ret, label %chk_j

chk_j:
  %cmp_j = icmp slt i32 %j, 0
  br i1 %cmp_j, label %ret, label %store

store:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row_off = mul nsw i64 %i64, 100
  %idx = add i64 %row_off, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret, label %store_sym

store_sym:
  %row_off_sym = mul nsw i64 %j64, 100
  %idx_sym = add i64 %row_off_sym, %i64
  %ptr_sym = getelementptr inbounds i32, i32* %base, i64 %idx_sym
  store i32 %val, i32* %ptr_sym, align 4
  br label %ret

ret:
  ret void
}