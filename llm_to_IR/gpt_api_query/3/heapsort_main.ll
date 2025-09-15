; ModuleID = 'main.ll'
source_filename = "main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 9, i64* %n, align 8

  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %base, align 4
  %p1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 5, i32* %p8, align 4

  %beforeptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %beforeptr)

  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %iv = load i64, i64* %i, align 8
  %nval = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %iv, %nval
  br i1 %cmp, label %body1, label %after1

body1:
  %elem_ptr = getelementptr inbounds i32, i32* %base, i64 %iv
  %val = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:
  call i32 @putchar(i32 10)

  %nval2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %base, i64 %nval2)

  %afterptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %afterptr)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %jv = load i64, i64* %j, align 8
  %nval3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %jv, %nval3
  br i1 %cmp2, label %body2, label %after2

body2:
  %elem_ptr2 = getelementptr inbounds i32, i32* %base, i64 %jv
  %val2 = load i32, i32* %elem_ptr2, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val2)
  %inc2 = add i64 %jv, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:
  call i32 @putchar(i32 10)
  ret i32 0
}