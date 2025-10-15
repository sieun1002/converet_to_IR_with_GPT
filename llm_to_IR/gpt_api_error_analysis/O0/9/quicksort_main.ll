; ModuleID = 'sort_print_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i64, i64)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %len, align 8

  %len.load0 = load i64, i64* %len, align 8
  %cmp.len.gt1 = icmp ugt i64 %len.load0, 1
  br i1 %cmp.len.gt1, label %do_sort, label %after_sort

do_sort:
  %len.load1 = load i64, i64* %len, align 8
  %r = add i64 %len.load1, -1
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr.ptr, i64 0, i64 %r)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.load = load i64, i64* %i, align 8
  %len.load2 = load i64, i64* %len, align 8
  %cmp.i.len = icmp ult i64 %i.load, %len.load2
  br i1 %cmp.i.len, label %loop.body, label %loop.end

loop.body:
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.load
  %val = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %i.next = add i64 %i.load, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}