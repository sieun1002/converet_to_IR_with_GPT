; ModuleID = 'add_edge'
source_filename = "add_edge.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @add_edge(i32* nocapture %base, i32 %row, i32 %col, i32 %val, i32 %bidir) local_unnamed_addr {
entry:
  %cmp_row_neg = icmp slt i32 %row, 0
  br i1 %cmp_row_neg, label %ret, label %check_col

check_col:
  %cmp_col_neg = icmp slt i32 %col, 0
  br i1 %cmp_col_neg, label %ret, label %do_store

do_store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %row_mul_100 = mul i64 %row64, 100
  %idx = add i64 %row_mul_100, %col64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4

  %is_bidir_zero = icmp eq i32 %bidir, 0
  br i1 %is_bidir_zero, label %ret, label %do_sym

do_sym:
  %col_mul_100 = mul i64 %col64, 100
  %idx2 = add i64 %col_mul_100, %row64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:
  ret void
}