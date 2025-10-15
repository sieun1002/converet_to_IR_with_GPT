; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %len = alloca i64, align 8
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  store i64 10, i64* %len, align 8
  %lenload = load i64, i64* %len, align 8
  %cmp = icmp ule i64 %lenload, 1
  br i1 %cmp, label %afterSort, label %doSort

doSort:
  %lenminus1 = sub i64 %lenload, 1
  %high32 = trunc i64 %lenminus1 to i32
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrptr, i32 0, i32 %high32)
  br label %afterSort

afterSort:
  store i64 0, i64* %i, align 8
  br label %loopTest

loopTest:
  %iv = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %lt = icmp ult i64 %iv, %lenv2
  br i1 %lt, label %loopBody, label %afterLoop

loopBody:
  %elemPtr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elemPtr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %nexti = add i64 %iv, 1
  store i64 %nexti, i64* %i, align 8
  br label %loopTest

afterLoop:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}