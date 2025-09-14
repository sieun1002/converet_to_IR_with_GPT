; ModuleID = 'recovered'
source_filename = "recovered.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* %matrix, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %row.neg = icmp slt i32 %row, 0
  br i1 %row.neg, label %ret, label %check_col

check_col:
  %col.neg = icmp slt i32 %col, 0
  br i1 %col.neg, label %ret, label %store

store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %rowOff = mul nsw i64 %row64, 100
  %idx = add nsw i64 %rowOff, %col64
  %ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %sym.zero = icmp eq i32 %sym, 0
  br i1 %sym.zero, label %ret, label %store_sym

store_sym:
  %rowOff2 = mul nsw i64 %col64, 100
  %idx2 = add nsw i64 %rowOff2, %row64
  %ptr2 = getelementptr inbounds i32, i32* %matrix, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}