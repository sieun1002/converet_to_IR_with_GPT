; ModuleID = 'recovered'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

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
  %bound = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @sub_1400018F0()
  store i32 7, i32* %arrptr, align 4
  %idx1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arrptr, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arrptr, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arrptr, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arrptr, i64 8
  store i32 5, i32* %idx8, align 4
  store i64 9, i64* %bound, align 8
  call void (i8*, ...) @sub_140002960(i8* @unk_140004000)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.val1 = load i64, i64* %i, align 8
  %bound.val1 = load i64, i64* %bound, align 8
  %cmp1 = icmp ult i64 %i.val1, %bound.val1
  br i1 %cmp1, label %loop1.body, label %after.loop1

loop1.body:                                       ; preds = %loop1.cond
  %gep.elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %i.val1
  %elem = load i32, i32* %gep.elem.ptr, align 4
  call void (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem)
  %i.next = add i64 %i.val1, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

after.loop1:                                      ; preds = %loop1.cond
  call void @sub_140002AF0(i32 10)
  %bound.val2 = load i64, i64* %bound, align 8
  call void @sub_140001450(i32* %arrptr, i64 %bound.val2)
  call void (i8*, ...) @sub_140002960(i8* @unk_14000400D)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after.loop1
  %j.val = load i64, i64* %j, align 8
  %bound.val3 = load i64, i64* %bound, align 8
  %cmp2 = icmp ult i64 %j.val, %bound.val3
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:                                       ; preds = %loop2.cond
  %gep2 = getelementptr inbounds i32, i32* %arrptr, i64 %j.val
  %elem2 = load i32, i32* %gep2, align 4
  call void (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

after.loop2:                                      ; preds = %loop2.cond
  call void @sub_140002AF0(i32 10)
  ret i32 0
}