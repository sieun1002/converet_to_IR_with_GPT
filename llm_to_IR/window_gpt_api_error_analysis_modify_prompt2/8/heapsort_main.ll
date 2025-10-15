; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = dso_local constant [4 x i8] c"%d \00", align 1

declare dso_local void @heap_sort(i32*, i64)
declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
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
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arrptr, i64 %nval)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %ncur
  br i1 %cond, label %body, label %done

body:
  %ep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %ep, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}