; ModuleID = 'add_edge'
target triple = "x86_64-pc-linux-gnu"

define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i = icmp slt i32 %i, 0
  br i1 %cmp_i, label %exit, label %check_j

check_j:
  %cmp_j = icmp sge i32 %j, 0
  br i1 %cmp_j, label %store_main, label %exit

store_main:
  %base_i8 = bitcast i32* %base to i8*
  %i64 = sext i32 %i to i64
  %row_bytes = mul i64 %i64, 400
  %row_ptr_i8 = getelementptr inbounds i8, i8* %base_i8, i64 %row_bytes
  %row_ptr_i32 = bitcast i8* %row_ptr_i8 to i32*
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr_i32, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %sym_zero = icmp eq i32 %sym, 0
  br i1 %sym_zero, label %exit, label %store_sym

store_sym:
  %base_i8_2 = bitcast i32* %base to i8*
  %j64_2 = sext i32 %j to i64
  %row_bytes_2 = mul i64 %j64_2, 400
  %row_ptr_i8_2 = getelementptr inbounds i8, i8* %base_i8_2, i64 %row_bytes_2
  %row_ptr_i32_2 = bitcast i8* %row_ptr_i8_2 to i32*
  %i64_2 = sext i32 %i to i64
  %elem_ptr_2 = getelementptr inbounds i32, i32* %row_ptr_i32_2, i64 %i64_2
  store i32 %val, i32* %elem_ptr_2, align 4
  br label %exit

exit:
  ret void
}