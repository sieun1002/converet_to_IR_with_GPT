; ModuleID: 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@unk_140004000 = dso_local constant [17 x i8] c"Original array:\0A\00", align 1
@unk_140004009 = dso_local constant [4 x i8] c"%d \00", align 1
@unk_14000400D = dso_local constant [9 x i8] c"\0AAfter:\0A\00", align 1

declare dso_local void @sub_1400018F0()
declare dso_local i32 @sub_140002960(i8*, ...)
declare dso_local void @sub_140002AF0(i32)
declare dso_local void @sub_140001450(i32*, i64)

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @sub_1400018F0()
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
  store i64 9, i64* %len, align 8
  %fmt0.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @unk_140004000, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* %fmt0.ptr)
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %body1, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.val
  br i1 %cmp, label %body1, label %after1

body1:                                            ; preds = %loop1
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt1.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt1.ptr, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  call void @sub_140002AF0(i32 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @sub_140001450(i32* %arr.base, i64 %len2)
  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @unk_14000400D, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt2.ptr)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %body2, %after1
  %j.cur = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.cur, %len3
  br i1 %cmp2, label %body2, label %after2

body2:                                            ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt3.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* %fmt3.ptr, i32 %elem2)
  %inc2 = add i64 %j.cur, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  call void @sub_140002AF0(i32 10)
  ret i32 0
}