; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i32, i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8ptr, align 4
  %arr9ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9ptr, align 4

  store i64 10, i64* %len, align 8

  %lenval = load i64, i64* %len, align 8
  %cmp = icmp ule i64 %lenval, 1
  br i1 %cmp, label %after_sort, label %do_sort

do_sort:
  %lenval2 = load i64, i64* %len, align 8
  %lenminus1 = add i64 %lenval2, -1
  %right = trunc i64 %lenminus1 to i32
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrptr, i32 0, i32 %right)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop_cond

loop_body:
  %i_val1 = load i64, i64* %i, align 8
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i_val1
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem)
  %i_val2 = add i64 %i_val1, 1
  store i64 %i_val2, i64* %i, align 8
  br label %loop_cond

loop_cond:
  %i_val3 = load i64, i64* %i, align 8
  %lenval3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %i_val3, %lenval3
  br i1 %cmp2, label %loop_body, label %after_loop

after_loop:
  %call_putchar = call i32 @putchar(i32 10)
  ret i32 0
}