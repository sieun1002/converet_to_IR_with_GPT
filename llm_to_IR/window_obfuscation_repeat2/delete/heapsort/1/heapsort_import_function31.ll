; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140004000 = external global i8
@unk_140004009 = external global i8
@unk_14000400D = external global i8

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %len = alloca i64, align 8

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

  store i64 9, i64* %len, align 8

  %call0 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004000)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i.val, %len.val
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

after1:                                            ; preds = %loop1.cond
  call void @sub_140002AF0(i32 10)

  %baseptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @sub_140001450(i32* %baseptr, i64 %len2)

  %call2 = call i32 (i8*, ...) @sub_140002960(i8* @unk_14000400D)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after1
  %j.val = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len3
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                       ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem2)
  %j.inc = add i64 %j.val, 1
  store i64 %j.inc, i64* %j, align 8
  br label %loop2.cond

after2:                                            ; preds = %loop2.cond
  call void @sub_140002AF0(i32 10)
  ret i32 0
}