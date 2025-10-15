; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i32 @printf(i8*, ...)
declare i32 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %keycount = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i32, align 4

  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8ptr, align 4

  store i64 9, i64* %n, align 8

  %keys0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0ptr, align 4
  %keys1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1ptr, align 4
  %keys2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2ptr, align 4

  store i64 3, i64* %keycount, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_val = load i64, i64* %i, align 8
  %kc = load i64, i64* %keycount, align 8
  %cond = icmp ult i64 %i_val, %kc
  br i1 %cond, label %body, label %done

body:
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i_val
  %key = load i32, i32* %keyptr, align 4
  %arrbase = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %bsret = call i32 @binary_search(i32* %arrbase, i64 %nval, i32 %key)
  store i32 %bsret, i32* %idx, align 4
  %idx_loaded = load i32, i32* %idx, align 4
  %isneg = icmp slt i32 %idx_loaded, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %idx_print = load i32, i32* %idx, align 4
  %pf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i32 %idx_print)
  br label %inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %pf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %iv0 = load i64, i64* %i, align 8
  %iv1 = add i64 %iv0, 1
  store i64 %iv1, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}