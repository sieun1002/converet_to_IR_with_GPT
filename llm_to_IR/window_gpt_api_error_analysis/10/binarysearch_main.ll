; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* noundef %arr, i64 noundef %len, i32 noundef %key) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  %mid = alloca i64, align 8
  %val = alloca i32, align 4
  store i64 0, i64* %low, align 8
  %len_minus1 = add i64 %len, -1
  store i64 %len_minus1, i64* %high, align 8
  br label %loop

loop:
  %low_cur = load i64, i64* %low, align 8
  %high_cur = load i64, i64* %high, align 8
  %cmp_cont = icmp sle i64 %low_cur, %high_cur
  br i1 %cmp_cont, label %inloop, label %notfound

inloop:
  %diff = sub i64 %high_cur, %low_cur
  %half = lshr i64 %diff, 1
  %mid_calc = add i64 %low_cur, %half
  store i64 %mid_calc, i64* %mid, align 8
  %idx = load i64, i64* %mid, align 8
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem_ptr, align 4
  store i32 %elem, i32* %val, align 4
  %cur = load i32, i32* %val, align 4
  %eq = icmp eq i32 %cur, %key
  br i1 %eq, label %found, label %noteq

noteq:
  %lt = icmp slt i32 %cur, %key
  br i1 %lt, label %move_low, label %move_high

move_low:
  %mid_v1 = load i64, i64* %mid, align 8
  %new_low = add i64 %mid_v1, 1
  store i64 %new_low, i64* %low, align 8
  br label %loop

move_high:
  %mid_v2 = load i64, i64* %mid, align 8
  %new_high = add i64 %mid_v2, -1
  store i64 %new_high, i64* %high, align 8
  br label %loop

found:
  %mid_v3 = load i64, i64* %mid, align 8
  %mid_i32 = trunc i64 %mid_v3 to i32
  ret i32 %mid_i32

notfound:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %len = alloca i64, align 8
  %nkeys = alloca i64, align 8
  %res = alloca i32, align 4

  ; Initialize array: {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4

  ; Initialize keys: {2, 5, -5}
  %key0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %key0, align 4
  %key1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %key1, align 4
  %key2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %key2, align 4

  store i64 9, i64* %len, align 8
  store i64 3, i64* %nkeys, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_cur = load i64, i64* %i, align 8
  %nkeys_cur = load i64, i64* %nkeys, align 8
  %cond = icmp ult i64 %i_cur, %nkeys_cur
  br i1 %cond, label %body, label %done

body:
  %keys_base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %key_ptr = getelementptr inbounds i32, i32* %keys_base, i64 %i_cur
  %key_val = load i32, i32* %key_ptr, align 4

  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len_val = load i64, i64* %len, align 8
  %call = call i32 @binary_search(i32* %arr_base, i64 %len_val, i32 %key_val)
  store i32 %call, i32* %res, align 4

  %res_val = load i32, i32* %res, align 4
  %found = icmp sge i32 %res_val, 0
  br i1 %found, label %print_found, label %print_notfound

print_found:
  %fmt_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %res_for_print = load i32, i32* %res, align 4
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %key_val, i32 %res_for_print)
  br label %incr

print_notfound:
  %fmt_ptr2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt_ptr2, i32 %key_val)
  br label %incr

incr:
  %i_next = add i64 %i_cur, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}