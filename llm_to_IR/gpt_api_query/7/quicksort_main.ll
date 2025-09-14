; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* nocapture, i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 10
  store i64 10, i64* %n, align 8

  ; initialize arr = {9,1,5,3,7,2,8,6,4,0}
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4

  ; if (n > 1) quick_sort(arr, 0, n-1)
  %nval0 = load i64, i64* %n, align 8
  %cmp_n_le_1 = icmp ule i64 %nval0, 1
  br i1 %cmp_n_le_1, label %skip_sort, label %do_sort

do_sort:
  %right = add i64 %nval0, -1
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrptr, i64 0, i64 %right)
  br label %skip_sort

skip_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %idx = load i64, i64* %i, align 8
  %nval = load i64, i64* %n, align 8
  %cont = icmp ult i64 %idx, %nval
  br i1 %cont, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %next = add i64 %idx, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { sspstrong }