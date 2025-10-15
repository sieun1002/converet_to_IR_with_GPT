; ModuleID: 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"

@Format = constant [1 x i8] c"\00"
@aD = constant [4 x i8] c"%d \00"
@byte_14000400D = constant [1 x i8] c"\00"

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140001450(i32*, i64)
declare i32 @putchar(i32)

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()

  %arr = alloca [9 x i32], align 4
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8.ptr, align 4

  store i64 9, i64* %count, align 8

  %fmt.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @Format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* %fmt.ptr)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %cnt1 = load i64, i64* %count, align 8
  %cmp1 = icmp ult i64 %i.val, %cnt1
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %aD.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %aD.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

after1:                                           ; preds = %loop1.cond
  %pc1 = call i32 @putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %cnt2 = load i64, i64* %count, align 8
  call void @sub_140001450(i32* %arr.base, i64 %cnt2)

  %hdr2.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @byte_14000400D, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* %hdr2.ptr)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %after1
  %j.val = load i64, i64* %j, align 8
  %cnt3 = load i64, i64* %count, align 8
  %cmp2 = icmp ult i64 %j.val, %cnt3
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                      ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %aD2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* %aD2.ptr, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

after2:                                           ; preds = %loop2.cond
  %pc2 = call i32 @putchar(i32 10)
  ret i32 0
}