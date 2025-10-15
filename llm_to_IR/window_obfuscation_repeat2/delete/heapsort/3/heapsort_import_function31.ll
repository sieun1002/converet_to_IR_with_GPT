; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"

@unk_140004000 = external global i8
@unk_140004009 = external global i8
@unk_14000400D = external global i8

declare void @sub_1400018F0()
declare void @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)
declare void @sub_140002960(i8*, ...)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %j = alloca i64, align 8

  call void @sub_1400018F0()

  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4

  store i64 9, i64* %n, align 8

  call void (i8*, ...) @sub_140002960(i8* @unk_140004000)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.val, %n.val
  br i1 %cmp, label %loop1.body, label %after1

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  call void (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

after1:                                           ; preds = %loop1.cond
  call void @sub_140002AF0(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val2 = load i64, i64* %n, align 8
  call void @sub_140001450(i32* %arr.base, i64 %n.val2)

  call void (i8*, ...) @sub_140002960(i8* @unk_14000400D)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %after1
  %j.val = load i64, i64* %j, align 8
  %n.val3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.val, %n.val3
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                      ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  call void (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

after2:                                           ; preds = %loop2.cond
  call void @sub_140002AF0(i32 10)
  ret i32 0
}