; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4

  store i32 5, i32* %len, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len_val = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arrptr, i32 %len_val)

  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @_Format, i64 0, i64 0
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %len_cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i_val, %len_cur
  br i1 %cmp, label %body, label %done

body:
  %idx64 = sext i32 %i_val to i64
  %elem_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call_printf_num = call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %elem)
  %next = add nsw i32 %i_val, 1
  store i32 %next, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}