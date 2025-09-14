; ModuleID = 'recovered.ll'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_2011 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %i1 = alloca i64, align 8
  %i2 = alloca i64, align 8
  %len = alloca i64, align 8

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

  store i64 9, i64* %len, align 8

  ; printf(format)
  %fmtptr = getelementptr inbounds [1 x i8], [1 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtptr)

  ; first print loop
  store i64 0, i64* %i1, align 8
  br label %loop1.cond

loop1.cond:
  %i1.val = load i64, i64* %i1, align 8
  %len.val1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i1.val, %len.val1
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1.val
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %elem1)
  %i1.next = add i64 %i1.val, 1
  store i64 %i1.next, i64* %i1, align 8
  br label %loop1.cond

loop1.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], len)
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.val2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.decay, i64 %len.val2)

  ; printf(byte_2011)
  %after.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %after.ptr)

  ; second print loop
  store i64 0, i64* %i2, align 8
  br label %loop2.cond

loop2.cond:
  %i2.val = load i64, i64* %i2, align 8
  %len.val3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %i2.val, %len.val3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt_num2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num2, i32 %elem2)
  %i2.next = add i64 %i2.val, 1
  store i64 %i2.next, i64* %i2, align 8
  br label %loop2.cond

loop2.end:
  call i32 @putchar(i32 10)
  ret i32 0
}