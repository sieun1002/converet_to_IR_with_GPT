; ModuleID = 'heapsort_demo'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_14000400D = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
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
  store i64 9, i64* %len, align 8
  %fmtptr = getelementptr inbounds [17 x i8], [17 x i8]* @_Format, i64 0, i64 0
  %call0 = call i32 @printf(i8* %fmtptr)
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %iv = load i64, i64* %i, align 8
  %lv = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %lv
  br i1 %cmp, label %body1, label %after1

body1:
  %ep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %ep, align 4
  %fmt_d_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call1 = call i32 @printf(i8* %fmt_d_ptr, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:
  %call2 = call i32 @putchar(i32 10)
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %lenv = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arrptr, i64 %lenv)
  %fmt2ptr = getelementptr inbounds [15 x i8], [15 x i8]* @byte_14000400D, i64 0, i64 0
  %call3 = call i32 @printf(i8* %fmt2ptr)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %jv = load i64, i64* %j, align 8
  %lv2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %jv, %lv2
  br i1 %cmp2, label %body2, label %after2

body2:
  %ep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %jv
  %val2 = load i32, i32* %ep2, align 4
  %fmt_d_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call4 = call i32 @printf(i8* %fmt_d_ptr2, i32 %val2)
  %inc2 = add i64 %jv, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:
  %call5 = call i32 @putchar(i32 10)
  ret i32 0
}