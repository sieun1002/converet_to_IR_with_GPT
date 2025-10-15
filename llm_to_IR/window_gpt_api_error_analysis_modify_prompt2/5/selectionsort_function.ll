target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arg_0, i32 %arg_8) {
entry:
  %i = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:
  %i.val = load i32, i32* %i, align 4
  %n_minus1 = add i32 %arg_8, -1
  %cmp_outer = icmp slt i32 %i.val, %n_minus1
  br i1 %cmp_outer, label %outer.body, label %outer.end

outer.body:
  %i.val2 = load i32, i32* %i, align 4
  store i32 %i.val2, i32* %min, align 4
  %i.plus1 = add i32 %i.val2, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %inner.cond

inner.cond:
  %j.val = load i32, i32* %j, align 4
  %cmp_inner = icmp slt i32 %j.val, %arg_8
  br i1 %cmp_inner, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j.val to i64
  %gep_j = getelementptr inbounds i32, i32* %arg_0, i64 %j64
  %val_j = load i32, i32* %gep_j, align 4
  %min.val = load i32, i32* %min, align 4
  %min64 = sext i32 %min.val to i64
  %gep_min = getelementptr inbounds i32, i32* %arg_0, i64 %min64
  %val_min = load i32, i32* %gep_min, align 4
  %cmp_lt = icmp slt i32 %val_j, %val_min
  br i1 %cmp_lt, label %update_min, label %skip_update

update_min:
  %j.val2 = load i32, i32* %j, align 4
  store i32 %j.val2, i32* %min, align 4
  br label %skip_update

skip_update:
  %j.val3 = load i32, i32* %j, align 4
  %j.plus1 = add i32 %j.val3, 1
  store i32 %j.plus1, i32* %j, align 4
  br label %inner.cond

after.inner:
  %i.val3 = load i32, i32* %i, align 4
  %i64 = sext i32 %i.val3 to i64
  %gep_i = getelementptr inbounds i32, i32* %arg_0, i64 %i64
  %arr_i = load i32, i32* %gep_i, align 4
  store i32 %arr_i, i32* %tmp, align 4
  %min.val2 = load i32, i32* %min, align 4
  %min64b = sext i32 %min.val2 to i64
  %gep_min2 = getelementptr inbounds i32, i32* %arg_0, i64 %min64b
  %arr_min = load i32, i32* %gep_min2, align 4
  store i32 %arr_min, i32* %gep_i, align 4
  %temp.val = load i32, i32* %tmp, align 4
  store i32 %temp.val, i32* %gep_min2, align 4
  %i.val4 = load i32, i32* %i, align 4
  %i.plus1b = add i32 %i.val4, 1
  store i32 %i.plus1b, i32* %i, align 4
  br label %outer.cond

outer.end:
  ret void
}