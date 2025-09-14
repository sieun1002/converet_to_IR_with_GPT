; ModuleID = 'qs_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %arr.idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4
  store i64 10, i64* %len, align 8
  %len.load = load i64, i64* %len, align 8
  %cmp.len = icmp ule i64 %len.load, 1
  br i1 %cmp.len, label %skip_sort, label %do_sort

do_sort:
  %len.load2 = load i64, i64* %len, align 8
  %high = sub i64 %len.load2, 1
  call void @quick_sort(i32* %arr.base, i64 0, i64 %high)
  br label %skip_sort

skip_sort:
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %len.load3 = load i64, i64* %len, align 8
  %loop.cmp = icmp ult i64 %i.val, %len.load3
  br i1 %loop.cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}