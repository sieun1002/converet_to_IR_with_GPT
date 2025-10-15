; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [7 x i8] c"Before\00"
@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@byte_14000400D = private unnamed_addr constant [6 x i8] c"After\00"

declare void @sub_1400018F0()
declare i32 @putchar(i32)
declare void @sub_140001450(i32*, i64)
declare i32 @sub_140002960(i8*, ...)

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %idx0 = alloca i64, align 8
  %idx1 = alloca i64, align 8

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

  store i64 9, i64* %len, align 8

  %fmt0 = getelementptr inbounds [7 x i8], [7 x i8]* @Format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* %fmt0)

  store i64 0, i64* %idx0, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i1 = load i64, i64* %idx0, align 8
  %n1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i1, %n1
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmt_d1 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d1, i32 %val1)
  %inc1 = add i64 %i1, 1
  store i64 %inc1, i64* %idx0, align 8
  br label %loop1.cond

after1:                                            ; preds = %loop1.cond
  %pc1 = call i32 @putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %len, align 8
  call void @sub_140001450(i32* %arr.base, i64 %n2)

  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @byte_14000400D, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt1)

  store i64 0, i64* %idx1, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after1
  %i2 = load i64, i64* %idx1, align 8
  %n3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %i2, %n3
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                       ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d2, i32 %val2)
  %inc2 = add i64 %i2, 1
  store i64 %inc2, i64* %idx1, align 8
  br label %loop2.cond

after2:                                            ; preds = %loop2.cond
  %pc2 = call i32 @putchar(i32 10)
  ret i32 0
}