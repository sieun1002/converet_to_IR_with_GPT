; ModuleID = 'add_edge_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* nocapture %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %cmp_row = icmp sge i32 %row, 0
  %cmp_col = icmp sge i32 %col, 0
  %both_ok = and i1 %cmp_row, %cmp_col
  br i1 %both_ok, label %do_store, label %ret

do_store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %mul = mul nsw i64 %row64, 100
  %idx = add nsw i64 %mul, %col64
  %ptr1 = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr1, align 4
  %symnz = icmp ne i32 %sym, 0
  br i1 %symnz, label %sym_store, label %ret

sym_store:
  %mul2 = mul nsw i64 %col64, 100
  %idx2 = add nsw i64 %mul2, %row64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}