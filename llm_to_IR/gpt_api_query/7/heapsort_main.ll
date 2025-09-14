; ModuleID = 'recovered_main.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@format = private unnamed_addr constant [17 x i8] c"Before Sorting:\0A\00", align 1
@byte_2011 = private unnamed_addr constant [16 x i8] c"After Sorting:\0A\00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i1 = alloca i64, align 8
  %i2 = alloca i64, align 8

  ; initialize array: [7,3,9,1,4,8,2,6,5]
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %arr4, align 16
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %arr6, align 8
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %arr8, align 16

  store i64 9, i64* %len, align 8

  ; printf("Before Sorting:\n")
  %fmtptr = getelementptr inbounds [17 x i8], [17 x i8]* @format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmtptr)

  ; for (i=0; i<len; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i1, align 8
  br label %loop1

loop1:
  %idx1 = load i64, i64* %i1, align 8
  %n1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %idx1, %n1
  br i1 %cmp1, label %body1, label %after1

body1:
  %elem.ptr1 = getelementptr inbounds i32, i32* %arr0, i64 %idx1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %dptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %dptr, i32 %val1)
  %inc1 = add i64 %idx1, 1
  store i64 %inc1, i64* %i1, align 8
  br label %loop1

after1:
  %newline = call i32 @putchar(i32 10)

  ; heap_sort(arr, len)
  %ncall = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr0, i64 %ncall)

  ; printf("After Sorting:\n")
  %fmt2ptr = getelementptr inbounds [16 x i8], [16 x i8]* @byte_2011, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2ptr)

  ; for (i=0; i<len; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i2, align 8
  br label %loop2

loop2:
  %idx2 = load i64, i64* %i2, align 8
  %n2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %idx2, %n2
  br i1 %cmp2, label %body2, label %after2

body2:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr0, i64 %idx2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %dptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %dptr2, i32 %val2)
  %inc2 = add i64 %idx2, 1
  store i64 %inc2, i64* %i2, align 8
  br label %loop2

after2:
  %newline2 = call i32 @putchar(i32 10)
  ret i32 0
}