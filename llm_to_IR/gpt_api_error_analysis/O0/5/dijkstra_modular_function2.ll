define void @add_edge(i8* %base, i32 %row, i32 %col, i32 %val, i32 %flag) {
entry:
  %1 = icmp slt i32 %row, 0
  %2 = icmp slt i32 %col, 0
  %3 = or i1 %1, %2
  br i1 %3, label %ret, label %store_forward

store_forward:
  %4 = sext i32 %row to i64
  %5 = mul nsw i64 %4, 400
  %6 = getelementptr i8, i8* %base, i64 %5
  %7 = sext i32 %col to i64
  %8 = shl i64 %7, 2
  %9 = getelementptr i8, i8* %6, i64 %8
  %10 = bitcast i8* %9 to i32*
  store i32 %val, i32* %10, align 4
  %11 = icmp eq i32 %flag, 0
  br i1 %11, label %ret, label %store_sym

store_sym:
  %12 = sext i32 %col to i64
  %13 = mul nsw i64 %12, 400
  %14 = getelementptr i8, i8* %base, i64 %13
  %15 = sext i32 %row to i64
  %16 = shl i64 %15, 2
  %17 = getelementptr i8, i8* %14, i64 %16
  %18 = bitcast i8* %17 to i32*
  store i32 %val, i32* %18, align 4
  br label %ret

ret:
  ret void
}