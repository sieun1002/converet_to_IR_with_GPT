; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00"

declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32]
  %n = alloca i64
  %i = alloca i64

  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9

  store i64 10, i64* %n

  %nld0 = load i64, i64* %n
  %cmp_le1 = icmp ule i64 %nld0, 1
  br i1 %cmp_le1, label %after_sort, label %do_sort

do_sort:
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nld1 = load i64, i64* %n
  %n32 = trunc i64 %nld1 to i32
  %right = add i32 %n32, -1
  call void @quick_sort(i32* %baseptr, i32 0, i32 %right)
  br label %after_sort

after_sort:
  store i64 0, i64* %i
  br label %loop.cond

loop.cond:
  %ild = load i64, i64* %i
  %nld2 = load i64, i64* %n
  %cmp_lt = icmp ult i64 %ild, %nld2
  br i1 %cmp_lt, label %loop.body, label %loop.end

loop.body:
  %baseptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %baseptr2, i64 %ild
  %elem = load i32, i32* %elem.ptr
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add i64 %ild, 1
  store i64 %inc, i64* %i
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}