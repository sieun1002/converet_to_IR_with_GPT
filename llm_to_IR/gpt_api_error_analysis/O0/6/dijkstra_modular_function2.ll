define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i_neg = icmp slt i32 %i, 0
  br i1 %cmp_i_neg, label %ret, label %check_j

check_j:
  %cmp_j_neg = icmp slt i32 %j, 0
  br i1 %cmp_j_neg, label %ret, label %store_main

store_main:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row_off = mul nsw i64 %i64, 100
  %idx = add nsw i64 %row_off, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %ret, label %store_sym

store_sym:
  %row_off2 = mul nsw i64 %j64, 100
  %idx2 = add nsw i64 %row_off2, %i64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}