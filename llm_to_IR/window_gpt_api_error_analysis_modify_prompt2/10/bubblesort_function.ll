; ModuleID = 'bubble_sort'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %len) {
entry:
  %var_8 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_1C = alloca i32, align 4
  %cmp_init = icmp ule i64 %len, 1
  br i1 %cmp_init, label %end, label %setup

setup:
  store i64 %len, i64* %var_8, align 8
  br label %outer_check

outer_check:
  %var8_val = load i64, i64* %var_8, align 8
  %cmp_outer = icmp ugt i64 %var8_val, 1
  br i1 %cmp_outer, label %outer_body, label %end

outer_body:
  store i64 0, i64* %var_10, align 8
  store i64 1, i64* %var_18, align 8
  br label %inner_cmp

inner_cmp:
  %j = load i64, i64* %var_18, align 8
  %limit = load i64, i64* %var_8, align 8
  %cmp_inner = icmp ult i64 %j, %limit
  br i1 %cmp_inner, label %inner_body, label %after_inner

inner_body:
  %j_minus1 = add i64 %j, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %j_minus1
  %prev_val = load i32, i32* %ptr_prev, align 4
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_vals = icmp sgt i32 %prev_val, %val_j
  br i1 %cmp_vals, label %do_swap, label %no_swap

do_swap:
  store i32 %prev_val, i32* %var_1C, align 4
  store i32 %val_j, i32* %ptr_prev, align 4
  %tmp_prev = load i32, i32* %var_1C, align 4
  store i32 %tmp_prev, i32* %ptr_j, align 4
  store i64 %j, i64* %var_10, align 8
  br label %inc_j

no_swap:
  br label %inc_j

inc_j:
  %j_next = add i64 %j, 1
  store i64 %j_next, i64* %var_18, align 8
  br label %inner_cmp

after_inner:
  %last_swap = load i64, i64* %var_10, align 8
  %cmp_zero = icmp eq i64 %last_swap, 0
  br i1 %cmp_zero, label %end, label %set_limit

set_limit:
  store i64 %last_swap, i64* %var_8, align 8
  br label %outer_check

end:
  ret void
}