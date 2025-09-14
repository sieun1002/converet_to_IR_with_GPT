define void @add_edge(i32* %matrix, i32 %row, i32 %col, i32 %weight, i32 %symmetric) {
entry:
  %row_neg = icmp slt i32 %row, 0
  br i1 %row_neg, label %exit, label %check_col

check_col:
  %col_neg = icmp slt i32 %col, 0
  br i1 %col_neg, label %exit, label %store

store:
  %row_sext = sext i32 %row to i64
  %row_mul = mul i64 %row_sext, 100
  %col_sext = sext i32 %col to i64
  %index = add i64 %row_mul, %col_sext
  %ptr = getelementptr i32, i32* %matrix, i64 %index
  store i32 %weight, i32* %ptr, align 4
  %is_sym_zero = icmp eq i32 %symmetric, 0
  br i1 %is_sym_zero, label %exit, label %store_sym

store_sym:
  %col_sext2 = sext i32 %col to i64
  %col_mul2 = mul i64 %col_sext2, 100
  %row_sext2 = sext i32 %row to i64
  %index2 = add i64 %col_mul2, %row_sext2
  %ptr2 = getelementptr i32, i32* %matrix, i64 %index2
  store i32 %weight, i32* %ptr2, align 4
  br label %exit

exit:
  ret void
}