; ModuleID = 'recovered'
source_filename = "recovered.ll"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @_printf(i8* noundef, ...)
declare i32 @_putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  store i64 10, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  %cmp = icmp ule i64 %nval, 1
  br i1 %cmp, label %after_sort, label %do_sort

do_sort:
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval2 = load i64, i64* %n, align 8
  %high = add i64 %nval2, -1
  call void @quick_sort(i32* %baseptr, i64 0, i64 %high)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %ncur
  br i1 %cond, label %body, label %done

body:
  %baseptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %baseptr2, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @_putchar(i32 10)
  ret i32 0
}