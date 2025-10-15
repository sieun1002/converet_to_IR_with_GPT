; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@unk_140004000 = unnamed_addr constant [9 x i8] c"Before:\0A\00", align 1
@unk_140004009 = unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_14000400D = unnamed_addr constant [8 x i8] c"After:\0A\00", align 1

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %bound = alloca i64, align 8
  call void @sub_1400018F0()
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4
  store i64 9, i64* %bound, align 8
  %fmt0 = getelementptr inbounds [9 x i8], [9 x i8]* @unk_140004000, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt0)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %bound.val = load i64, i64* %bound, align 8
  %cmp = icmp ult i64 %i.val, %bound.val
  br i1 %cmp, label %loop1.body, label %after.loop1

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt1, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

after.loop1:                                      ; preds = %loop1.cond
  call void @sub_140002AF0(i32 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %bound2 = load i64, i64* %bound, align 8
  call void @sub_140001450(i32* %arr.base, i64 %bound2)
  %fmt2 = getelementptr inbounds [8 x i8], [8 x i8]* @unk_14000400D, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* %fmt2)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after.loop1
  %j.val = load i64, i64* %j, align 8
  %bound3 = load i64, i64* %bound, align 8
  %cmp2 = icmp ult i64 %j.val, %bound3
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:                                       ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt3 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call4 = call i32 (i8*, ...) @sub_140002960(i8* %fmt3, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

after.loop2:                                      ; preds = %loop2.cond
  call void @sub_140002AF0(i32 10)
  ret i32 0
}