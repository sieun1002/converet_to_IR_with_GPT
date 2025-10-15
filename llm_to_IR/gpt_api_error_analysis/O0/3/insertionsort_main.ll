; ModuleID = 'main_insertion_sort'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 10, i64* %len, align 8

  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0.ptr, align 4
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2.ptr, align 4
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4.ptr, align 4
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6.ptr, align 4
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8.ptr, align 4
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9.ptr, align 4

  %len.load0 = load i64, i64* %len, align 8
  call void @insertion_sort(i32* %arr.elem0.ptr, i64 %len.load0)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.load = load i64, i64* %i, align 8
  %len.load1 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.load, %len.load1
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.load
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.load, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}