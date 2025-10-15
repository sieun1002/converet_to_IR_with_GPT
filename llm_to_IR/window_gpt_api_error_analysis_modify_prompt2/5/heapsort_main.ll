; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @heap_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
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
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n = load i64, i64* %len, align 8
  call void @heap_sort(i32* %base, i64 %n)
  store i64 0, i64* %i, align 8
  br label %cond

cond:
  %i_val = load i64, i64* %i, align 8
  %len_val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i_val, %len_val
  br i1 %cmp, label %body, label %exit

body:
  %elem_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i_val
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i_old = load i64, i64* %i, align 8
  %i_next = add i64 %i_old, 1
  store i64 %i_next, i64* %i, align 8
  br label %cond

exit:
  ret i32 0
}