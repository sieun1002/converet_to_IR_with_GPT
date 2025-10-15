; ModuleID = 'sub_14000171D.ll'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [9 x i8] c"Before: \00"
@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@byte_14000400D = private unnamed_addr constant [8 x i8] c"After: \00"

declare void @sub_1400018F0() local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare i32 @sub_140002960(i8*, ...) local_unnamed_addr
declare void @sub_140001450(i32*, i64) local_unnamed_addr

define i32 @sub_14000171D() local_unnamed_addr {
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

  %fmt_before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %call.banner1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_before.ptr)

  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i.val, %len.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_num.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.num1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_num.ptr, i32 %elem)
  %i.next = add nuw nsw i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1

loop1.end:
  %putc1 = call i32 @putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.val2 = load i64, i64* %len, align 8
  call void @sub_140001450(i32* %arr.base, i64 %len.val2)

  %fmt_after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call.banner2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_after.ptr)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %j.val = load i64, i64* %j, align 8
  %len.val3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len.val3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt_num.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.num2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_num.ptr2, i32 %elem2)
  %j.next = add nuw nsw i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2

loop2.end:
  %putc2 = call i32 @putchar(i32 10)
  ret i32 0
}