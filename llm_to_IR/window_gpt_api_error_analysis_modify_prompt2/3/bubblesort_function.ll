; ModuleID = 'bubble_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %var8 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %tmp32 = alloca i32, align 4
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %exit, label %init

init:
  store i64 %n, i64* %var8, align 8
  br label %outer_check

outer_check:
  %v8_cur = load i64, i64* %var8, align 8
  %cmp_outer = icmp ugt i64 %v8_cur, 1
  br i1 %cmp_outer, label %outer_body, label %exit

outer_body:
  store i64 0, i64* %var10, align 8
  store i64 1, i64* %var18, align 8
  br label %inner_check

inner_check:
  %i_val = load i64, i64* %var18, align 8
  %v8_loop = load i64, i64* %var8, align 8
  %cmp_inner = icmp ult i64 %i_val, %v8_loop
  br i1 %cmp_inner, label %inner_body, label %after_inner

inner_body:
  %im1 = sub i64 %i_val, 1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %val_im1 = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i_val
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp_swap = icmp sgt i32 %val_im1, %val_i
  br i1 %cmp_swap, label %do_swap, label %after_cmp

do_swap:
  store i32 %val_im1, i32* %tmp32, align 4
  store i32 %val_i, i32* %ptr_im1, align 4
  %t = load i32, i32* %tmp32, align 4
  store i32 %t, i32* %ptr_i, align 4
  store i64 %i_val, i64* %var10, align 8
  br label %after_cmp

after_cmp:
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %var18, align 8
  br label %inner_check

after_inner:
  %lastSwap = load i64, i64* %var10, align 8
  %is_zero = icmp eq i64 %lastSwap, 0
  br i1 %is_zero, label %exit, label %update_outer

update_outer:
  store i64 %lastSwap, i64* %var8, align 8
  br label %outer_check

exit:
  ret void
}