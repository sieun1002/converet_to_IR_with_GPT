; ModuleID = 'from-ida-main'
source_filename = "from-ida-main"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %e0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %e9, align 4

  store i64 10, i64* %len, align 8

  ; call insertion_sort(&arr[0], len)
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenv = load i64, i64* %len, align 8
  call void @insertion_sort(i32* noundef %arrdecay, i64 noundef %lenv)

  ; for (i = 0; i < len; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %lenv2
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %elem)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}