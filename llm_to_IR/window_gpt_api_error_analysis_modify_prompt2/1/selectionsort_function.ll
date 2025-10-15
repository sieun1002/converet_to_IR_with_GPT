target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer_check

outer_body:
  %i_val1 = load i32, i32* %i, align 4
  store i32 %i_val1, i32* %min, align 4
  %i_plus1 = add i32 %i_val1, 1
  store i32 %i_plus1, i32* %j, align 4
  br label %inner_check

inner_body:
  %j_val = load i32, i32* %j, align 4
  %j_ext = sext i32 %j_val to i64
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_ext
  %arrj = load i32, i32* %j_ptr, align 4
  %min_idx = load i32, i32* %min, align 4
  %min_ext = sext i32 %min_idx to i64
  %min_ptr = getelementptr inbounds i32, i32* %arr, i64 %min_ext
  %arrmin = load i32, i32* %min_ptr, align 4
  %cmp = icmp sge i32 %arrj, %arrmin
  br i1 %cmp, label %inner_incr, label %update_min

update_min:
  %j_val2 = load i32, i32* %j, align 4
  store i32 %j_val2, i32* %min, align 4
  br label %inner_incr

inner_incr:
  %j_val3 = load i32, i32* %j, align 4
  %j_plus1 = add i32 %j_val3, 1
  store i32 %j_plus1, i32* %j, align 4
  br label %inner_check

inner_check:
  %j_cur = load i32, i32* %j, align 4
  %cmp_j_n = icmp slt i32 %j_cur, %n
  br i1 %cmp_j_n, label %inner_body, label %after_inner

after_inner:
  %i_val2 = load i32, i32* %i, align 4
  %i_ext2 = sext i32 %i_val2 to i64
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_ext2
  %i_elem = load i32, i32* %i_ptr, align 4
  store i32 %i_elem, i32* %tmp, align 4
  %min_idx2 = load i32, i32* %min, align 4
  %min_ext2 = sext i32 %min_idx2 to i64
  %min_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min_ext2
  %arrmin2 = load i32, i32* %min_ptr2, align 4
  store i32 %arrmin2, i32* %i_ptr, align 4
  %tmp_val = load i32, i32* %tmp, align 4
  store i32 %tmp_val, i32* %min_ptr2, align 4
  %i_val3 = load i32, i32* %i, align 4
  %i_plus1b = add i32 %i_val3, 1
  store i32 %i_plus1b, i32* %i, align 4
  br label %outer_check

outer_check:
  %n_sub1 = sub i32 %n, 1
  %i_cur = load i32, i32* %i, align 4
  %cmp_outer = icmp slt i32 %i_cur, %n_sub1
  br i1 %cmp_outer, label %outer_body, label %ret

ret:
  ret void
}