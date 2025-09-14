; ModuleID = 'binary.ll'
source_filename = "binary"
target triple = "x86_64-pc-linux-gnu"

@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@format = private unnamed_addr constant [16 x i8] c"Before sorting:\00", align 1
@byte_2011 = private unnamed_addr constant [15 x i8] c"After sorting:\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

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

  %fmtptr = getelementptr inbounds ([16 x i8], [16 x i8]* @format, i64 0, i64 0
  )
  %call0 = call i32 (i8*, ...) @printf(i8* %fmtptr)

  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %i1 = load i64, i64* %i, align 8
  %n1 = load i64, i64* %n, align 8
  %cmp1 = icmp ult i64 %i1, %n1
  br i1 %cmp1, label %body1, label %after1

body1:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmtint = getelementptr inbounds ([4 x i8], [4 x i8]* @aD, i64 0, i64 0)
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtint, i32 %elem1)
  %inc1 = add i64 %i1, 1
  store i64 %inc1, i64* %i, align 8
  br label %loop1

after1:
  %pcall1 = call i32 @putchar(i32 10)

  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arrdecay, i64 %n2)

  %fmt2 = getelementptr inbounds ([15 x i8], [15 x i8]* @byte_2011, i64 0, i64 0)
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %j1 = load i64, i64* %j, align 8
  %n3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j1, %n3
  br i1 %cmp2, label %body2, label %after2

body2:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j1
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtint, i32 %elem2)
  %inc2 = add i64 %j1, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:
  %pcall2 = call i32 @putchar(i32 10)
  ret i32 0
}