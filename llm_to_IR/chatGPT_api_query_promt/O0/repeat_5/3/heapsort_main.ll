; LLVM 14 IR for function: main

target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_2011 = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32* noundef, i64 noundef)

define i32 @main() #0 {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %len = alloca i64, align 8

  ; len = 9
  store i64 9, i64* %len, align 8

  ; initialize arr = {7,3,9,1,4,8,2,6,5}
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

  ; printf(format)
  %fmt = getelementptr inbounds [9 x i8], [9 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop1.body, label %after1

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtD = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtD, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

after1:                                           ; preds = %loop1.cond
  call i32 @putchar(i32 10)

  ; heap_sort(arr, len)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.call = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.base, i64 %len.call)

  ; printf(byte_2011)
  %aft = getelementptr inbounds [8 x i8], [8 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %aft)

  ; j = 0
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %after1
  %j.val = load i64, i64* %j, align 8
  %len.val2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len.val2
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                      ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmtD2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtD2, i32 %elem2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2.cond

after2:                                           ; preds = %loop2.cond
  call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { ssp }