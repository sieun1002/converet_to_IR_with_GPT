; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@Format = private unnamed_addr constant [9 x i8] c"Before:\0A\00", align 1
@byte_14000400D = private unnamed_addr constant [8 x i8] c"After:\0A\00", align 1

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare i32 @putchar(i32)
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %n = alloca i64, align 8
  ; initialize array elements
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
  store i64 9, i64* %n, align 8
  ; print first header
  %fmt0 = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* %fmt0)
  ; first loop
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %body1, %entry
  %iv = load i64, i64* %i, align 8
  %nval = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %iv, %nval
  br i1 %cmp, label %body1, label %after1

body1:                                            ; preds = %loop1
  %iv2 = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %iv2
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d, i32 %elem)
  %inc = add i64 %iv2, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  %putc1 = call i32 @putchar(i32 10)
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nload = load i64, i64* %n, align 8
  call void @sub_140001450(i32* %arrptr, i64 %nload)
  ; print second header
  %fmt1 = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt1)
  ; second loop
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %body2, %after1
  %jv = load i64, i64* %j, align 8
  %nval2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %jv, %nval2
  br i1 %cmp2, label %body2, label %after2

body2:                                            ; preds = %loop2
  %jv2 = load i64, i64* %j, align 8
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %jv2
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d2, i32 %elem2)
  %inc2 = add i64 %jv2, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  %putc2 = call i32 @putchar(i32 10)
  ret i32 0
}