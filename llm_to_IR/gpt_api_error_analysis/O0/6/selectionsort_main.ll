; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 5, i32* %len, align 4
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4.ptr, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len.load0 = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arrdecay, i32 %len.load0)
  %fmt.sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt.sorted.ptr)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %i.ext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.d.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr, i32 %val)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

loop.end:
  ret i32 0
}