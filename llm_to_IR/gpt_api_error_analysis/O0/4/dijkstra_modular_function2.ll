; ModuleID = 'add_edge_module'
define void @add_edge(i8* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i = icmp slt i32 %i, 0
  br i1 %cmp_i, label %end, label %check_j

check_j:
  %cmp_j = icmp sge i32 %j, 0
  br i1 %cmp_j, label %store, label %end

store:
  %i64_i = sext i32 %i to i64
  %row_bytes = mul i64 %i64_i, 400
  %row_ptr_i8 = getelementptr i8, i8* %base, i64 %row_bytes
  %row_ptr_i32 = bitcast i8* %row_ptr_i8 to i32*
  %i64_j = sext i32 %j to i64
  %elem_ptr = getelementptr i32, i32* %row_ptr_i32, i64 %i64_j
  store i32 %val, i32* %elem_ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %end, label %sym_store

sym_store:
  %i64_j2 = sext i32 %j to i64
  %row_bytes2 = mul i64 %i64_j2, 400
  %row2_i8 = getelementptr i8, i8* %base, i64 %row_bytes2
  %row2_i32 = bitcast i8* %row2_i8 to i32*
  %i64_i2 = sext i32 %i to i64
  %elem2 = getelementptr i32, i32* %row2_i32, i64 %i64_i2
  store i32 %val, i32* %elem2, align 4
  br label %end

end:
  ret void
}