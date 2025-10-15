; ModuleID = 'main'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [4 x i8] c"%d \00", align 1

declare void @__main()
declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  call void @__main()
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
  %len_val = load i64, i64* %len, align 8
  %cmp_le1 = icmp ule i64 %len_val, 1
  br i1 %cmp_le1, label %after_sort, label %do_sort

do_sort:
  %len_val2 = load i64, i64* %len, align 8
  %len_minus1 = sub i64 %len_val2, 1
  %right32 = trunc i64 %len_minus1 to i32
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %baseptr, i32 0, i32 %right32)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop_header

loop_header:
  %i_val = load i64, i64* %i, align 8
  %len_val3 = load i64, i64* %len, align 8
  %cmp_jb = icmp ult i64 %i_val, %len_val3
  br i1 %cmp_jb, label %loop_body, label %loop_end

loop_body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i_val
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt_ptr0 = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmt_ptr0, i32 %elem)
  %i_val_next = add i64 %i_val, 1
  store i64 %i_val_next, i64* %i, align 8
  br label %loop_header

loop_end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}