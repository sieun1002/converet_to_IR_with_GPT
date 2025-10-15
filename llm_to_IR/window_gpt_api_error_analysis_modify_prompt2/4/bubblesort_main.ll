; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @bubble_sort(i32* noundef, i64 noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %len, align 8

  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len, align 8
  call void @bubble_sort(i32* noundef %arrptr, i64 noundef %lenval)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %iv = load i64, i64* %i, align 8
  %lv = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %lv
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %iv2 = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv2
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @Format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 %elem)
  %iv3 = add i64 %iv2, 1
  store i64 %iv3, i64* %i, align 8
  br label %loop.cond

after:
  %pc = call i32 @putchar(i32 noundef 10)
  ret i32 0
}