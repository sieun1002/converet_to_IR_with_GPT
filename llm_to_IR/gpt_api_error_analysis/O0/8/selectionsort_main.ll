; ModuleID = 'main_module'
target triple = "x86_64-unknown-linux-gnu"

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@fmt_int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4

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

  store i32 5, i32* %len, align 4

  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len.val0 = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arr.base, i32 %len.val0)

  %fmt0.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt0.ptr)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt1.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @fmt_int, i64 0, i64 0
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i32 %elem.val)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}