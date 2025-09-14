; ModuleID = 'add_edge.ll'
source_filename = "add_edge"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @add_edge(i32* %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %row_lt0 = icmp slt i32 %row, 0
  br i1 %row_lt0, label %ret, label %checkcol

checkcol:
  %col_ge0 = icmp sge i32 %col, 0
  br i1 %col_ge0, label %do_store, label %ret

do_store:
  %row_sxt = sext i32 %row to i64
  %row_mul = mul nsw i64 %row_sxt, 100
  %col_sxt = sext i32 %col to i64
  %index = add nsw i64 %row_mul, %col_sxt
  %elem_ptr = getelementptr inbounds i32, i32* %base, i64 %index
  store i32 %val, i32* %elem_ptr, align 4
  %sym_ne0 = icmp ne i32 %sym, 0
  br i1 %sym_ne0, label %do_sym, label %ret

do_sym:
  %col_sxt_2 = sext i32 %col to i64
  %col_mul = mul nsw i64 %col_sxt_2, 100
  %row_sxt_2 = sext i32 %row to i64
  %index_sym = add nsw i64 %col_mul, %row_sxt_2
  %elem_ptr_sym = getelementptr inbounds i32, i32* %base, i64 %index_sym
  store i32 %val, i32* %elem_ptr_sym, align 4
  br label %ret

ret:
  ret void
}