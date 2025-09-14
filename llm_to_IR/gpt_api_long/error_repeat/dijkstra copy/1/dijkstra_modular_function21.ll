; ModuleID = 'add_edge'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_edge  ; Address: 0x4011B0
; Intent: Write to adjacency/weight matrix cell and optionally its symmetric counterpart (confidence=0.86). Evidence: 0x190 row stride (= 100 i32s), symmetric write when flag nonzero.
; Preconditions: matrix is laid out as rows of 100 i32 elements; indices row,col must be >= 0 (no upper-bound checks).
; Postconditions: matrix[row][col] = val; if undirected != 0 then matrix[col][row] = val.

define dso_local void @add_edge(i32* %matrix, i32 %row, i32 %col, i32 %val, i32 %undirected) local_unnamed_addr {
entry:
  %cmp_row_neg = icmp slt i32 %row, 0
  br i1 %cmp_row_neg, label %ret, label %check_col

check_col:
  %cmp_col_neg = icmp slt i32 %col, 0
  br i1 %cmp_col_neg, label %ret, label %do_store

do_store:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  ; 0x190 bytes per row = 400 bytes = 100 i32 elements
  %row_stride = mul nsw i64 %row64, 100
  %idx = add i64 %row_stride, %col64
  %ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %is_zero = icmp eq i32 %undirected, 0
  br i1 %is_zero, label %ret, label %do_sym

do_sym:
  %col_stride = mul nsw i64 %col64, 100
  %idx_sym = add i64 %col_stride, %row64
  %ptr_sym = getelementptr inbounds i32, i32* %matrix, i64 %idx_sym
  store i32 %val, i32* %ptr_sym, align 4
  br label %ret

ret:
  ret void
}