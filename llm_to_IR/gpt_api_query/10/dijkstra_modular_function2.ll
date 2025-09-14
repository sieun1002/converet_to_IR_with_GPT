; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

; add_edge(void* base, int i, int j, int val, int sym)
; Stride per row is 0x190 bytes = 100 i32 elements
define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %i_neg = icmp slt i32 %i, 0
  br i1 %i_neg, label %ret, label %check_j

check_j:
  %j_neg = icmp slt i32 %j, 0
  br i1 %j_neg, label %ret, label %store_main

store_main:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %rowOff = mul i64 %i64, 100
  %idx = add i64 %rowOff, %j64
  %ptr = getelementptr i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %ret, label %store_sym

store_sym:
  %j64b = sext i32 %j to i64
  %rowOff2 = mul i64 %j64b, 100
  %i64b = sext i32 %i to i64
  %idx2 = add i64 %rowOff2, %i64b
  %ptr2 = getelementptr i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2
  br label %ret

ret:
  ret void
}