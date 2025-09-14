; ModuleID = 'add_edge'
source_filename = "add_edge"

define dso_local void @add_edge(i32* %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %row_nonneg = icmp sge i32 %row, 0
  %col_nonneg = icmp sge i32 %col, 0
  %ok = and i1 %row_nonneg, %col_nonneg
  br i1 %ok, label %store, label %ret

store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %row_elems = mul i64 %row64, 100
  %idx = add i64 %row_elems, %col64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %sym_not_zero = icmp ne i32 %sym, 0
  br i1 %sym_not_zero, label %symm, label %ret

symm:
  %col_row_elems = mul i64 %col64, 100
  %idx2 = add i64 %col_row_elems, %row64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}