; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [4 x i8] c"%d \00"

declare void @__main()
declare void @insertion_sort(i32*, i64)
declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32]
  %len = alloca i64
  %i = alloca i64
  call void @__main()
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9
  store i64 10, i64* %len
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len
  call void @insertion_sort(i32* %arrptr, i64 %lenval)
  store i64 0, i64* %i
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i
  %len.cur = load i64, i64* %len
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i
  br label %loop.cond

after.loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}