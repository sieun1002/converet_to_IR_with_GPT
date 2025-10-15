; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = internal unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i32 @binary_search(i32* %arr, i64 %n, i32 %key)
declare i32 @printf(i8* %fmt, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %len = alloca i64, align 8
  %numKeys = alloca i64, align 8
  %i = alloca i64, align 8
  %res = alloca i32, align 4

  ; arr initialization: -5, -1, 0, 2, 2, 3, 7, 9, 12
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

  ; keys initialization: 2, 5, -5
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 9, i64* %len, align 8
  store i64 3, i64* %numKeys, align 8
  store i64 0, i64* %i, align 8

  br label %cond

cond:
  %i_val = load i64, i64* %i, align 8
  %nk_val = load i64, i64* %numKeys, align 8
  %cmp = icmp ult i64 %i_val, %nk_val
  br i1 %cmp, label %body, label %exit

body:
  %keys_base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i_val
  %key = load i32, i32* %keys_base, align 4

  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len_val = load i64, i64* %len, align 8

  %bs_ret = call i32 @binary_search(i32* %arr_base, i64 %len_val, i32 %key)
  store i32 %bs_ret, i32* %res, align 4

  %res_val = load i32, i32* %res, align 4
  %neg = icmp slt i32 %res_val, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmtp = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %res_val_found = load i32, i32* %res, align 4
  %call_printf_found = call i32 (i8*, ...) @printf(i8* %fmtp, i32 %key, i32 %res_val_found)
  br label %inc

notfound:
  %fmtp_nf = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call_printf_nf = call i32 (i8*, ...) @printf(i8* %fmtp_nf, i32 %key)
  br label %inc

inc:
  %i_old = load i64, i64* %i, align 8
  %i_next = add i64 %i_old, 1
  store i64 %i_next, i64* %i, align 8
  br label %cond

exit:
  ret i32 0
}