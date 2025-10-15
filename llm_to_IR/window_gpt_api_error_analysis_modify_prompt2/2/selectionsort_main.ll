target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8* noundef, ...)
declare void @selection_sort(i32* noundef, i32 noundef)

define i32 @main(i32 noundef %argc, i8** noundef %argv) {
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
  %lenval = load i32, i32* %len, align 4
  call void @selection_sort(i32* noundef %arrptr, i32 noundef %lenval)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt1)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.cur, %len.cur
  br i1 %cmp, label %body, label %exit

body:
  %idxext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

exit:
  ret i32 0
}