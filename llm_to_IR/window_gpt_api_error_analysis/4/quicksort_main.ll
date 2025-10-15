; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local void @quick_sort(i32*, i32, i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
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
  store i64 10, i64* %n, align 8
  %nval = load i64, i64* %n, align 8
  %cmp = icmp ugt i64 %nval, 1
  br i1 %cmp, label %sort, label %after_sort

sort:
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high64 = add i64 %nval, -1
  %high32 = trunc i64 %high64 to i32
  call void @quick_sort(i32* %arrptr, i32 0, i32 %high32)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %icur = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %icur, %ncur
  br i1 %cond, label %body, label %done

body:
  %elem = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %icur
  %val = load i32, i32* %elem, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %inc = add i64 %icur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}