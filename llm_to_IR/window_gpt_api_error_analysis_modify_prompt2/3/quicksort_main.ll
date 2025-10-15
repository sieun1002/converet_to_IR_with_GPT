; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @quick_sort(i32*, i32, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %arr.1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %arr.1, align 4
  %arr.2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %arr.2, align 4
  %arr.3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %arr.3, align 4
  %arr.4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %arr.4, align 4
  %arr.5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %arr.5, align 4
  %arr.6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %arr.6, align 4
  %arr.7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %arr.7, align 4
  %arr.8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %arr.8, align 4
  %arr.9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %arr.9, align 4
  store i64 10, i64* %len, align 8
  %len.load = load i64, i64* %len, align 8
  %cmp.len = icmp ule i64 %len.load, 1
  br i1 %cmp.len, label %after.sort, label %do.sort

do.sort:
  %lenm1 = add i64 %len.load, -1
  %high = trunc i64 %lenm1 to i32
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr.ptr, i32 0, i32 %high)
  br label %after.sort

after.sort:
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:
  %i = load i64, i64* %idx, align 8
  %len.load2 = load i64, i64* %len, align 8
  %cmp.i = icmp ult i64 %i, %len.load2
  br i1 %cmp.i, label %loop.body, label %loop.end

loop.body:
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %i, 1
  store i64 %inc, i64* %idx, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}