; ModuleID = 'add_edge.ll'
source_filename = "add_edge"

define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %w, i32 %sym) {
entry:
  %i_neg = icmp slt i32 %i, 0
  %j_neg = icmp slt i32 %j, 0
  %bad = or i1 %i_neg, %j_neg
  br i1 %bad, label %ret, label %store

store:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row_off = mul i64 %i64, 100
  %idx = add i64 %row_off, %j64
  %ptr = getelementptr i32, i32* %base, i64 %idx
  store i32 %w, i32* %ptr, align 4
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %ret, label %sym_store

sym_store:
  %row_off2 = mul i64 %j64, 100
  %idx2 = add i64 %row_off2, %i64
  %ptr2 = getelementptr i32, i32* %base, i64 %idx2
  store i32 %w, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}