; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @binary_search(i32* noundef, i64 noundef, i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %num = alloca i64, align 8
  %ret = alloca i32, align 4
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
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4
  store i64 9, i64* %len, align 8
  store i64 3, i64* %num, align 8
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %incr, %entry
  %i.val = load i64, i64* %i, align 8
  %num.val = load i64, i64* %num, align 8
  %cmp = icmp ult i64 %i.val, %num.val
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %idx = load i64, i64* %i, align 8
  %kptr0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %idx
  %key = load i32, i32* %kptr0, align 4
  %arrbase = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %lenv = load i64, i64* %len, align 8
  %retcall = call i32 @binary_search(i32* noundef %arrbase, i64 noundef %lenv, i32 noundef %key)
  store i32 %retcall, i32* %ret, align 4
  %retv = load i32, i32* %ret, align 4
  %isneg = icmp slt i32 %retv, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %idx2 = load i64, i64* %i, align 8
  %kptr1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %idx2
  %key2 = load i32, i32* %kptr1, align 4
  %retv2 = load i32, i32* %ret, align 4
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %key2, i32 noundef %retv2)
  br label %incr

notfound:                                         ; preds = %loop.body
  %idx3 = load i64, i64* %i, align 8
  %kptr2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %idx3
  %key3 = load i32, i32* %kptr2, align 4
  %fmt2ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2ptr, i32 noundef %key3)
  br label %incr

incr:                                             ; preds = %notfound, %found
  %oldi = load i64, i64* %i, align 8
  %addi = add i64 %oldi, 1
  store i64 %addi, i64* %i, align 8
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret i32 0
}