; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4
  store i64 10, i64* %n, align 8
  %nval = load i64, i64* %n, align 8
  %cmp = icmp ule i64 %nval, 1
  br i1 %cmp, label %after_sort, label %do_sort

do_sort:
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval2 = load i64, i64* %n, align 8
  %nminus1 = add i64 %nval2, -1
  %hi32 = trunc i64 %nminus1 to i32
  call void @quick_sort(i32* %base, i32 0, i32 %hi32)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop_cond

loop_body:
  %ival2 = load i64, i64* %i, align 8
  %base2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %base2, i64 %ival2
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %iold = load i64, i64* %i, align 8
  %iinc = add i64 %iold, 1
  store i64 %iinc, i64* %i, align 8
  br label %loop_cond

loop_cond:
  %ival = load i64, i64* %i, align 8
  %nval3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %ival, %nval3
  br i1 %cmp2, label %loop_body, label %after_loop

after_loop:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}