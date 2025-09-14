target triple = "x86_64-pc-linux-gnu"

define void @add_edge([100 x i32]* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %cmp_i_neg = icmp slt i32 %i, 0
  %cmp_j_neg = icmp slt i32 %j, 0
  %any_neg = or i1 %cmp_i_neg, %cmp_j_neg
  br i1 %any_neg, label %ret, label %cont

cont:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr [100 x i32], [100 x i32]* %base, i64 %i64, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %sym_is_zero = icmp eq i32 %sym, 0
  br i1 %sym_is_zero, label %ret, label %sym_store

sym_store:
  %elem_ptr_sym = getelementptr [100 x i32], [100 x i32]* %base, i64 %j64, i64 %i64
  store i32 %val, i32* %elem_ptr_sym, align 4
  br label %ret

ret:
  ret void
}