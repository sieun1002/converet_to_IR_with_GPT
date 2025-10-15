; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

@unk_140004000 = external global i8
@unk_140004009 = external global i8
@unk_14000400D = external global i8

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @sub_1400018F0()
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1p, align 4
  %arr2p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2p, align 4
  %arr3p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3p, align 4
  %arr4p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4p, align 4
  %arr5p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5p, align 4
  %arr6p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6p, align 4
  %arr7p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7p, align 4
  %arr8p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8p, align 4
  store i64 9, i64* %count, align 8
  call i32 (i8*, ...) @sub_140002960(i8* @unk_140004000)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.cur = load i64, i64* %i, align 8
  %cnt = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i.cur, %cnt
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem)
  %next = add i64 %i.cur, 1
  store i64 %next, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  call void @sub_140002AF0(i32 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %cnt2 = load i64, i64* %count, align 8
  call void @sub_140001450(i32* %arr.base, i64 %cnt2)
  call i32 (i8*, ...) @sub_140002960(i8* @unk_14000400D)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:
  %j.cur = load i64, i64* %j, align 8
  %cnt3 = load i64, i64* %count, align 8
  %cmp2 = icmp ult i64 %j.cur, %cnt3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2 = load i32, i32* %elem2.ptr, align 4
  call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem2)
  %next2 = add i64 %j.cur, 1
  store i64 %next2, i64* %j, align 8
  br label %loop2.cond

loop2.end:
  call void @sub_140002AF0(i32 10)
  ret i32 0
}