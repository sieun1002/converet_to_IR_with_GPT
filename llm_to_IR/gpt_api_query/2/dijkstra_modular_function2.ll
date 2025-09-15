; ModuleID = 'recovered'
define void @add_edge(i32* %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %row_ge0 = icmp sge i32 %row, 0
  %col_ge0 = icmp sge i32 %col, 0
  %ok = and i1 %row_ge0, %col_ge0
  br i1 %ok, label %cont, label %ret

cont:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %row_mul = mul nsw i64 %row64, 100
  %offset = add nsw i64 %row_mul, %col64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %offset
  store i32 %val, i32* %ptr, align 4
  %sym_nz = icmp ne i32 %sym, 0
  br i1 %sym_nz, label %symm, label %ret

symm:
  %row64b = sext i32 %row to i64
  %col64b = sext i32 %col to i64
  %col_mul = mul nsw i64 %col64b, 100
  %offset2 = add nsw i64 %col_mul, %row64b
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %offset2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}