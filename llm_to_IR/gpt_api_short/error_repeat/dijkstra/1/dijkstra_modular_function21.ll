; ModuleID = 'add_edge'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_edge ; Address: 0x4011B0
; Intent: Set matrix cell [row][col] to val, and optionally [col][row] if symmetric (confidence=0.98). Evidence: row stride 0x190 bytes (100 i32s), conditional transposed store
; Preconditions: row >= 0 and col >= 0
; Postconditions: If preconditions hold: A[row][col] = val; if sym != 0 then also A[col][row] = val

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @add_edge(i8* nocapture %base, i32 %row, i32 %col, i32 %val, i32 %sym) local_unnamed_addr {
entry:
  %row_ge = icmp sge i32 %row, 0
  %col_ge = icmp sge i32 %col, 0
  %both_ge = and i1 %row_ge, %col_ge
  br i1 %both_ge, label %do, label %ret

do:
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %row_off_bytes = mul nsw i64 %row64, 400
  %row_base_i8 = getelementptr inbounds i8, i8* %base, i64 %row_off_bytes
  %row_base_i32 = bitcast i8* %row_base_i8 to i32*
  %cellptr = getelementptr inbounds i32, i32* %row_base_i32, i64 %col64
  store i32 %val, i32* %cellptr
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %ret, label %sym_store

sym_store:
  %col_off_bytes = mul nsw i64 %col64, 400
  %col_base_i8 = getelementptr inbounds i8, i8* %base, i64 %col_off_bytes
  %col_base_i32 = bitcast i8* %col_base_i8 to i32*
  %cellptr_t = getelementptr inbounds i32, i32* %col_base_i32, i64 %row64
  store i32 %val, i32* %cellptr_t
  br label %ret

ret:
  ret void
}