; ModuleID = 'recovered_from_binary'
source_filename = "recovered_from_binary"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9, align 4

  store i64 10, i64* %len, align 8

  %lenval = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr0, i64 %lenval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_cur = load i64, i64* %i, align 8
  %len_cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i_cur, %len_cur
  br i1 %cmp, label %body, label %after

body:
  %elem_ptr = getelementptr inbounds i32, i32* %arr0, i64 %i_cur
  %val = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %next = add i64 %i_cur, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}