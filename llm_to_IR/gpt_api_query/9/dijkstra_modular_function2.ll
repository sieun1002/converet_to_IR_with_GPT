; ModuleID = 'add_edge.ll'

define void @add_edge(i32* %base, i32 %row, i32 %col, i32 %val, i32 %flag) {
entry:
  %row.neg = icmp slt i32 %row, 0
  br i1 %row.neg, label %exit, label %check_col

check_col:
  %col.ge0 = icmp sge i32 %col, 0
  br i1 %col.ge0, label %store, label %exit

store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %row_off = mul i64 %row64, 100
  %idx = add i64 %row_off, %col64
  %ptr = getelementptr i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %flag.zero = icmp eq i32 %flag, 0
  br i1 %flag.zero, label %exit, label %store2

store2:
  %row_off2 = mul i64 %col64, 100
  %idx2 = add i64 %row_off2, %row64
  %ptr2 = getelementptr i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %exit

exit:
  ret void
}