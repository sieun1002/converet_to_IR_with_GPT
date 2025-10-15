; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = internal constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %kcount = alloca i64, align 8
  %i = alloca i64, align 8
  %res = alloca i32, align 4

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

  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %kcount, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:
  %i_val = load i64, i64* %i, align 8
  %kcount_val = load i64, i64* %kcount, align 8
  %cmp = icmp ult i64 %i_val, %kcount_val
  br i1 %cmp, label %body, label %exit

body:
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i_val
  %key = load i32, i32* %keyptr, align 4
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n_val = load i64, i64* %n, align 8
  %call = call i32 @binary_search(i32* %arrdecay, i64 %n_val, i32 %key)
  store i32 %call, i32* %res, align 4
  %resval = load i32, i32* %res, align 4
  %isneg = icmp slt i32 %resval, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %resval2 = load i32, i32* %res, align 4
  %print_ok = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %key, i32 %resval2)
  br label %inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %print_nf = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %iold = load i64, i64* %i, align 8
  %inext = add i64 %iold, 1
  store i64 %inext, i64* %i, align 8
  br label %loop

exit:
  ret i32 0
}