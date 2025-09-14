; ModuleID = 'bin2ir'
source_filename = "bin2ir"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  ; call insertion_sort(arr, 10)
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %arrptr, i64 10)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %cond = icmp ult i64 %iv, 10
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  call i32 @putchar(i32 10)
  ret i32 0
}